# https://medium.com/codex/setup-kuberhealthy-with-prometheus-and-grafana-on-minikube-b2f6da21dc2e

default:
	@echo hello grafana

minikube:
	@minikube delete
	@minikube start --cpus 4 --memory 4g

promet: 
	@kubectl create namespace monitoring
	@helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	@helm repo update
	@helm install prometheus prometheus-community/kube-prometheus-stack -n monitoring

svc-prom:
	@minikube service prometheus-kube-prometheus-prometheus -n monitoring

svc-graf:
	@minikube service prometheus-grafana -n monitoring

# username: admin and password: prom-operator

