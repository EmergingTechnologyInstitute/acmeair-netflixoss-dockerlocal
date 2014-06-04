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

echo "Starting Skydns and Skydock"
./startdns.sh

echo "Starting Cassandra"
./addcassandra.sh

echo "Waiting Cassandra"
sleep 20

echo "Start data loader"
max_retry=5
for n in `seq 0 1 $max_retry`
do
  if [ $n -eq $max_retry ]; then
    exit 1
  fi
  ./runloader.sh
  if [ $? -eq 0 ]; then
    break;
  fi
  sleep 5
done

echo "Starting Eureka"
./starteureka.sh

echo "Starting Zuul"
./startzuul.sh

echo "Starting Microscaler"
./startmicroscaler.sh

echo "Waiting Microscaler"
sleep 45

echo "Starting Microscaler Agent"
./startmicroscaleragent.sh

echo "Starting Asgard"
./startasgard.sh

echo "Configure ASGs"
max_retry=10
for n in `seq 0 1 $max_retry`
do
  if [ $n -eq $max_retry ]; then
    exit 1
  fi
  ./configureasgha.sh
  if [ $? -eq 0 ]; then
    break;
  fi
  sleep 5
done

echo "Starting ASGs"
./startasg.sh

echo "Startind addtional Cassandra nodes"
./addcassandra.sh
./addcassandra.sh

