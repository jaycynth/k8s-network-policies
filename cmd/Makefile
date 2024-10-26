# Variables
SERVICE = k8s-network-policies-user
IMAGE_NAME = jaycynth/$(SERVICE)
VERSION = v0.2
DOCKERFILE = Dockerfile



# Compile the application 
compile:
	@GOOS=linux CGO_ENABLED=0 go build -tags netgo -installsuffix netgo -v -o service .

# Build the Docker image
docker_build:
	docker buildx build -t $(IMAGE_NAME):$(VERSION) -f $(DOCKERFILE) .

# Tag the Docker image
docker_tag:
	docker tag $(IMAGE_NAME):$(VERSION) $(IMAGE_NAME):$(VERSION)

# Push the Docker image to the registry
docker_push:
	docker push $(IMAGE_NAME):$(VERSION)

# Build, tag, and push the service
build_service: compile docker_build docker_tag docker_push


exec to mysql : kubectl exec -it <mysql-pod-name> -- mysql -u root -p
