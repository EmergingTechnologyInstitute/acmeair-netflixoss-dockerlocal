#!/bin/sh

. ./env.sh

$docker_cmd run \
-d -t \
--dns "$dns" \
$dns_search \
--name asgard -h asgard.asgard.local.flyacmeair.net \
acmeair/asgard

$docker_cmd inspect --format '{{ .Config.Hostname }} {{ .NetworkSettings.IPAddress }}' asgard

