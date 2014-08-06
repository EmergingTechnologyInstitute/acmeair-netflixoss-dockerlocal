#!/bin/sh

. ./env.sh

$docker_cmd run \
-d -t -P \
--dns "$dns" \
$dns_search \
--name zuul -h zuul.zuul.local.flyacmeair.net \
acmeair/zuul

$docker_cmd inspect --format '{{ .Config.Hostname }} {{ .NetworkSettings.IPAddress }}' zuul

