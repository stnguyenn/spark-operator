
# prometheus-community/kube-prometheus-stack
CHART=./helm-charts/charts/kube-prometheus-stack
NS="monitoring"
EX_APP=example-app.yml
HELM=helm
RBAC=prom_rbac.yaml
SAMPLE_PROM=prometheus.yaml
PROM_STACK=prom_stack.yml
GRAF_ING=ingress.yml

default:
	@echo hello-promet

minikube:
	@minikube delete
	@minikube start --cpus 4 --memory 4g
	
# @minikube start --cpus 4 --memory 4g

update: 
	@cd ./helm-charts/charts/kube-prometheus-stack && $(HELM) dependency update

template:
	@$(HELM) template prometheus $(CHART) -n $(NS) > log.yml

promet: #minikube
	@kubectl create namespace $(NS)
	@$(HELM) repo add prometheus-community https://prometheus-community.github.io/helm-charts
	@$(HELM) repo update
	@$(HELM) install prometheus $(CHART) -n $(NS)

grafa_ing:
	@kubectl apply -f $(GRAF_ING)

svc_prom:
	@minikube service prometheus-kube-prometheus-prometheus -n monitoring

svc_grafa:
	@kubectl port-forward --namespace monitoring service/prometheus-grafana 3000:80

prom_stack:
	@kubectl apply -f $(PROM_STACK)

sample_promet:
	@kubectl apply -f $(SAMPLE_PROM)

bundle_rbac:
	@kubectl apply -f $(RBAC)

bundle: minikube
	@kubectl apply -f bundle.yml

svc_bund:
	@minikube service prometheus-operated

svc_sample:
	@kubectl port-forward svc/prometheus 9090

