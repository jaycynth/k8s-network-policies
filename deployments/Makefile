deployUser:
	kubectl apply -f deployment.yaml
	kubectl apply -f service.yaml

deleteUser:
	kubectl delete -f deployment.yaml
	kubectl delete -f service.yaml

deployMysql:
	kubectl apply -f mysql-pvc.yaml
	kubectl apply -f mysql-deployment.yaml
	kubectl apply -f mysql-service.yaml

verify:
	kubectl get pods
	kubectl get services
	kubectl get pvc


logs:
	kubectl logs -l app=$(APP_NAME)


deployPolicies:
	kubectl apply -f allow-mysql-to-user-policy.yaml
	kubectl apply -f allow-user-to-mysql-policy.yaml
	kubectl apply -f deny-user-policy.yaml


getAllPods:
	kubectl get pods --all-namespaces


accessUserService:
	kubectl port-forward service/user 50051:50051

viewCiliumLogs:
	kubectl -n kube-system logs -l k8s-app=cilium


startK0sCluster:
	k0sctl apply --config k0sctl.yaml

