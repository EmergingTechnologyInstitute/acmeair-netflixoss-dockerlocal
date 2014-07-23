#!/bin/sh

. ./env.sh

eureka_addr=$($docker_cmd inspect --format '{{ .NetworkSettings.IPAddress }}' eureka)

cp ../asgard/Config.groovy.template ../asgard/Config.groovy
sed -i 's/$EUREKA_ADDR/'$eureka_addr'/' ../asgard/Config.groovy
sed -i 's/$DOCKER_URL_BASE/'$(echo ${docker_url_base} | sed 's/\/\//\\\/\\\//')'/' ../asgard/Config.groovy

$docker_cmd run \
-d -t -P \
--dns "$dns" \
$dns_search \
-v `pwd`/../asgard/Config.groovy:/root/.asgard/Config.groovy \
--name asgard -h asgard.asgard.local.flyacmeair.net \
acmeair/asgard

$docker_cmd inspect --format '{{ .Config.Hostname }} {{ .NetworkSettings.IPAddress }}' asgard

