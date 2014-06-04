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
FROM acmeair/base

RUN wget -q https://archive.apache.org/dist/cassandra/2.0.7/apache-cassandra-2.0.7-bin.tar.gz.md5 &&\
  wget -q http://archive.apache.org/dist/cassandra/2.0.7/apache-cassandra-2.0.7-bin.tar.gz &&\
  echo "  apache-cassandra-2.0.7-bin.tar.gz" | cat apache-cassandra-2.0.7-bin.tar.gz.md5 - | md5sum -c - &&\
  tar xzf apache-cassandra-2.0.7-bin.tar.gz -C /opt &&\
  mv /opt/apache-cassandra-2.0.7 /opt/cassandra &&\
  rm /apache-cassandra-*.tar.gz*
 
RUN sed -i 's/\(.*_address:\).*/\1/' /opt/cassandra/conf/cassandra.yaml
RUN sed -i 's/\(- seeds: "\).*"/\1cassandra1.cassandra.local.flyacmeair.net"/' /opt/cassandra/conf/cassandra.yaml
RUN sed -i 's/\(endpoint_snitch: \).*/\1RackInferringSnitch/' /opt/cassandra/conf/cassandra.yaml

RUN echo 'export PATH=/opt/cassandra/bin:$PATH' > /etc/profile.d/cassandra.sh

ENV MAX_HEAP_SIZE 48m
ENV HEAP_NEWSIZE 12m

ADD cassandra.conf /etc/supervisor/conf.d/cassandra.conf

CMD ["/usr/bin/supervisord", "-n"]

