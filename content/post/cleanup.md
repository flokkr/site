---
title: "The big cleanup"
date: 2019-02-08
---

Flokkr project was an experimental area from the beginning. After a while I realized that my containerization work requires too many repositories and I moved them to this organization. The repositories contained _mutiple_ experiments to containerize Hadoop/Spark and other bigdata projects.

I run them with:

 * Kubernetes (using plain kubernetes resource files)
 * Kubernetes (using Helm charts)
 * docker-compose (local pseudo clusters)
 * Docker swarm
 * Nomad + Consul 

Most of them are no longer maintained. As of now I use:

 * Kubernetes
 * docker-compose (some of the stable parts are already adopted by the Apache Hadoop Ozone project)

Therefore I decided to do a huge cleanup in https://github.com/flokkr. I moved all the unused repositories back t https://github.com/elek and archived them (no repository is deleted). The flokkr project itself now focuses to run Apache Hadoop / Spark / ... in kubernetes, all the experimental bits are moved to my personal github account (Including some kubernetes based experimental project such as a [ui](https://github.com/elek/control-tower) + [operator](https://github.com/elek/fokkr-operator) approach)

The other big change is that I decided to drop Helm chart support. I will describe it in more details, but my opinion is that Helm is very good for quick prorotyping but not for managing production ready clusters. There is no _'One Size Fit All'_ and Helm is very bad at supporting multiple different use cases (different type of configs, different type of product sets)

In this project I switched to use a composition based kubernetes resource manager: [flekszible](https:github.com/elek/flekszible). With the help of this tool I can maintain the [essential configuration](https://github.com/flokkr/k8s/tree/master/examples) flavours of the base projects (such as hdfs, hdfs-secure, hdfs-ha, spark) and combine/generate the final kubernetes resources files which can be versioned and handled in a simple ways.

