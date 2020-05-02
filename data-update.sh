#!/usr/bin/env bash


update() {
   wget https://raw.githubusercontent.com/flokkr/docker-$1/master/flokkr.yaml -O data/component/$1.yaml
}


update hadoop
update ozone
update flink
update spark
update zookeeper
update kafka
update hbase
