#!/bin/sh

. ./env.sh

$docker_cmd run \
-d -t -P \
--dns "$dns" \
$dns_search \
--name eureka -h eureka.eureka.local.flyacmeair.net \
acmeair/eureka

$docker_cmd inspect --format '{{ .Config.Hostname }} {{ .NetworkSettings.IPAddress }}' eureka

