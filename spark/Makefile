
SPARK_OPS_CHART=./spark-on-k8s-operator/charts/spark-operator-chart
SPARK_OPS_NS=sparkops
SPARK_JOB_NS=sparkapp
SPARK_OPS_RL=sparkops

.PHONY: default
default:
	@echo hello spark

.PHONY: spark_ops
spark_ops:
	@kubectl create ns $(SPARK_JOB_NS)
	@helm upgrade --install $(SPARK_OPS_RL) $(SPARK_OPS_CHART) -n $(SPARK_OPS_NS) --create-namespace --set sparkJobNamespace=$(SPARK_JOB_NS)

.PHONY: del_spark_ops
del_spark_ops:
	@helm delete $(SPARK_OPS_RL) -n $(SPARK_OPS_NS)
	@kubectl delete ns $(SPARK_OPS_NS) $(SPARK_JOB_NS)

