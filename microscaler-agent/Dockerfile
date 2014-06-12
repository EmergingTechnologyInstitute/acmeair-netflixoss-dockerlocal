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

RUN cd /usr/local &&\
  wget -qO- https://github.com/EmergingTechnologyInstitute/microscaler/tarball/master | tar xzf - -C /tmp &&\
  mv /tmp/EmergingTechnologyInstitute-microscaler-*/microscaler-agent /usr/local &&\
  rm -Rf /tmp/EmergingTechnologyInstitute-microscaler-* &&\
  cd microscaler-agent &&\
  mkdir /.bundle &&\
  echo --- >> /.bundle/config &&\
  echo 'BUNDLE_BUILD__EVENTMACHINE: --with-cflags="-O2 -pipe -march=native -w" ' >> /.bundle/config &&\
  echo 'BUNDLE_BUILD__THIN: --with-cflags="-O2 -pipe -march=native -w" ' >> /.bundle/config &&\
  bundle install &&\
  chmod a+x lib/docker_agent.rb &&\
  chmod a+x lib/rest_client.rb

ADD microscaler-agent.conf /etc/supervisor/conf.d/microscaler-agent.conf

CMD ["/usr/bin/supervisord", "-n"]

