
SPARK_OPS_CHART=./spark-on-k8s-operator/charts/spark-operator-chart
SPARK_OPS_NS=sparkops
SPARK_JOB_NS=sparkapp
SPARK_OPS_RL=sparkops
SPARK_JOB_CF=./spark-on-k8s-operator/examples/spark-pi-prometheus.yaml
APP_SA=spark

.PHONY: default
default:
	@echo hello spark

minikube:
	@minikube delete
	@minikube start --cpus 8 --memory 8g

.PHONY: spark_ops
spark_ops: minikube
	@kubectl create ns $(SPARK_JOB_NS)
	@kubectl create serviceaccount $(APP_SA) --namespace=$(SPARK_JOB_NS) 
	@kubectl create clusterrolebinding $(SPARK_JOB_NS)-role \
		--clusterrole=edit \
		--serviceaccount=$(SPARK_JOB_NS):$(APP_SA) \
		--namespace=$(SPARK_JOB_NS)		
	@helm upgrade --install $(SPARK_OPS_RL) $(SPARK_OPS_CHART) -n $(SPARK_OPS_NS) --create-namespace --set sparkJobNamespace=$(SPARK_JOB_NS)

.PHONY: del_spark_ops
del_spark_ops:
	@helm delete $(SPARK_OPS_RL) -n $(SPARK_OPS_NS)
	@kubectl delete ns $(SPARK_OPS_NS) $(SPARK_JOB_NS)

spark_app:
	@kubectl delete -f $(SPARK_JOB_CF) -n $(SPARK_JOB_NS)
	@kubectl apply -f $(SPARK_JOB_CF) -n $(SPARK_JOB_NS)



