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
FROM acmeair/tomcat

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y mongodb &&\
  apt-get clean &&\
  rm -Rf /var/cache/*

ADD applications.js /tmp/applications.js
RUN echo "smallfiles = true" >> /etc/mongodb.conf
RUN sudo -u mongodb /usr/bin/mongod -f /etc/mongodb.conf --fork &&\
  max=5; for i in `seq 1 1 $max`; do sleep 5; /usr/bin/mongo --eval "db"; if [ "$?" -eq 0 ]; then break; fi; if [ "$i" -eq "$max" ]; then exit 1; fi; done &&\
  /usr/bin/mongo localhost/applications < /tmp/applications.js &&\
  sudo -u mongodb /usr/bin/mongod -f /etc/mongodb.conf --shutdown &&\
  rm /tmp/applications.js

RUN cd /opt/tomcat/webapps &&\
  mkdir ROOT &&\
  cd ROOT &&\
  wget -qO app.war https://acmeair.ci.cloudbees.com/job/asgard-etiport/lastSuccessfulBuild/artifact/target/asgard.war &&\
  jar xf app.war &&\
  rm app.war

ADD mongodb.conf /etc/supervisor/conf.d/mongodb.conf

ENV CATALINA_OPTS -XX:MaxPermSize=128m

CMD ["/usr/bin/supervisord", "-n"]

