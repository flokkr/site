---
title: "Next steps"
date: 2019-12-14
---

The next steps after the first cluster is the customization. It can be done by adding any kind of custom transformation or reuse ready-to-use transformations.

```yaml
> flekszible transformation search
+---------------------+--------------------------------------------------------------------------------------------+
| name                | description                                                                                |
+---------------------+--------------------------------------------------------------------------------------------+
| Namespace           | Use explicit namespace                                                                     |
| Pipe                | Transform content with external shell command.                                             |
| Remove              | Remove yaml fragment from an existing k8s resources                                        |
| ozone/emptydir      | Add empty dir based ephemeral persistence                                                  |
| ozone/onenode       | remove scheduling rules to make it possible to run multiple datanode on the same k8s node. |
| ozone/persistence   | Add real PVC based persistence                                                             |
| ozone/profiler      | Enable profiler endpoint.                                                                  |
| Add                 | Extends yaml fragment to an existing k8s resources                                         |
| Image               | Replaces the docker image definition                                                       |
| Prefix              | Add same prefix to all the k8s names                                                       |
| ozone/devtracing    | Enable jaeger tracing for ALL the requests (100% sampling)                                 |
| ozone/grafana       | Enable grafana for ozone dashboards                                                        |
| ozone/memdisk       | Use memdisks for empty dirs                                                                |
| ozone/ozonefs       | copy ozonefs jar file to a temporary emptydir volume                                       |
| Change              | Replace existing value literal in the yaml struct                                          |
| ConfigHash          | Add labels to the k8s resources with the hash of the used configmaps                       |
| DaemonToStatefulSet | Converts daemonset to statefulset                                                          |
| K8sWriter           | Internal transformation to print out k8s resources as yaml                                 |
| PublishService      | Creates additional service for internal services                                           |
| Replace             | Replace a yaml subtree with an other one.                                                  |
| ozone/tracing       | Enable jaeger tracing                                                                      |
| PublishStatefulSet  | Creates additional NodeType service for StatefulSet internal services                      |
| zookeeper/scale     | Set the number of the zookeeper replicas.                                                  |
| ozone/prometheus    | Enable prometheus monitoring in Ozone                                                      |
+---------------------+--------------------------------------------------------------------------------------------+
```

The prefixed transformations (like `zookeeper/scale`) are usually combined, pre-defined transformation, you can apply it with command line (`flekszible transformation add ozone/emptydir`) or with editing the `Flekszible` descriptor.

(Note: all the previous command line just modified this descriptor)

In this example we imported Ozone app, with a transformation which adds emptyDir based persistence:

Content of `Flekszible`:

```yaml
import:
 - path: ozone
   transformations:
   - type: ozone/emptydir
```

In the next example we imported kafka, kafka-demo, flink, but the flink resources are transformed to add a custom `imagePullPolicy`:

Content of `Flekszible`:

```yaml
import:
 - path: kafka
 - path: kafka-demo
 - path: flink
   transformations:
   - type: add
     path:
       - spec
       - template
       - spec
       - containers
       - ".*"
     value:
       imagePullPolicy: IfNotPresent
```