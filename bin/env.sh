#!/bin/sh

docker_cmd="docker"
bridge_name=docker0
docker_port=2375

# "wlp" for WAS Liberty profile or "tc" for Tomcat
appserver=wlp

if [ "$appserver" = "wlp" ]; then
  as_suffix=-liberty
fi

bridge_addr=$(ifconfig $bridge_name | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
docker_addr=$bridge_addr
docker_url_base=http://${docker_addr}:${docker_port}
dns_addr=$bridge_addr
dns_search_list="auth-service-liberty.local.flyacmeair.net webapp-liberty.local.flyacmeair.net auth-service.local.flyacmeair.net webapp.local.flyacmeair.net eureka.local.flyacmeair.net zuul.local.flyacmeair.net"
pwgen_cmd="$docker_cmd run --rm acmeair/pwgen"

dns=$dns_addr
dns_search="--dns-search `echo $dns_search_list | sed "s/ / --dns-search /g"`"

