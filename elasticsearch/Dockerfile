#
# Elasticsearch Dockerfile for Usergrid
#
FROM usergrid-java

ENV ES_PKG_NAME elasticsearch-1.7.4

# install elasticsearch
RUN \
  cd / && \
  wget https://download.elasticsearch.org/elasticsearch/elasticsearch/$ES_PKG_NAME.tar.gz && \
  tar xvzf $ES_PKG_NAME.tar.gz && \
  rm -f $ES_PKG_NAME.tar.gz && \
  mv /$ES_PKG_NAME /elasticsearch

# define mountable directories
VOLUME ["/data"]

# expose ports
#   - 9200: HTTP
#   - 9300: transport
EXPOSE 9200
EXPOSE 9300

# config
ADD elasticsearch.yml /elasticsearch/config/elasticsearch.yml 

# default command
CMD ["/elasticsearch/bin/elasticsearch"]