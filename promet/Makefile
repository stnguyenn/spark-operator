
# prometheus-community/kube-prometheus-stack
CHART=./helm-charts/charts/kube-prometheus-stack
NS="monitoring"
EX_APP=example-app.yml

default:
	@echo hello-promet

minikube:
	@minikube delete
	@minikube start --cpus 4 --memory 4g
	
# @minikube start --cpus 4 --memory 4g

update: 
	@cd ./helm-charts/charts/kube-prometheus-stack && helm dependency update

promet: minikube
	@kubectl create namespace $(NS)
	@helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	@helm repo update
	@helm install prometheus $(CHART) -n $(NS)

svc_prom:
	@minikube service prometheus-kube-prometheus-prometheus -n monitoring

example_app:
	@kubectl apply -f $(EX_APP)

bundle:
	@kubectl apply -f bundle.yml



