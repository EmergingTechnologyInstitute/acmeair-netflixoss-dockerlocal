#!/bin/sh

. ../bin/env.sh

sed 's/password=""/password="'`$pwgen_cmd -s 32 1`'"/' tomcat-users.xml.template > tomcat-users.xml

$docker_cmd build -t acmeair/tomcat .

