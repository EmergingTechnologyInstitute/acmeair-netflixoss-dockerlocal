#!/bin/sh

. ./env.sh

$docker_cmd ps -q | xargs $docker_cmd inspect --format '{{ .NetworkSettings.IPAddress }}	{{ .Name }}' | sed 's/\t\//\t/' | sort

