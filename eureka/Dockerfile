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

RUN cd /opt/tomcat/webapps &&\
  mkdir eureka &&\
  cd eureka &&\
  wget -qO app.war http://repo1.maven.org/maven2/com/netflix/eureka/eureka-server/1.1.132/eureka-server-1.1.132.war &&\
  jar xf app.war &&\
  rm app.war

ADD index.jsp /opt/tomcat/webapps/ROOT/index.jsp

ADD config.properties /opt/tomcat/webapps/eureka/WEB-INF/classes/config.properties
ADD eureka-client-docker.properties /opt/tomcat/webapps/eureka/WEB-INF/classes/eureka-client-docker.properties
ADD eureka-server.properties /opt/tomcat/webapps/eureka/WEB-INF/classes/eureka-server.properties
ADD eureka-server-docker.properties /opt/tomcat/webapps/eureka/WEB-INF/classes/eureka-server-docker.properties

ENV CATALINA_OPTS -Xmx48m

CMD ["/usr/bin/supervisord", "-n"]

