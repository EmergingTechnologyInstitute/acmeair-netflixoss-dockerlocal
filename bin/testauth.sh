#!/bin/sh

. ./env.sh

auth_addr=$1

if [ -z "$auth_addr" ]; then
  bindir=`dirname $0`
  auth_addr=$($docker_cmd ps | grep 'acmeair/auth-service' | head -n 1 | cut -d' ' -f1 | xargs $docker_cmd inspect --format '{{.NetworkSettings.IPAddress}}')
fi

out=$(curl -s -w "%{http_code} %{url_effective}\\n" -X POST $auth_addr/rest/api/authtoken/byuserid/uid0@email.com)

rc=$?
if [ $rc -ne 0 ]; then exit $rc; fi

echo $out | sed 's/.*}\([0-9]\+ .*\)/\1/'
id=`echo $out | sed 's/.*"id":"\([^"]*\)".*/\1/'`
echo id=$id
curl -sL -w "%{http_code} %{url_effective}\\n" -o /dev/null -X DELETE $auth_addr/rest/api/authtoken/$id

