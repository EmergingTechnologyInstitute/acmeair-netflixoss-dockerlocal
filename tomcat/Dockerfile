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

RUN wget -q https://archive.apache.org/dist/tomcat/tomcat-7/v7.0.54/bin/apache-tomcat-7.0.54.tar.gz.md5 &&\
  wget -q http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.54/bin/apache-tomcat-7.0.54.tar.gz &&\
  md5sum -c apache-tomcat-7.0.54.tar.gz.md5 &&\
  tar xzf apache-tomcat-7.0.54.tar.gz -C /opt &&\
  rm /apache-tomcat-*.tar.gz* &&\
  mv /opt/apache-tomcat-7.0.54 /opt/tomcat &&\
  cd /opt/tomcat/webapps &&\
  rm -Rf ROOT docs examples

RUN sed -i 's/port="8080"/port="80"/' /opt/tomcat/conf/server.xml

ADD tomcat-users.xml /opt/tomcat/conf/tomcat-users.xml
ADD tomcat.conf /etc/supervisor/conf.d/tomcat.conf

EXPOSE 8009 80

CMD ["/usr/bin/supervisord", "-n"]

