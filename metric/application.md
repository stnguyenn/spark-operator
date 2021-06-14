# SparkApplication Performance Metric

The operator is able to automatically configure the metric system to expose metrics to Prometheus.

## SparkAppication Configuration

The field `.spec.monitoring` specifies how application monitoring is handled and particularly how metrics are to be reported.

```yaml
apiVersion: "sparkoperator.k8s.io/v1beta2"
kind: SparkApplication
...
spec:
  ...
  driver:
    cores: 1
    coreLimit: "1200m"
    memory: "512m"
    labels:
      version: 3.0.0
      metrics-exposed: "true"
      name: "spark-app"
    serviceAccount: spark
  executor:
    cores: 1
    instances: 1
    memory: "512m"
    labels:
      version: 3.0.0
      metrics-exposed: "true"
      name: "spark-app"
  monitoring:
    exposeDriverMetrics: true
    exposeExecutorMetrics: true
    prometheus:
      jmxExporterJar: "/prometheus/jmx_prometheus_javaagent-0.11.0.jar"
      port: 8090
```

## Prometheus Configuration

The exposed metrics from SparkApplication could be collected via Prometheus deployment's scrape config.

```yaml
## Prometheus server ConfigMap entries
##
serverFiles:
  prometheus.yml:
      - job_name: 'spark-apps'
        kubernetes_sd_configs:
          - role: pod
        relabel_configs:
          - source_labels: [__meta_kubernetes_pod_label_name]
            action: keep
            regex: spark-app
          - source_labels: [__address__]
            action: replace
            regex: ([^:]+):.*
            replacement: $1:8090 # port you want to use
            target_label: __address__  
```

## Metric Sample

```
```
