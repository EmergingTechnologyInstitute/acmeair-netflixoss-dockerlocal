#!/bin/sh

. ./env.sh

containers=$($docker_cmd ps -a | grep ' acmeair/' | awk '{print $1}' | tr '\n' ' ')
if [ -n "$containers" ]; then
  $docker_cmd rm -f $containers
fi

$docker_cmd rm -f skydock skydns
