FROM acmeair/base

ADD response.properties /tmp/
RUN cd /tmp &&\
  wget -q http://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/downloads/jre/1.7.0/linux/ibm-java-jre-7.0-5.0-x86_64-archive.bin &&\
  chmod +x ibm-java-jre-7.0-5.0-x86_64-archive.bin &&\
  ./ibm-java-jre-7.0-5.0-x86_64-archive.bin -i silent -f response.properties &&\
  mkdir /opt/ibm &&\
  mv /tmp/ibm-java-x86_64-70 /opt/ibm/java &&\
  rm -rf /tmp/*

ENV JAVA_HOME /opt/ibm/java
ENV PATH $JAVA_HOME/jre/bin:$PATH

