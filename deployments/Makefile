
startClusterK0s:
	k0sctl apply --config k0s-config.yaml

startClusterKind:
	kind create cluster --config kind-config.yaml

deployUser:
	kubectl apply -f user.yaml

deleteUser:
	kubectl delete -f user.yaml

deployMysql:
	kubectl apply -f mysql.yaml
	
deployPolicies:
	kubectl apply -f policy.yaml
	
getAllPods:
	kubectl get pods --all-namespaces

accessUserService:
	kubectl port-forward service/user 50051:50051

accessHubble:
	kubectl -n kube-system port-forward service/hubble-ui 12000:80

viewCiliumLogs:
	kubectl -n kube-system logs -l k8s-app=cilium


