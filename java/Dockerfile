#
# Oracle Java 8 Dockerfile for Usergrid
#
FROM ubuntu:15.10

# don't ask the user when running apt-get install
ENV DEBIAN_FRONTEND noninteractive
ENV http_proxy http://10.174.254.10:80
ENV https_proxy http://10.174.254.10:80
ENV no_proxy localhost,127.0.0.0/8,10.129.0.0/16,*.dzbw.de,172.17.0.0/24

# basic setup similar to docker's official ubuntu base image configuration
# see https://github.com/dockerfile/ubuntu
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y software-properties-common inetutils-ping byobu curl git htop unzip vim wget && \
  echo 'Europe/Berlin' > /etc/timezone && \
  dpkg-reconfigure tzdata && \
  rm -rf /var/lib/apt/lists/*

# install oracle java
# based on docker's official oracle java 8 dockerfile from
# https://github.com/dockerfile/java/tree/master/oracle-java8
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/cache/oracle-jdk8-installer /var/lib/apt/lists/*

# commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# default command
CMD ["bash"]
