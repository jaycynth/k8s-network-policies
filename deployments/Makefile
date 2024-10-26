kubectl get pods --all-namespaces -o wide

kubectl apply -f mysql.yaml


kubectl apply -f user-service.yaml


kubectl apply -f unauthorized.yaml



kubectl delete deployment user



kubectl get pods --namespace kube-system
kubectl get deployments --namespace kube-system
kubectl get daemonsets --namespace kube-system
kubectl get services --namespace kube-system




#TERRAFORM
terraform init
terraform  apply




#TRANSFER KUBECONFIG FROM  REMOTE CLUSTER
sudo cp /var/lib/k0s/pki/admin.conf /home/ubuntu/admin.conf
sudo chown ubuntu:ubuntu /home/ubuntu/admin.conf

scp -i C:/Users/path/Projects/k8s-network-policies/infra/k0s_controller.pem ubuntu@54.194.89.18:/home/ubuntu/admin.conf C:/Users/path/.kube/config

insecure-skip-tls-verify: true


# CILIUM HUBBLE COMMANDS
cilium hubble enable --ui
cilium hubble ui
cilium status --wait


kubectl rollout restart daemonset cilium -n kube-system

kubectl get deployment cilium-operator -n kube-system -o yaml

kubectl port-forward -n kube-system svc/hubble-ui 12000:80



# NETWORK POLICIES
kubectl get ciliumnetworkpolicies -n default
kubectl delete ciliumnetworkpolicy allow-all-egress -n default
kubectl apply -f cilium-policy.yaml



#DNS ISSUE
kubectl get configmap coredns -n kube-system -o yaml
kubectl edit configmap coredns -n kube-system // change to 8.8.8.8 from /etc/resolv.conf


#EXEC INTO POD
kubectl exec -it user-7ff7bb4646-5mrdq -- //bin//sh


kubectl exec -it <authorized-pod> -- mysql -h <mysql-service-ip> -u <user> -p<password>



