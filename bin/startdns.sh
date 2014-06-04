#!/bin/sh

. ./env.sh

$docker_cmd run -d -p ${dns_addr}:53:53/udp -p ${dns_addr}:8080:8080/tcp --name skydns crosbymichael/skydns -nameserver 8.8.8.8:53 -domain "flyacmeair.net"

$docker_cmd run -d --name skydock -v /var/run/docker.sock:/docker.sock crosbymichael/skydock -ttl 30 -environment local -s /docker.sock -domain "flyacmeair.net" -name skydns

