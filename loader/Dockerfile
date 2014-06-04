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
FROM acmeair/cassandra

RUN wget -qO /opt/app.zip \
    https://acmeair.ci.cloudbees.com/job/acmeair-netflix-astyanax/lastSuccessfulBuild/artifact/acmeair-loader/build/distributions/acmeair-loader-0.1.0-SNAPSHOT.zip &&\
  cd /opt &&\
  jar xf app.zip &&\
  rm app.zip &&\
  mv acmeair-loader-* acmeair-loader &&\
  cd acmeair-loader/bin &&\
  chmod +x acmeair-loader &&\
  wget -q https://acmeair.ci.cloudbees.com/job/acmeair-netflix-astyanax/lastSuccessfulBuild/artifact/acmeair-services-astyanax/src/main/resources/acmeair-cql.txt &&\
  sed -i 's/DROP/\/\/DROP/' acmeair-cql.txt

ENV JAVA_OPTS -Dcom.acmeair.cassandra.contactpoint=cassandra1.cassandra.local.flyacmeair.net

CMD /opt/cassandra/bin/cqlsh \
    -f /opt/acmeair-loader/bin/acmeair-cql.txt \
    cassandra1.cassandra.local.flyacmeair.net &&\
  cd /opt/acmeair-loader/bin &&\
  ./acmeair-loader

