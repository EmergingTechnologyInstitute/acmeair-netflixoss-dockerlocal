#!/bin/sh

. ./env.sh

cp ../microscaler-agent/agent.yml.template ../microscaler-agent/agent.yml
sed -i 's/$DOCKER_URL_BASE/'$(echo ${docker_url_base} | sed 's/\/\//\\\/\\\//')'/' ../microscaler-agent/agent.yml

$docker_cmd run \
-d -t \
--dns "$dns" \
$dns_search \
-v `pwd`/../microscaler-agent/agent.yml:/usr/local/microscaler-agent/conf/agent.yml \
--name microscaler-agent -h microscaler-agent.microscaler-agent.local.flyacmeair.net \
acmeair/microscaler-agent

