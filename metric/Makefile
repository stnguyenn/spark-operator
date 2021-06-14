
default:


M=minikube

run: monns prom grafa grafapw

mini: nuke
	$(M) start 

nuke: 
	$(M) delete

H=helm
K=kubectl
PF=port-forward
PROMCHART=./helm-charts-prom/charts/prometheus
MONITORNS=monitoring

POD_PROM?=$(shell kubectl get pods --namespace monitoring -l "app=prometheus,component=server" -o jsonpath="{.items[0].metadata.name}")
POD_GRAF?=$(shell kubectl get pods --namespace monitoring -l "app.kubernetes.io/name=grafana" -o jsonpath="{.items[0].metadata.name}")

monns:
	$(K) delete ns $(MONITORNS) --ignore-not-found 
	$(K) create ns $(MONITORNS)

PROMRL?=my-prom

prom:
	$(H) dependency update $(PROMCHART) 
	$(H) upgrade --install $(PROMRL) $(PROMCHART) -n $(MONITORNS) 

promserve:
	$(K) -n $(MONITORNS) $(PF) $(POD_PROM) 9090

GRAFACHART?=./helm-charts-grafa/charts/grafana
GRAFARL?=my-grafa

grafa:
	$(H) upgrade --install $(GRAFARL) $(GRAFACHART) -n $(MONITORNS)

grafserve:
	$(K) -n $(MONITORNS) $(PF) $(POD_GRAF) 3000

grafapw:
	$(K) get secret --namespace $(MONITORNS) $(GRAFARL)-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

