#!/bin/sh

. ./env.sh

$docker_cmd run \
-d -t \
--dns "$dns" \
$dns_search \
--name microscaler -h microscaler.microscaler.local.flyacmeair.net \
acmeair/microscaler

