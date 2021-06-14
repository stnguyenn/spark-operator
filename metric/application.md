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

Example of exported metrics from `spark-driver`

```
# HELP jvm_classes_loaded The number of classes that are currently loaded in the JVM
# TYPE jvm_classes_loaded gauge
jvm_classes_loaded 9377.0
# HELP jvm_classes_loaded_total The total number of classes that have been loaded since the JVM has started execution
# TYPE jvm_classes_loaded_total counter
jvm_classes_loaded_total 9380.0
# HELP jvm_classes_unloaded_total The total number of classes that have been unloaded since the JVM has started execution
# TYPE jvm_classes_unloaded_total counter
jvm_classes_unloaded_total 3.0
# HELP jmx_config_reload_failure_total Number of times configuration have failed to be reloaded.
# TYPE jmx_config_reload_failure_total counter
jmx_config_reload_failure_total 0.0
# HELP jvm_buffer_pool_used_bytes Used bytes of a given JVM buffer pool.
# TYPE jvm_buffer_pool_used_bytes gauge
jvm_buffer_pool_used_bytes{pool="direct",} 74695.0
jvm_buffer_pool_used_bytes{pool="mapped",} 0.0
# HELP jvm_buffer_pool_capacity_bytes Bytes capacity of a given JVM buffer pool.
# TYPE jvm_buffer_pool_capacity_bytes gauge
jvm_buffer_pool_capacity_bytes{pool="direct",} 74694.0
jvm_buffer_pool_capacity_bytes{pool="mapped",} 0.0
# HELP jvm_buffer_pool_used_buffers Used buffers of a given JVM buffer pool.
# TYPE jvm_buffer_pool_used_buffers gauge
jvm_buffer_pool_used_buffers{pool="direct",} 10.0
jvm_buffer_pool_used_buffers{pool="mapped",} 0.0
# HELP jvm_memory_bytes_used Used bytes of a given JVM memory area.
# TYPE jvm_memory_bytes_used gauge
jvm_memory_bytes_used{area="heap",} 1.1847384E8
jvm_memory_bytes_used{area="nonheap",} 9.0756784E7
# HELP jvm_memory_bytes_committed Committed (bytes) of a given JVM memory area.
# TYPE jvm_memory_bytes_committed gauge
jvm_memory_bytes_committed{area="heap",} 2.20381184E8
jvm_memory_bytes_committed{area="nonheap",} 9.9483648E7
# HELP jvm_memory_bytes_max Max (bytes) of a given JVM memory area.
# TYPE jvm_memory_bytes_max gauge
jvm_memory_bytes_max{area="heap",} 5.18979584E8
jvm_memory_bytes_max{area="nonheap",} -1.0
# HELP jvm_memory_bytes_init Initial bytes of a given JVM memory area.
# TYPE jvm_memory_bytes_init gauge
jvm_memory_bytes_init{area="heap",} 1.4680064E7
jvm_memory_bytes_init{area="nonheap",} 2555904.0
# HELP jvm_memory_pool_bytes_used Used bytes of a given JVM memory pool.
# TYPE jvm_memory_pool_bytes_used gauge
jvm_memory_pool_bytes_used{pool="Code Cache",} 2.0454272E7
jvm_memory_pool_bytes_used{pool="Metaspace",} 6.2057112E7
jvm_memory_pool_bytes_used{pool="Compressed Class Space",} 8245400.0
jvm_memory_pool_bytes_used{pool="Eden Space",} 1.6275784E7
jvm_memory_pool_bytes_used{pool="Survivor Space",} 3847208.0
jvm_memory_pool_bytes_used{pool="Tenured Gen",} 9.8350848E7
# HELP jvm_memory_pool_bytes_committed Committed bytes of a given JVM memory pool.
# TYPE jvm_memory_pool_bytes_committed gauge
jvm_memory_pool_bytes_committed{pool="Code Cache",} 2.3199744E7
jvm_memory_pool_bytes_committed{pool="Metaspace",} 6.750208E7
jvm_memory_pool_bytes_committed{pool="Compressed Class Space",} 8781824.0
jvm_memory_pool_bytes_committed{pool="Eden Space",} 6.0817408E7
jvm_memory_pool_bytes_committed{pool="Survivor Space",} 7602176.0
jvm_memory_pool_bytes_committed{pool="Tenured Gen",} 1.519616E8
# HELP jvm_memory_pool_bytes_max Max bytes of a given JVM memory pool.
# TYPE jvm_memory_pool_bytes_max gauge
jvm_memory_pool_bytes_max{pool="Code Cache",} 2.5165824E8
jvm_memory_pool_bytes_max{pool="Metaspace",} -1.0
jvm_memory_pool_bytes_max{pool="Compressed Class Space",} 1.073741824E9
jvm_memory_pool_bytes_max{pool="Eden Space",} 1.43130624E8
jvm_memory_pool_bytes_max{pool="Survivor Space",} 1.7891328E7
jvm_memory_pool_bytes_max{pool="Tenured Gen",} 3.57957632E8
# HELP jvm_memory_pool_bytes_init Initial bytes of a given JVM memory pool.
# TYPE jvm_memory_pool_bytes_init gauge
jvm_memory_pool_bytes_init{pool="Code Cache",} 2555904.0
jvm_memory_pool_bytes_init{pool="Metaspace",} 0.0
jvm_memory_pool_bytes_init{pool="Compressed Class Space",} 0.0
jvm_memory_pool_bytes_init{pool="Eden Space",} 3932160.0
jvm_memory_pool_bytes_init{pool="Survivor Space",} 458752.0
jvm_memory_pool_bytes_init{pool="Tenured Gen",} 9830400.0
# HELP jvm_info JVM version info
# TYPE jvm_info gauge
jvm_info{version="1.8.0_252-b09",vendor="Oracle Corporation",runtime="OpenJDK Runtime Environment",} 1.0
# HELP process_cpu_seconds_total Total user and system CPU time spent in seconds.
# TYPE process_cpu_seconds_total counter
process_cpu_seconds_total 42.74
# HELP process_start_time_seconds Start time of the process since unix epoch in seconds.
# TYPE process_start_time_seconds gauge
process_start_time_seconds 1.6235503065E9
# HELP process_open_fds Number of open file descriptors.
# TYPE process_open_fds gauge
process_open_fds 313.0
# HELP process_max_fds Maximum number of open file descriptors.
# TYPE process_max_fds gauge
process_max_fds 1048576.0
# HELP process_virtual_memory_bytes Virtual memory size in bytes.
# TYPE process_virtual_memory_bytes gauge
process_virtual_memory_bytes 4.174671872E9
# HELP process_resident_memory_bytes Resident memory size in bytes.
# TYPE process_resident_memory_bytes gauge
process_resident_memory_bytes 4.11172864E8
# HELP jmx_config_reload_success_total Number of times configuration have successfully been reloaded.
# TYPE jmx_config_reload_success_total counter
jmx_config_reload_success_total 0.0
# HELP spark_driver_codegenerator_generatedmethodsize_type_histograms_count Attribute exposed for management (metrics<name=sparkapp.spark-pi-1.driver.CodeGenerator.generatedMethodSize, type=histograms><>Count)
# TYPE spark_driver_codegenerator_generatedmethodsize_type_histograms_count counter
spark_driver_codegenerator_generatedmethodsize_type_histograms_count{app_id="spark-pi-1",app_namespace="sparkapp",} 0.0
# HELP spark_driver_livelistenerbus_queue_shared_size_type_gauges Attribute exposed for management (metrics<name=sparkapp.spark-pi-1.driver.LiveListenerBus.queue.shared.size, type=gauges><>Value)
# TYPE spark_driver_livelistenerbus_queue_shared_size_type_gauges gauge
spark_driver_livelistenerbus_queue_shared_size_type_gauges{app_id="spark-pi-1",app_namespace="sparkapp",} 0.0
# HELP spark_driver_codegenerator_sourcecodesize_type_histograms_count Attribute exposed for management (metrics<name=sparkapp.spark-pi-1.driver.CodeGenerator.sourceCodeSize, type=histograms><>Count)
# TYPE spark_driver_codegenerator_sourcecodesize_type_histograms_count counter
spark_driver_codegenerator_sourcecodesize_type_histograms_count{app_id="spark-pi-1",app_namespace="sparkapp",} 0.0
# HELP spark_driver_livelistenerbus_queue_appstatus_listenerprocessingtime_type_timers_count Attribute exposed for management (metrics<name=sparkapp.spark-pi-1.driver.LiveListenerBus.queue.appStatus.listenerProcessingTime, type=timers><>Count)
# TYPE spark_driver_livelistenerbus_queue_appstatus_listenerprocessingtime_type_timers_count counter
spark_driver_livelistenerbus_queue_appstatus_listenerprocessingtime_type_timers_count{app_id="spark-pi-1",app_namespace="sparkapp",} 42127.0
# HELP spark_driver_livelistenerbus_queue_shared_listenerprocessingtime_type_timers_count Attribute exposed for management (metrics<name=sparkapp.spark-pi-1.driver.LiveListenerBus.queue.shared.listenerProcessingTime, type=timers><>Count)
# TYPE spark_driver_livelistenerbus_queue_shared_listenerprocessingtime_type_timers_count counter
spark_driver_livelistenerbus_queue_shared_listenerprocessingtime_type_timers_count{app_id="spark-pi-1",app_namespace="sparkapp",} 42138.0
# HELP spark_driver_livelistenerbus_queue_shared_numdroppedevents_type_counters_count Attribute exposed for management (metrics<name=sparkapp.spark-pi-1.driver.LiveListenerBus.queue.shared.numDroppedEvents, type=counters><>Count)
# TYPE spark_driver_livelistenerbus_queue_shared_numdroppedevents_type_counters_count counter
spark_driver_livelistenerbus_queue_shared_numdroppedevents_type_counters_count{app_id="spark-pi-1",app_namespace="sparkapp",} 0.0
# HELP spark_driver_livelistenerbus_queue_executormanagement_numdroppedevents_type_counters_count Attribute exposed for management (metrics<name=sparkapp.spark-pi-1.driver.LiveListenerBus.queue.executorManagement.numDroppedEvents, type=counters><>Count)
# TYPE spark_driver_livelistenerbus_queue_executormanagement_numdroppedevents_type_counters_count counter
spark_driver_livelistenerbus_queue_executormanagement_numdroppedevents_type_counters_count{app_id="spark-pi-1",app_namespace="sparkapp",} 0.0
# HELP spark_driver_livelistenerbus_queue_executormanagement_listenerprocessingtime_type_timers_count Attribute exposed for management (metrics<name=sparkapp.spark-pi-1.driver.LiveListenerBus.queue.executorManagement.listenerProcessingTime, type=timers><>Count)
# TYPE spark_driver_livelistenerbus_queue_executormanagement_listenerprocessingtime_type_timers_count counter
spark_driver_livelistenerbus_queue_executormanagement_listenerprocessingtime_type_timers_count{app_id="spark-pi-1",app_namespace="sparkapp",} 42115.0
# HELP spark_driver_codegenerator_generatedclasssize_type_histograms_count Attribute exposed for management (metrics<name=sparkapp.spark-pi-1.driver.CodeGenerator.generatedClassSize, type=histograms><>Count)
# TYPE spark_driver_codegenerator_generatedclasssize_type_histograms_count counter
spark_driver_codegenerator_generatedclasssize_type_histograms_count{app_id="spark-pi-1",app_namespace="sparkapp",} 0.0
# HELP spark_driver_livelistenerbus_listenerprocessingtime_org_apache_spark_status_appstatuslistener_type_timers_count Attribute exposed for management (metrics<name=sparkapp.spark-pi-1.driver.LiveListenerBus.listenerProcessingTime.org.apache.spark.status.AppStatusListener, type=timers><>Count)
# TYPE spark_driver_livelistenerbus_listenerprocessingtime_org_apache_spark_status_appstatuslistener_type_timers_count counter
spark_driver_livelistenerbus_listenerprocessingtime_org_apache_spark_status_appstatuslistener_type_timers_count{app_id="spark-pi-1",app_namespace="sparkapp",} 42027.0
# HELP spark_driver_livelistenerbus_listenerprocessingtime_org_apache_spark_sql_sparksession_anon_1_type_timers_count Attribute exposed for management (metrics<name=sparkapp.spark-pi-1.driver.LiveListenerBus.listenerProcessingTime.org.apache.spark.sql.SparkSession$$anon$1, type=timers><>Count)
# TYPE spark_driver_livelistenerbus_listenerprocessingtime_org_apache_spark_sql_sparksession_anon_1_type_timers_count counter
spark_driver_livelistenerbus_listenerprocessingtime_org_apache_spark_sql_sparksession_anon_1_type_timers_count{app_id="spark-pi-1",app_namespace="sparkapp",} 42046.0
# HELP spark_driver_livelistenerbus_queue_appstatus_numdroppedevents_type_counters_count Attribute exposed for management (metrics<name=sparkapp.spark-pi-1.driver.LiveListenerBus.queue.appStatus.numDroppedEvents, type=counters><>Count)
# TYPE spark_driver_livelistenerbus_queue_appstatus_numdroppedevents_type_counters_count counter
spark_driver_livelistenerbus_queue_appstatus_numdroppedevents_type_counters_count{app_id="spark-pi-1",app_namespace="sparkapp",} 0.0
# HELP spark_driver_livelistenerbus_queue_executormanagement_size_type_gauges Attribute exposed for management (metrics<name=sparkapp.spark-pi-1.driver.LiveListenerBus.queue.executorManagement.size, type=gauges><>Value)
# TYPE spark_driver_livelistenerbus_queue_executormanagement_size_type_gauges gauge
spark_driver_livelistenerbus_queue_executormanagement_size_type_gauges{app_id="spark-pi-1",app_namespace="sparkapp",} 0.0
# HELP spark_driver_codegenerator_compilationtime_type_histograms_count Attribute exposed for management (metrics<name=sparkapp.spark-pi-1.driver.CodeGenerator.compilationTime, type=histograms><>Count)
# TYPE spark_driver_codegenerator_compilationtime_type_histograms_count counter
spark_driver_codegenerator_compilationtime_type_histograms_count{app_id="spark-pi-1",app_namespace="sparkapp",} 0.0
# HELP spark_driver_hiveexternalcatalog_partitionsfetched_type_counters_count Attribute exposed for management (metrics<name=sparkapp.spark-pi-1.driver.HiveExternalCatalog.partitionsFetched, type=counters><>Count)
# TYPE spark_driver_hiveexternalcatalog_partitionsfetched_type_counters_count counter
spark_driver_hiveexternalcatalog_partitionsfetched_type_counters_count{app_id="spark-pi-1",app_namespace="sparkapp",} 0.0
# HELP spark_driver_hiveexternalcatalog_hiveclientcalls_type_counters_count Attribute exposed for management (metrics<name=sparkapp.spark-pi-1.driver.HiveExternalCatalog.hiveClientCalls, type=counters><>Count)
# TYPE spark_driver_hiveexternalcatalog_hiveclientcalls_type_counters_count counter
spark_driver_hiveexternalcatalog_hiveclientcalls_type_counters_count{app_id="spark-pi-1",app_namespace="sparkapp",} 0.0
# HELP spark_driver_hiveexternalcatalog_parallellistingjobcount_type_counters_count Attribute exposed for management (metrics<name=sparkapp.spark-pi-1.driver.HiveExternalCatalog.parallelListingJobCount, type=counters><>Count)
# TYPE spark_driver_hiveexternalcatalog_parallellistingjobcount_type_counters_count counter
spark_driver_hiveexternalcatalog_parallellistingjobcount_type_counters_count{app_id="spark-pi-1",app_namespace="sparkapp",} 0.0
# HELP spark_driver_hiveexternalcatalog_filesdiscovered_type_counters_count Attribute exposed for management (metrics<name=sparkapp.spark-pi-1.driver.HiveExternalCatalog.filesDiscovered, type=counters><>Count)
# TYPE spark_driver_hiveexternalcatalog_filesdiscovered_type_counters_count counter
spark_driver_hiveexternalcatalog_filesdiscovered_type_counters_count{app_id="spark-pi-1",app_namespace="sparkapp",} 0.0
# HELP spark_driver_hiveexternalcatalog_filecachehits_type_counters_count Attribute exposed for management (metrics<name=sparkapp.spark-pi-1.driver.HiveExternalCatalog.fileCacheHits, type=counters><>Count)
# TYPE spark_driver_hiveexternalcatalog_filecachehits_type_counters_count counter
spark_driver_hiveexternalcatalog_filecachehits_type_counters_count{app_id="spark-pi-1",app_namespace="sparkapp",} 0.0
# HELP spark_driver_livelistenerbus_queue_appstatus_size_type_gauges Attribute exposed for management (metrics<name=sparkapp.spark-pi-1.driver.LiveListenerBus.queue.appStatus.size, type=gauges><>Value)
# TYPE spark_driver_livelistenerbus_queue_appstatus_size_type_gauges gauge
spark_driver_livelistenerbus_queue_appstatus_size_type_gauges{app_id="spark-pi-1",app_namespace="sparkapp",} 0.0
# HELP spark_driver_livelistenerbus_numeventsposted_type_counters_count Attribute exposed for management (metrics<name=sparkapp.spark-pi-1.driver.LiveListenerBus.numEventsPosted, type=counters><>Count)
# TYPE spark_driver_livelistenerbus_numeventsposted_type_counters_count counter
spark_driver_livelistenerbus_numeventsposted_type_counters_count{app_id="spark-pi-1",app_namespace="sparkapp",} 42061.0
# HELP spark_driver_dagscheduler_messageprocessingtime_type_timers_count Attribute exposed for management (metrics<name=sparkapp.spark-pi-1.driver.DAGScheduler.messageProcessingTime, type=timers><>Count)
# TYPE spark_driver_dagscheduler_messageprocessingtime_type_timers_count counter
spark_driver_dagscheduler_messageprocessingtime_type_timers_count{app_id="spark-pi-1",app_namespace="sparkapp",} 42073.0
# HELP spark_driver_livelistenerbus_listenerprocessingtime_org_apache_spark_heartbeatreceiver_type_timers_count Attribute exposed for management (metrics<name=sparkapp.spark-pi-1.driver.LiveListenerBus.listenerProcessingTime.org.apache.spark.HeartbeatReceiver, type=timers><>Count)
# TYPE spark_driver_livelistenerbus_listenerprocessingtime_org_apache_spark_heartbeatreceiver_type_timers_count counter
spark_driver_livelistenerbus_listenerprocessingtime_org_apache_spark_heartbeatreceiver_type_timers_count{app_id="spark-pi-1",app_namespace="sparkapp",} 42099.0
# HELP jmx_scrape_duration_seconds Time this JMX scrape took, in seconds.
# TYPE jmx_scrape_duration_seconds gauge
jmx_scrape_duration_seconds 0.318607495
# HELP jmx_scrape_error Non-zero if this scrape failed.
# TYPE jmx_scrape_error gauge
jmx_scrape_error 0.0
# HELP jvm_threads_current Current thread count of a JVM
# TYPE jvm_threads_current gauge
jvm_threads_current 62.0
# HELP jvm_threads_daemon Daemon thread count of a JVM
# TYPE jvm_threads_daemon gauge
jvm_threads_daemon 61.0
# HELP jvm_threads_peak Peak thread count of a JVM
# TYPE jvm_threads_peak gauge
jvm_threads_peak 62.0
# HELP jvm_threads_started_total Started thread count of a JVM
# TYPE jvm_threads_started_total counter
jvm_threads_started_total 66.0
# HELP jvm_threads_deadlocked Cycles of JVM-threads that are in deadlock waiting to acquire object monitors or ownable synchronizers
# TYPE jvm_threads_deadlocked gauge
jvm_threads_deadlocked 0.0
# HELP jvm_threads_deadlocked_monitor Cycles of JVM-threads that are in deadlock waiting to acquire object monitors
# TYPE jvm_threads_deadlocked_monitor gauge
jvm_threads_deadlocked_monitor 0.0
# HELP jmx_exporter_build_info A metric with a constant '1' value labeled with the version of the JMX exporter.
# TYPE jmx_exporter_build_info gauge
jmx_exporter_build_info{version="0.11.0",name="jmx_prometheus_javaagent",} 1.0
# HELP jvm_gc_collection_seconds Time spent in a given JVM garbage collector in seconds.
# TYPE jvm_gc_collection_seconds summary
jvm_gc_collection_seconds_count{gc="Copy",} 216.0
jvm_gc_collection_seconds_sum{gc="Copy",} 0.97
jvm_gc_collection_seconds_count{gc="MarkSweepCompact",} 7.0
jvm_gc_collection_seconds_sum{gc="MarkSweepCompact",} 0.635
```
