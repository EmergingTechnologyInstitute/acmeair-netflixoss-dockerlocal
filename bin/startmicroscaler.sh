#!/bin/sh

. ./env.sh

sed -i 's/$DOCKER_URL_BASE/'$(echo ${docker_url_base} | sed 's/\/\//\\\/\\\//')'/' ../microscaler/microscaler.yml
sed -i 's/$DNS_ADDR/'${dns_addr}'/' ../microscaler/microscaler.yml

$docker_cmd run \
-d -t \
--dns "$dns" \
$dns_search \
-v `pwd`/../microscaler/microscaler.yml:/usr/local/microscaler/conf/microscaler.yml \
--name microscaler -h microscaler.microscaler.local.flyacmeair.net \
acmeair/microscaler

