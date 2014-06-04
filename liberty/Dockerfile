FROM acmeair/ibmjava

RUN cd /tmp &&\
  wget -q http://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/downloads/wlp/8.5.5.2/wlp-developers-runtime-8.5.5.2.jar &&\
  /opt/ibm/java/jre/bin/java -jar wlp-developers-runtime-8.5.5.2.jar --acceptLicense /opt/ibm &&\
  rm -rf *

ADD server.xml /opt/ibm/wlp/usr/servers/defaultServer/
ADD liberty.conf /etc/supervisor/conf.d/liberty.conf

EXPOSE 9080 9443

CMD ["/usr/bin/supervisord", "-n"]

