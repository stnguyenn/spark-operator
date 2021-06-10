
K=kubectl
H=helm
M=minikube
R=my-prom

PROM_NS=default
PROM_POD?=my-prom-prometheus-server

default:

mini:
	@$(M) delete
	@$(M) start --cpus 4 --memory 8g

init: mini
	$(H) repo add prometheus-community https://prometheus-community.github.io/helm-charts
	$(H) repo add kube-state-metrics https://kubernetes.github.io/kube-state-metrics
	$(H) repo update

install: init
	$(H) install $(R) prometheus-community/prometheus

forward:
	@$(K) port-forward -n $(PROM_NS) $(PROM_POD) 9090:9090

