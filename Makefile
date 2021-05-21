

DASHBOARD=https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-rc6/aio/deploy/recommended.yaml
KIND_CONFIG=cluster-config.yml
METAL_CONFIG=metallb-configmap.yml #https://kind.sigs.k8s.io/examples/loadbalancer/metallb-configmap.yaml
METAL_USAGE=usage.yaml #https://kind.sigs.k8s.io/examples/loadbalancer/usage.yaml

.PHONY: default
default:
	@echo hello kube

.PHONY: metallb
metallb: 
	@kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/master/manifests/namespace.yaml
	@kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)" 
	@kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/master/manifests/metallb.yaml

.PHONY: config_metallb
config_metallb:
	@docker network inspect -f '{{.IPAM.Config}}' kind 
	@kubectl apply -f $(METAL_CONFIG)
	@kubectl apply -f $(METAL_USAGE)
	@kubectl get svc/foo-service -o=jsonpath='{.status.loadBalancer.ingress[0].ip}'
	
# @for _ in {1..10}; do curl 172.18.255.200:5678 done
# @kubectl get pods -n metallb-system --watch


.PHONY: kind
kind: 
	@kind delete cluster
	@kind create cluster --config=$(KIND_CONFIG)
	@kubectl apply -f $(DASHBOARD)

.PHONY: nginx
nginx: 
	@kubectl create deployment nginx --image=nginx --port=80
	@kubectl create service nodeport nginx --tcp=80:80 --node-port=30000
	@curl localhost:30000

.PHONY: minik
minik: 
	@minikube delete
	@minikube start --cpus 4 --memory 4g 
	@minikube addons enable metallb
	@minikube ip
	@minikube addons configure metallb
	@minikube addons enable metrics-server
	@minikube addons enable dashboard


