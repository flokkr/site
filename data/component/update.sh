#!/usr/bin/env bash

for COMPONENT in $(ls -1 | grep -v update); do
   NAME=${COMPONENT%.*}
	docker pull flokkr/$NAME
   LAUNCHER_VERSION=`docker inspect --format "{{ index .Config.Labels \"io.github.flokkr.launcher.version\"}}" flokkr/$NAME`
	sed -i  "s/\(launcherversion:\).*/\1 $LAUNCHER_VERSION/g" $NAME.yaml
	BASE_VERSION=`docker inspect --format "{{ index .Config.Labels \"io.github.flokkr.base.version\"}}" flokkr/$NAME`
	sed -i  "s/\(baseversion:\).*/\1 $BASE_VERSION/g" $NAME.yaml
done
