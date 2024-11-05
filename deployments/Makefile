#TERRAFORM
terraform init
terraform  apply


terraform destroy


#Move key to server
scp -i kos_k8s.pem kos_k8s.pem ubuntu@34.242.131.250:~/.ssh/
chmod 600 /home/ubuntu/.ssh/kos_k8s.pem

# for the ubeconfig
mkdir .kube

#Install Ansible
sudo apt update && sudo apt upgrade -y
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y



#incase of replicas on operator
kubectl scale deployment cilium-operator --replicas=1 -n kube-system


kubectl apply -f https://raw.githubusercontent.com/cilium/cilium/1.16.3/examples/kubernetes/addons/prometheus/monitoring-example.yaml

#Expose services
kubectl port-forward -n kube-system svc/hubble-ui --address 0.0.0.0 --address ::  31534:80
kubectl port-forward -n kube-system svc/grafana --address 0.0.0.0 --address ::  3000:3000
kubectl port-forward -n kube-system svc/prometheus --address 0.0.0.0 --address ::  9090:9090


#Edit to nodeport
kubectl edit svc hubble-ui -n kube-system 


#scp ansible to controller
scp -i C:/Users/onfon/Projects/k8s-network-policies/infra/kos_k8s.pem ./*  ubuntu@34.249.21.244:


#scp deployments to worker
scp -i C:/Users/onfon/Projects/k8s-network-policies/infra/kos_k8s.pem ./*  ubuntu@34.249.21.244:\deployments

kubectl get configmap coredns -n kube-system -o yaml
kubectl edit configmap coredns -n kube-system // change to 8.8.8.8 from /etc/resolv.conf



 sudo chown -R 65534:65534 /mnt/data/prometheus
 ls -ld /mnt/data/prometheus


#TRANSFER KUBECONFIG FROM  REMOTE CLUSTER
sudo cp /var/lib/k0s/pki/admin.conf /home/ubuntu/admin.conf
sudo chown ubuntu:ubuntu /home/ubuntu/admin.conf

scp -i C:/Users/path/Projects/k8s-network-policies/infra/k0s_controller.pem ubuntu@54.194.89.18:/home/ubuntu/admin.conf C:/Users/path/.kube/config

insecure-skip-tls-verify: true


# CILIUM HUBBLE COMMANDS
cilium hubble enable --ui
cilium hubble ui
cilium status --wait


$ kubectl apply -f https://raw.githubusercontent.com/cilium/cilium/1.16.3/examples/kubernetes/addons/prometheus/monitoring-example.yaml


kubectl rollout restart daemonset cilium -n kube-system

kubectl get deployment cilium-operator -n kube-system -o yaml

kubectl port-forward -n kube-system svc/hubble-ui 12000:80

kubectl get ciliumnetworkpolicy  --all-namespaces



# NETWORK POLICIES
kubectl get ciliumnetworkpolicies -n default
kubectl delete ciliumnetworkpolicy allow-all-egress -n default
kubectl apply -f cilium-policy.yaml



#DNS ISSUE
kubectl get configmap coredns -n kube-system -o yaml
kubectl edit configmap coredns -n kube-system // change to 8.8.8.8 from /etc/resolv.conf


$ kubectl -n cilium-monitoring port-forward service/prometheus --address 0.0.0.0 --address :: 9090:9090
$ kubectl -n cilium-monitoring port-forward service/grafana --address 0.0.0.0 --address :: 3000:3000
$ kubectl -n default port-forward service/user 50051:50051 --address 0.0.0.0


#EXEC INTO POD
kubectl exec -it user-7ff7bb4646-5mrdq -- //bin//sh


kubectl exec -it <authorized-pod> -- mysql -h <mysql-service-ip> -u <user> -p<password>



kubectl get pods --all-namespaces -o wide

kubectl apply -f mysql.yaml


kubectl apply -f user-service.yaml


kubectl apply -f unauthorized.yaml



kubectl delete deployment user



kubectl get pods --namespace kube-system
kubectl get deployments --namespace kube-system
kubectl get daemonsets --namespace kube-system
kubectl get services --namespace kube-system