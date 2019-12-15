---
title: "Getting started"
date: 2019-12-14
---

Flokkr provides tools and building elements to create your own cluster. It's based on [Flekszible](https://github.com/elek/flekszible) which is a highly flexible Kubernetes resource generator.

To start, install Flekszible and register Flokkr sources:

```yaml
>flekszible source search
Available flekszible repositories:

+------------------------------------+-----------------------------------------------------------------------------+
| name                               | description                                                                 |
+------------------------------------+-----------------------------------------------------------------------------+
| github.com/flokkr/k8s              | Flekszible based kubernetes manfiest templates for Apache bigdata projects. |
| github.com/flokkr/infra-flekszible | Flekszible based Kubernetes recipes for logging/monitoring/ci               |
| github.com/elek/ozone-flekszible   | Apache Hadoop Ozone deployment definitions with flekszible                  |
+------------------------------------+-----------------------------------------------------------------------------+


Add flekszible topic to your repository to show your repository here.
```

Register main Flokkr repositories. The repositories contain the Kubernetes resource definitions (together with optional transformations) for the specific projects.

```yaml
> flekszible source add github.com/flokkr/k8s
> flekszible source add github.com/elek/> ozone-flekszible
> flekszible source add github.com/flokkr/infra-flekszible
```

Now you can list the available components:

```yaml
> flekszible app search
INFO[0000] Input dir: /tmp, output dir: /tmp
INFO[0000] Reading resources from /tmp/resources
+--------------------------+------------------------------------------------------------------+
| path                     | description                                                      |
+--------------------------+------------------------------------------------------------------+
| flink                    | Apache Flink                                                     |
| grafana                  | Grafana dashboard server                                         |
| hdfs                     | Apache Hadoop HDFS base setup                                    |
| hdfs-ha                  | Apache Hadoop HDFS, HA setup                                     |
| jaeger                   | Jaeger tracing server                                            |
| kafka                    | Apache Kafka                                                     |
| kafka-demo               | Simple console producer / consumer for Kafka                     |
| krb5-dev                 | Unsecure MIT kerberos server for DEVELOPMENT only                |
| krb5-dev/getkeystore     | Sidecar definition to import java trust/keystore from vault      |
| monitor                  | K8s level monitoring                                             |
| pv-test                  | Nginx example deployment with persistent volume claim.           |
| zookeeper                | Scalable Apache Zookeeper setup                                  |
| ozone                    | Apache Hadoop Ozone                                              |
| ozone/freon              | Load test tool for Apache Hadoop Ozone                           |
| anonymous-proxy          | permission to access proxy url by anonymous users                |
| cadvisor                 | CAdvisor node level container metrics                            |
| grafana                  | Grafana dashboard server                                         |
| jaeger                   | Jaeger tracing server                                            |
| kube-dashboard/fulladmin | Full admin privilege for kube-dashboard                          |
| kube-state-metrics       | Kubernetes metrics exporter                                      |
| kubernetes-monitoring    | prometheus instance to be configured for k8s cluster monitoring. |
| loki                     | loki based log collector                                         |
| minio                    | Simple MINIO S3 server                                           |
| node-exporter            | Prometheus Node Exporter                                         |
| prometheus               | Prometheus monitoring                                            |
| sleep                    | Forever sleeping test containers                                 |
+--------------------------+------------------------------------------------------------------+
```

And add everything what you need:

```yaml
> flekszible app add zookeeper
> flekszible app add flink
> flekszible app add kafka
```

Finally you can generate the Kubernetes resources files:

```yaml
> flekszible generate
```

It generates all the required yaml files. 

```yaml
> ls -lah
.rwxr-xr-x   194 elek 15 Dec  9:00  Flekszible
.rw-r-xr-x   177 elek 15 Dec  9:02  flink-config-configmap.yaml
.rw-r-xr-x   230 elek 15 Dec  9:02  flink-jobmanager-service.yaml
.rw-r-xr-x   627 elek 15 Dec  9:02  flink-jobmanager-statefulset.yaml
.rw-r-xr-x   233 elek 15 Dec  9:02  flink-taskmanager-service.yaml
.rw-r-xr-x   634 elek 15 Dec  9:02  flink-taskmanager-statefulset.yaml
.rw-r-xr-x   174 elek 15 Dec  9:02  kafka-broker-service.yaml
.rw-r-xr-x   723 elek 15 Dec  9:02  kafka-broker-statefulset.yaml
.rw-r-xr-x   331 elek 15 Dec  9:02  kafka-config-configmap.yaml
.rw-r-xr-x   506 elek 15 Dec  9:02  zookeeper-config-configmap.yaml
.rw-r-xr-x   177 elek 15 Dec  9:02  zookeeper-service.yaml
.rw-r-xr-x   766 elek 15 Dec  9:02  zookeeper-statefulset.yaml
```

Finally you can install it:

```
kubectl apply -f .
```

For more customization check the [documentation of Flekszible](https://flekszible.netlify.com/) 
