#!/bin/sh

. ./env.sh

$docker_cmd run \
--rm -t \
--dns "$dns" \
$dns_search \
acmeair/cassandra \
/opt/cassandra/bin/nodetool -h cassandra1.cassandra.local.flyacmeair.net status

