---
title: "Byteman: X-ray for Hadoop"
date: 2018-06-18T12:25:02+02:00
---

At least half of the powers of the containers are in the launcher script. Flokkr [launcher script][launcher] has a very simple and plugable structure to provide multiple additional functionality side by side.

One interesting function is the instrumentation with byteman: [byteman] is a library to instrument / modify the java code runtime according to simple text based rules.

As an example this is a byteman rule which prints out all the hadoop-rpc traffic between components. As hadoop rpc has some well defined interfaces the only thing what we need is to instrument the rpc interfaces at the right place:


```
RULE Hadoop RPC request
INTERFACE ^com.google.protobuf.BlockingService
METHOD callBlockingMethod
IF true
DO traceln("--> RPC message request: " + $3.getClass().getSimpleName() + " from " + linked(Thread.currentThread(), "source"));
   traceln($3.toString())
ENDRULE


RULE Hadoop RPC response
INTERFACE ^com.google.protobuf.BlockingService
METHOD callBlockingMethod
AT EXIT
IF true
DO traceln("--> RPC message response: " + $3.getClass().getSimpleName() + " to " + unlink(Thread.currentThread(), "source"));
   traceln($!.toString())
ENDRULE


RULE Hadoop RPC source IP
CLASS org.apache.hadoop.ipc.Server$RpcCall
METHOD run
IF true
DO link(Thread.currentThread(), "source", $0.connection.toString())
ENDRULE

```



If you have the instrumentation the only thing what you need is activate the byteman script by the launcher. [There is][bytemanplugin] a simple launcher segment to to activate the byteman script with adding the java agent arguments. The only thing is what you need is setting an environment variable to activate it:


```
 environment:
              BYTEMAN_SCRIPT_URL: https://gist.githubusercontent.com/elek/0589a91b4d55afb228279f6c4f04a525/raw/8bb4e03de7397c8a9d9bb74a5ec80028b42575c4/hadoop.btm
```


With this one line modification all the hadoop rpc calls will be printed out to the standard output:

```
namenode_1  | --> RPC message request: VersionRequestProto from 172.22.0.2:48756
namenode_1  |
namenode_1  | --> RPC message response: VersionRequestProto to 172.22.0.2:48756
namenode_1  | info {
namenode_1  |   buildVersion: "16b70619a24cdcf5d3b0fcf4b58ca77238ccbe6d"
namenode_1  |   unused: 0
namenode_1  |   blockPoolID: "BP-114867385-172.22.0.3-1529317833298"
namenode_1  |   storageInfo {
namenode_1  |     layoutVersion: 4294967232
namenode_1  |     namespceID: 1973813075
namenode_1  |     clusterID: "CID-a38b2fdf-6b7b-4659-930d-9a81e3c0d62c"
namenode_1  |     cTime: 1529317833298
namenode_1  |   }
namenode_1  |   softwareVersion: "3.1.0"
namenode_1  |   capabilities: 1
namenode_1  |   state: ACTIVE
namenode_1  | }
namenode_1  |
namenode_1  | --> RPC message request: RegisterDatanodeRequestProto from 172.22.0.2:48756
namenode_1  | registration {
namenode_1  |   datanodeID {
namenode_1  |     ipAddr: "0.0.0.0"
namenode_1  |     hostName: "ff2d728da73a"
namenode_1  |     datanodeUuid: "1a3e7852-5760-4fe2-9e2f-ebfcf9e27342"
namenode_1  |     xferPort: 9866
namenode_1  |     infoPort: 9864
namenode_1  |     ipcPort: 9867
namenode_1  |     infoSecurePort: 0
namenode_1  |   }
namenode_1  |   storageInfo {
namenode_1  |     layoutVersion: 4294967239
namenode_1  |     namespceID: 1973813075
namenode_1  |     clusterID: "CID-a38b2fdf-6b7b-4659-930d-9a81e3c0d62c"
namenode_1  |     cTime: 1529317833298
namenode_1  |   }
namenode_1  |   keys {
namenode_1  |     isBlockTokenEnabled: false
namenode_1  |     keyUpdateInterval: 0
namenode_1  |     tokenLifeTime: 0
namenode_1  |     currentKey {
namenode_1  |       keyId: 0
namenode_1  |       expiryDate: 0
namenode_1  |       keyBytes: ""
namenode_1  |     }
namenode_1  |   }
namenode_1  |   softwareVersion: "3.1.0"
namenode_1  | }
```


[launcher]: https://github.com/flokkr/launcher
[byteman]: http://byteman.jboss.org/
[bytemanplugin]: https://github.com/flokkr/launcher/blob/master/plugins/017_byteman/byteman.sh

