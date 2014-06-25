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

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y mongodb redis-server redis-tools rake golang git &&\
  apt-get clean &&\
  rm -Rf /var/cache/*

# gnatsd
RUN mkdir /tmp/go &&\
  GOPATH=/tmp/go go get github.com/apcera/gnatsd &&\
  mv /tmp/go/bin/gnatsd /usr/local/bin &&\
  rm -Rf /tmp/go

# MongoDB
RUN gem install mongo bson_ext
RUN sed -i 's/\(bind_ip = \).*/\10.0.0.0/' /etc/mongodb.conf &&\
  echo "port = 27017" >> /etc/mongodb.conf &&\
  echo "smallfiles = true" >> /etc/mongodb.conf
RUN sudo -u mongodb /usr/bin/mongod -f /etc/mongodb.conf --fork &\
  max=5; for i in `seq 1 1 $max`; do sleep 5; /usr/bin/mongo --eval "db"; if [ "$?" -eq 0 ]; then break; fi; if [ "$i" -eq "$max" ]; then exit 1; fi; done &&\
  /usr/bin/mongo admin --eval "db.addUser('admin','$admin_passwd');" &&\
  /usr/bin/mongo authdb --eval "db.addUser('auser','$auser_passwd');" &&\
  /usr/bin/mongo imdb --eval "db.addUser('imuser','$imuser_passwd');" &&\
  /usr/bin/mongo asgdb --eval "db.addUser('asguser','$asguser_passwd');" &&\
  sudo -u mongodb /usr/bin/mongod -f /etc/mongodb.conf --shutdown
RUN echo "auth = true" >> /etc/mongodb.conf

# Microscaler
RUN cd /usr/local &&\
  wget -qO- https://github.com/EmergingTechnologyInstitute/microscaler/tarball/master | tar xzf - -C /tmp &&\
  mv /tmp/EmergingTechnologyInstitute-microscaler-*/microscaler /usr/local &&\
  mv /tmp/EmergingTechnologyInstitute-microscaler-*/microscaler-cli /usr/local &&\
  rm -Rf /tmp/EmergingTechnologyInstitute-microscaler-* &&\
  cd microscaler &&\
  mkdir /.bundle &&\
  echo --- >> /.bundle/config &&\
  echo 'BUNDLE_BUILD__EVENTMACHINE: --with-cflags="-O2 -pipe -march=native -w" ' >> /.bundle/config &&\
  echo 'BUNDLE_BUILD__THIN: --with-cflags="-O2 -pipe -march=native -w" ' >> /.bundle/config &&\
  bundle install &&\
  cd ../microscaler-cli &&\
  bundle install 

RUN echo "alias ms=/usr/local/microscaler-cli/bin/ms" >> /root/.bashrc

ADD redis.conf /etc/supervisor/conf.d/redis.conf
ADD mongodb.conf /etc/supervisor/conf.d/mongodb.conf
ADD gnatsd.conf /etc/supervisor/conf.d/gnatsd.conf
ADD controller.conf /etc/supervisor/conf.d/controller.conf
ADD healthmanager.conf /etc/supervisor/conf.d/healthmanager.conf
ADD worker-launch.conf /etc/supervisor/conf.d/worker-launch.conf
ADD worker-stop.conf /etc/supervisor/conf.d/worker-stop.conf

CMD ["/usr/bin/supervisord", "-n"]

