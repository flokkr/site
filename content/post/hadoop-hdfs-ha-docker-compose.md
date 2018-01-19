---
title: "Start Hadoop Hdfs HA cluster with docker-compose"
date: 2018-01-19T23:12:43+01:00
tags:
  - hadoop
  - compose
  - docker
---

Recently I had to start different type of Hadoop Hdfs clusters in my local environment, such as HA, router based federation, federation, etc.

Hadoop is not designed to run in containers but with very low effort it works very well. For example a non-HA cluster could be started easily as the datanode will try to connect to the namenode again and again until the namenode is started.

There is just one precondition: the namenode directory should be formatted, but it could be handled by a custom launcher script which includes the required steps. For example:

{{< highlight shell >}}
if [ -n "$ENSURE_NAMENODE_DIR" ]; then
   if [ ! -d "$ENSURE_NAMENODE_DIR" ]; then
      /opt/hadoop/bin/hdfs namenode -format
        fi
fi
{{< / highlight >}}

For HA cluster it's more tricky as we should do everything in the right order.

 1. First the journal nodes should be started
 2. Second the primary namenode should be formatted
 3. Finally the secondary namenodes can be formatted (they need the initalized data in the journalnode).

 (Note: yes, since Hadoop 3 we can have multiple namenodes.)

 The flokkr docker images contain a simple extensible [launcher script](https://github.com/flokkr/launcher). It's really just a collection of many conditions: according to the environment variables many action could be executed before the main application. One action is the namenode formatting, but it also contains a few simple utility such as sleep:

{{< highlight shell >}}
if [ -n "$SLEEP_SECONDS" ]; then
   sleep $SLEEP_SECONDS
{{< / highlight >}}


The final docker-compose file doesn't' contain any special, just SLEEP_SECOND environment variables to ensure the namenodes are initialized in the right order:

{{< highlight yaml >}}
version: "3"
services:
   namenode1:
      image: flokkr/hadoop:latest
      hostname: namenode1
      ports:
         - 9870:9870
      env_file:
        - ./config
      environment:
          ENSURE_NAMENODE_DIR: "/tmp/hadoop-hadoop/dfs/name"
          SLEEP_SECONDS: 20
      command: ["hdfs", "namenode"]
   namenode2:
      image: flokkr/hadoop:latest
      hostname: namenode2
      ports:
         - 9871:9870
      env_file:
        - ./config
      environment:
          ENSURE_STANDBY_NAMENODE_DIR: "/tmp/hadoop-hadoop/dfs/name"
          SLEEP_SECONDS: 40
      command: ["hdfs", "namenode"]
   journal1:
      image: flokkr/hadoop:latest
      hostname: journal1
      env_file:
        - ./config
      command: ["hdfs", "journalnode"]
   journal2:
      image: flokkr/hadoop:latest
      hostname: journal2
      env_file:
        - ./config
      command: ["hdfs", "journalnode"]
   journal3:
      image: flokkr/hadoop:latest
      hostname: journal3
      env_file:
        - ./config
      command: ["hdfs", "journalnode"]
   datanode:
      image: flokkr/hadoop:latest
      command: ["hdfs", "datanode"]
      env_file:
        - ./config
      environment:
         SLEEP_SECONDS: 50
   activator:
      image: flokkr/hadoop:latest
      command: ["hdfs", "haadmin", "-transitionToActive", "nn1"]
      env_file:
        - ./config
      environment:
         SLEEP_SECONDS: 60
{{< / highlight >}}

To start a Hadoop HA cluster with docker:

  1. ```git clone https://github.com/flokkr/runtime-compose.git && cd runtime-compose```
  2. ```docker-compose up -d```

You can also scale up the datanodes with

```
docker-compose scale datanode=10
```

And now you have a running Hadoop-HA cluster in almost 1 minute.
