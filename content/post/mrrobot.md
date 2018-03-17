---
title: "Integration tests with robot framework"
date: 2018-03-17T23:12:43+01:00
tags:
  - hadoop
  - testing
  - docker
  - robot
---

[Robot framework](http://robotframework.org/) is a generic integration test framework. As an experiment I added robot based integrations tests to the [runtime-compose](https://github.com/flokkr/runtime-compose).

This repository contains example docker-compose files to start various type of hadoop/spark/... clusters. Now it also contains some robot scripts to check if the docker-compose files are still vaild with the latest images. See [this](https://github.com/flokkr/runtime-compose/blob/master/ozone/ozone.robot) tile as an example.


```
*** Settings ***
Documentation       Smoketest with hdsl/ozone.
Library             OperatingSystem
Suite Setup         Startup Cluster
Suite Teardown      Docker compose down
Resource            ../robotlib/docker.robot

*** Variables ***
${PREFIX}               ozone
${COMPOSEFILE}          ${CURDIR}/docker-compose.yaml
${COMMON_REST_HEADER}   -H "x-ozone-user: bilbo" -H "x-ozone-version: v1" -H  "Date: Mon, 26 Jun 2017 04:23:30 GMT" -H "Authorization:OZONE root"


*** Test Cases ***

Daemons are running without error
    Daemon is running without error           ksm
    Daemon is running without error           scm
    Daemon is running without error           namenode
    Daemon is running without error           datanode

Check if datanode is connected to the scm
    Wait Until Keyword Succeeds     2min    5sec    Have healthy datanodes   1

Scale it up to 5 datanodes
    Scale datanodes up  5
    Wait Until Keyword Succeeds     2min    5sec    Have healthy datanodes   5

Test rest interface
    ${result} =     Execute on      datanode     curl -i -X POST ${COMMON_RESTHEADER} "http://localhost:9880/volume1"
Should contain ${result} 201 Created
```

Currently it doesn't use any custom libraries. The docker specific part is moved out to a separated file. Long term multiple implementation could be added (docker-compose vs. kubernetes).

To test it:

 1. Clone the runtime-compose repository.
 2. Do a `./robot` . in the root directory.




