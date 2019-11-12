FROM centos/systemd

ENV container docker

COPY mongodb-org.repo /etc/yum.repos.d/

RUN mkdir -p /hygieia/logs; \
mkdir -p /hygieia/ui/; \
mkdir -p /hygieia/api/; \
mkdir -p /hygieia/collectors/; \
mkdir -p /hygieia/cacerts

RUN  yum -y install mongodb-org; \
yum -y install httpd; \
yum -y install java-1.8.0-openjdk-devel; \
yum clean all; 

# Pulls Jenkins Collector jar
RUN curl -o /hygieia/collectors/jenkins-build-collector.jar https://oss.sonatype.org/content/repositories/snapshots/com/capitalone/dashboard/jenkins-build-collector/3.0.2-SNAPSHOT/jenkins-build-collector-3.0.2-20190719.153446-86.jar
# Bind to 0.0.0.0 to allow for external connection 
RUN sed -i "s|bindIp: 127.0.0.1|bindIp: 0.0.0.0|g" /etc/mongod.conf

EXPOSE 8080
EXPOSE 80
EXPOSE 27017

ENV JAVA_HOME /usr/lib/jvm/java-openjdk
ENV PROP_FILE /hygieia/application.properties


COPY /api/* /hygieia/api/
COPY /system/* /etc/systemd/system/
COPY /collectors/* /hygieia/collectors/
COPY /ui/httpd.conf /etc/httpd/conf/
ADD /certs/* /hygieia/cacerts/
ADD /properties-builder.sh /hygieia/

# For adding certs
RUN ls -1 /hygieia/cacerts | while read cert; do \
        openssl x509 -outform der -in /hygieia/cacerts/$cert -out $cert.der; \
        $JAVA_HOME/bin/keytool -import -alias $cert -keystore $JAVA_HOME/jre/lib/security/cacerts -trustcacerts -file $cert.der -storepass changeit -noprompt; \
        rm $cert.der; \
    done

WORKDIR /hygieia/
RUN chmod 777 properties-builder.sh 

ENTRYPOINT ["/hygieia/properties-builder.sh"]