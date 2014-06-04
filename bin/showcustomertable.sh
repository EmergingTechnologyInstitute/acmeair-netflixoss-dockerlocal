#!/bin/sh

. ./env.sh

$docker_cmd run \
--rm -t \
--dns "$dns" \
$dns_search \
acmeair/cassandra \
/bin/sh -c 'echo "USE acmeair; SELECT * FROM customer;" > /tmp/commands.txt; /opt/cassandra/bin/cqlsh cassandra1.cassandra.local.flyacmeair.net -f /tmp/commands.txt'

