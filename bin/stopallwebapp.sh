#!/bin/sh

. ./env.sh

for i in `$docker_cmd ps | grep 'acmeair/webapp' | awk '{print $1}'`
do
  $docker_cmd stop $i
done

