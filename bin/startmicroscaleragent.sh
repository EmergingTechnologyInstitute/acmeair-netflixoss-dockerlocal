#!/bin/sh

. ./env.sh

$docker_cmd run \
-d -t \
--dns "$dns" \
$dns_search \
--name microscaler-agent -h microscaler-agent.microscaler-agent.local.flyacmeair.net \
acmeair/microscaler-agent

