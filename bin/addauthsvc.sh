#!/bin/sh

. ./env.sh

max=$($docker_cmd ps -a | grep 'auth[0-9]\+ *$' | sed 's/.*auth\([0-9]\+\).*/\1/' | sort -n | tail -n 1)
num=$(expr $max + 1)

$docker_cmd run \
-d -t \
--dns "$dns" \
$dns_search \
--name auth$num -h auth$num.auth-service${as_suffix}.local.flyacmeair.net \
acmeair/auth-service${as_suffix}

