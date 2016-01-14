#
# Dockerfile for Usergrid
#
FROM usergrid-java

WORKDIR /root
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# build usergrid
# this is done in one run step so less files are included in the layers of the
# docker image, making it smaller.
RUN \
  echo "+++ install tomcat and packages required for compilation" && \ 
  apt-get update && \
  apt-get install -y maven curl tomcat7 git-core && \
  \
  echo "+++ fix tomcat7 init script: add missing java8 location" && \
  sed -i "s#/usr/lib/jvm/java-7-oracle#/usr/lib/jvm/java-7-oracle /usr/lib/jvm/java-8-oracle#g" /etc/init.d/tomcat7 && \
  \
  echo "+++ get usergrid source, set logging level" && \
  git clone --single-branch --branch master --depth 50 https://github.com/apache/usergrid.git usergrid && \
  cd usergrid && \
  git checkout c6945e3d6f608d1333c269657eb47064866d3e0b && \
  grep -rl log4j.rootLogger=INFO stack | xargs sed -i 's#log4j.rootLogger=INFO#log4j.rootLogger=WARN#g'
COPY settings.xml /root/.m2/settings.xml
RUN \
  echo "+++ build usergrid" && \
  cd /root/usergrid/sdks/java && \
  mvn --quiet clean install -DskipTests -DskipIntegrationTests && \
  mvn --quiet install && \
  cd /root/usergrid/stack && \
  mvn --quiet clean install -DskipTests -DskipIntegrationTests && \
  \
  echo "+++ cleanup" && \
  rm -rf /var/lib/tomcat7/webapps/ROOT && \
  mv /root/usergrid/stack/rest/target/ROOT.war /var/lib/tomcat7/webapps && \
  mv /root/usergrid/stack/config/src/main/resources/usergrid-default.properties /usr/share/tomcat7/lib/usergrid-deployment.properties && \
  apt-get purge --auto-remove -y maven git-core ant && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /root/usergrid

# exposed ports:
#  8080 usergrid http interface
#  8443 usergrid https interface
EXPOSE 8080 8443

# runtime configuration script: since this is updated frequently during development, add it last
COPY run.sh /root/run.sh

# default command when starting container with "docker run"
CMD /root/run.sh
