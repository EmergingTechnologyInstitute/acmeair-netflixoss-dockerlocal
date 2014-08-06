#!/bin/sh

. ./env.sh

max=$($docker_cmd ps -a | grep 'webapp[0-9]\+ *$' | sed 's/.*webapp\([0-9]\+\).*/\1/' | sort -n | tail -n 1)
num=$(expr $max + 1)

$docker_cmd run \
-d -t -P \
--dns "$dns" \
$dns_search \
--name webapp$num -h webapp$num.webappi${as_suffix}.local.flyacmeair.net \
acmeair/webapp${as_suffix}

