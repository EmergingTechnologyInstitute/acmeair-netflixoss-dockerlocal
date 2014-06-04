#!/bin/sh

################################################################################
# Copyright (c) 2014 IBM Corp.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
################################################################################

if ! [ -e license-prompt.accepted ]; then
	echo "Please run acceptlicenses.sh before trying to build images"
	exit 1
fi

. ./env.sh

chmod +x *.sh

$docker_cmd pull crosbymichael/skydns
$docker_cmd pull crosbymichael/skydock

if [ ! -f "id_rsa" ]; then
  ssh-keygen -f id_rsa -P '' -t rsa
  chmod 600 id_rsa
fi

cp id_rsa.pub ../base

cd ..

echo "Building acmeair/pwgen"
$docker_cmd build -t acmeair/pwgen pwgen
echo "Building acmeair/base"
$docker_cmd build -t acmeair/base base
echo "Building acmeair/cassandra"
$docker_cmd build -t acmeair/cassandra cassandra
echo "Building acmeair/loader"
$docker_cmd build -t acmeair/loader loader
echo "Building acmeair/tomcat"
cd tomcat
./buildtomcat.sh
cd ..
echo "Building acmeair/zuul"
$docker_cmd build -t acmeair/zuul zuul
echo "Building acmeair/eureka"
$docker_cmd build -t acmeair/eureka eureka
echo "Building acmeair/auth-service"
$docker_cmd build -t acmeair/auth-service auth-service
echo "Building acmeair/webapp"
$docker_cmd build -t acmeair/webapp webapp
echo "Building acmeair/microscaler"
cd microscaler
./buildmicroscaler.sh
cd ..
echo "Building acmeair/microscaler-agent"
$docker_cmd build -t acmeair/microscaler-agent microscaler-agent
echo "Building acmeair/asgard"
$docker_cmd build -t acmeair/asgard asgard
echo "Building acmeair/ibmjava"
$docker_cmd build -t acmeair/ibmjava ibmjava
echo "Building acmeair/liberty"
$docker_cmd build -t acmeair/liberty liberty
echo "Building acmeair/auth-service-liberty"
$docker_cmd build -t acmeair/auth-service-liberty auth-service-liberty
echo "Building acmeair/webapp-liberty"
$docker_cmd build -t acmeair/webapp-liberty webapp-liberty

