#!/bin/sh

. ./env.sh

$docker_cmd run \
--rm -t \
--dns "$dns" \
$dns_search  \
--name loader -h loader.loader.local.flyacmeair.net \
acmeair/loader

