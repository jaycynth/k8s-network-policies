KUBECTL = kubectl
DEPLOYMENT_FILE = deployment.yaml
SERVICE_FILE = service.yaml
APP_NAME = user


# Default target
all: deploy

# Deploy the application
deployUser:
	$(KUBECTL) apply -f $(DEPLOYMENT_FILE)
	$(KUBECTL) apply -f $(SERVICE_FILE)

deployMysql:
	$(KUBECTL) apply -f mysql-pvc.yaml
	$(KUBECTL) apply -f mysql-deployment.yaml
	$(KUBECTL) apply -f mysql-service.yaml

verify:
	$(KUBECTL) get pods
	$(KUBECTL) get services
	$(KUBECTL) get pvc


# Delete the application
delete:
	$(KUBECTL) delete -f $(DEPLOYMENT_FILE)
	$(KUBECTL) delete -f $(SERVICE_FILE)

# Get the status of deployments and services
status:
	$(KUBECTL) get deployments
	$(KUBECTL) get services

# Show logs for the application pods
logs:
	$(KUBECTL) logs -l app=$(APP_NAME)


deployPolicies:
	kubectl apply -f allow-mysql-to-user-policy.yaml
	kubectl apply -f allow-user-to-mysql-policy.yaml
	kubectl apply -f deny-user-policy.yaml


getAllPods:
	kubectl get pods --all-namespaces


accessUserService:
	kubectl port-forward service/user 50051:50051
