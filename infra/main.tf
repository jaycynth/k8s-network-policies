provider "aws" {
  region = "eu-west-1"
  access_key = "AKIAVWABJ67OQ6RUS64N"
  secret_key = "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"
}



# Define variables for instance settings
variable "instance_type" {
  default = "t2.medium"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

# Create a VPC
resource "aws_vpc" "k0s_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "k0s-vpc"
  }
}

# Create Subnets
resource "aws_subnet" "k0s_subnet" {
  vpc_id            = aws_vpc.k0s_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-1c"
  map_public_ip_on_launch = true
  tags = {
    Name = "k0s-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "k0s_igw" {
  vpc_id = aws_vpc.k0s_vpc.id
  tags = {
    Name = "k0s-igw"
  }
}

# Route Table
resource "aws_route_table" "k0s_route_table" {
  vpc_id = aws_vpc.k0s_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.k0s_igw.id
  }
}

# Associate Route Table with Subnet
resource "aws_route_table_association" "k0s_route_table_assoc" {
  subnet_id      = aws_subnet.k0s_subnet.id
  route_table_id = aws_route_table.k0s_route_table.id
}

# Security Group to allow SSH and Kubernetes ports
resource "aws_security_group" "k0s_sg" {
  vpc_id = aws_vpc.k0s_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "k0s-sg"
  }
}

# Generate SSH Key Pair
resource "tls_private_key" "k0s" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

output "private_key" {
  value     = tls_private_key.k0s.private_key_pem
  sensitive = true
}

resource "local_file" "k0s_private_key" {
  content  = tls_private_key.k0s.private_key_pem
  filename = "${path.module}/kos_k8s.pem"
  file_permission = "0600"  # Set file permissions to be read/write only for the owner
}


resource "aws_key_pair" "k0s_key_pair" {
  key_name   = "k0s-key"
  public_key = tls_private_key.k0s.public_key_openssh
}

# Controller EC2 instance
resource "aws_instance" "k0s_controller" {
  ami           = "ami-0d64bb532e0502c46"
  instance_type = var.instance_type
  subnet_id     = aws_subnet.k0s_subnet.id
  key_name      = aws_key_pair.k0s_key_pair.key_name
  security_groups = [aws_security_group.k0s_sg.id]

  tags = {
    Name = "k0s-controller"
  }

  provisioner "remote-exec" {
     inline = [ 
    "mkdir -p /home/ubuntu/.ssh",
    "chmod 700 /home/ubuntu/.ssh",
    "curl -sSLf https://get.k0s.sh | sudo sh",
    "sudo k0s install controller",
    "sudo k0s start",
    # Ensure k0s is running before generating the token
    "until sudo k0s status > /dev/null 2>&1; do echo 'Waiting for k0s to start...'; sleep 5; done",
    # Generate the worker token and save to file
    "echo 'k0s is running, generating worker token...'",
    "sudo k0s token create --role worker > /tmp/k0s_worker_token",
    # Verify the token was saved correctly
    "if [ -s /tmp/k0s_worker_token ]; then echo 'Token saved to /tmp/k0s_worker_token'; else echo 'Failed to save token'; fi"
  ]
    connection {
      type     = "ssh"
      user     = "ubuntu"
      private_key = tls_private_key.k0s.private_key_pem
      host     = self.public_ip
    }
  }
}

# Worker EC2 instance
resource "aws_instance" "k0s_worker" {
  ami           = "ami-0d64bb532e0502c46"
  instance_type = var.instance_type
  subnet_id     = aws_subnet.k0s_subnet.id
  key_name      = aws_key_pair.k0s_key_pair.key_name
  security_groups = [aws_security_group.k0s_sg.id]

  tags = {
    Name = "k0s-worker"
  }

  # Join worker node to the cluster using the controller's token
  provisioner "file" {
    content     = tls_private_key.k0s.private_key_pem
    destination = "/home/ubuntu/.ssh/kos_k8s.pem"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = tls_private_key.k0s.private_key_pem
      host        = self.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /home/ubuntu/.ssh",
      "chmod 700 /home/ubuntu/.ssh",
      "chmod 600 /home/ubuntu/.ssh/kos_k8s.pem",  # Fix key file permissions
      "curl -sSLf https://get.k0s.sh | sudo sh",
      "echo 'Fetching the token from the controller...'",
      "ssh -o StrictHostKeyChecking=no -i /home/ubuntu/.ssh/kos_k8s.pem ubuntu@${aws_instance.k0s_controller.public_ip} 'cat /tmp/k0s_worker_token' > /tmp/k0s_worker_token",
      "if [ -f /tmp/k0s_worker_token ]; then echo 'Token file received'; else echo 'Token file not received'; fi",
      "sudo k0s install worker --token-file /tmp/k0s_worker_token",
      "sudo k0s start",
      "until sudo k0s status; do echo 'Waiting for k0s to start...'; sleep 5; done"
    ]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = tls_private_key.k0s.private_key_pem
      host        = self.public_ip
    }
  }
}


# Output the public IPs of the instances
output "controller_public_ip" {
  value = aws_instance.k0s_controller.public_ip
}

output "worker_public_ip" {
  value = aws_instance.k0s_worker.public_ip
}


