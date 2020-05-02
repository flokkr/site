---
title: "Project update"
date: 2020-05-01
---

Almost all the old experiments (Nomad, Swarm, compose) are removed or moved to attic.

Some of the containers are not supported any more.

[Flekszible](https://github.com/elek/flekszible) -- which is the tool to generate Kubernetes resources files -- is stable and usable.

The main docker images are udated the latest version.

Integration tests and `flekszible` scripts are added to the `docker-*` repositories. All commits is checked with a real Kubernetes cluster (Github Actions + Rancher K3s + Robotframework + flekszible).

```
+------------------+----------+-----------+------------+----------------------+
|       REPO       | WORKFLOW |  STATUS   | CONCLUSION |         DATE         |
+------------------+----------+-----------+------------+----------------------+
| docker-zookeeper | build    | completed | success    | 2020-05-02T11:28:11Z |
| docker-zookeeper | test     | completed | success    | 2020-05-02T11:28:11Z |
| docker-hadoop    | build    | completed | skipped    | 2020-05-02T12:13:24Z |
| docker-hadoop    | test     | completed | success    | 2020-05-02T12:13:24Z |
| docker-hbase     | build    | completed | success    | 2020-05-02T11:13:46Z |
| docker-hbase     | test     | completed | success    | 2020-05-02T11:13:47Z |
| docker-kafka     | build    | completed | success    | 2020-05-02T11:35:26Z |
| docker-kafka     | test     | completed | success    | 2020-05-02T11:35:26Z |
| docker-ozone     | build    | completed | success    | 2020-04-25T15:28:54Z |
| docker-ozone     | test     | missing   |            |
| docker-spark     | build    | completed | success    | 2020-05-02T09:52:49Z |
| docker-spark     | test     | missing   |            |
| docker-flink     | build    | completed | success    | 2020-05-02T09:50:47Z |
| docker-flink     | test     | missing   |            |
+------------------+----------+-----------+------------+----------------------+
```
