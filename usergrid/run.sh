#!/bin/bash
#
if [ -z "${CASSANDRA_CLUSTER_NAME}" ]; then
  CASSANDRA_CLUSTER_NAME='usergrid'
fi
if [ -z "${CASSANDRA_PORT_9160_TCP_ADDR}" ]; then
  CASSANDRA_PORT_9160_TCP_ADDR='cassandra'
fi
if [ -z "${CASSANDRA_PORT_9160_TCP_PORT}" ]; then
  CASSANDRA_PORT_9160_TCP_PORT='9160'
fi
if [ -z "${ELASTICSEARCH_PORT_9300_TCP_ADDR}" ]; then
  ELASTICSEARCH_PORT_9300_TCP_ADDR='elasticsearch'
fi
if [ -z "${ELASTICSEARCH_PORT_9300_TCP_PORT}" ]; then
  ELASTICSEARCH_PORT_9300_TCP_PORT='9300'
fi
if [ -z "${USERGRID_CLUSTER_NAME}" ]; then
  USERGRID_CLUSTER_NAME='usergrid'
fi
if [ -z "${TOMCAT_RAM}" ]; then
  TOMCAT_RAM=512m
fi

# 
if [ -z "${DOMAIN}" ]; then
  DOMAIN=example.com
fi
if [ -z "${ADMIN_USERNAME}" ]; then
  ADMIN_USERNAME=admin
fi
if [ -z "${ADMIN_PASSWORD}" ]; then
  ADMIN_PASSWORD=admin
fi
if [ -z "${ADMIN_MAIL}" ]; then
  ADMIN_MAIL="admin@${DOMAIN}"
fi

#
if [ -z "${ORG_NAME}" ]; then
  ORG_NAME=testorg
fi
if [ -z "${APP_NAME}" ]; then
  APP_NAME=testapp
fi
if [ -z "${ORG_ADMIN_USERNAME}" ]; then
  ORG_ADMIN_USERNAME="${ORG_NAME}admin"
fi
if [ -z "${ORG_ADMIN_PASSWORD}" ]; then
  ORG_ADMIN_PASSWORD="${ORG_NAME}admin"
fi
if [ -z "${ORG_ADMIN_REALNAME}" ]; then
  ORG_ADMIN_REALNAME="${ORG_NAME}admin"
fi
if [ -z "${ORG_ADMIN_EMAIL}" ]; then
  ORG_ADMIN_EMAIL="${ORG_NAME}admin@example.com"
fi

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "+++ usergrid configuration:"
echo "CASSANDRA_CLUSTER_NAME: ${CASSANDRA_CLUSTER_NAME}"
echo "CASSANDRA_PORT_9160_TCP_ADDR: ${CASSANDRA_PORT_9160_TCP_ADDR}"
echo "CASSANDRA_PORT_9160_TCP_PORT: ${CASSANDRA_PORT_9160_TCP_PORT}"
echo "ELASTICSEARCH_PORT_9300_TCP_ADDR: ${ELASTICSEARCH_PORT_9300_TCP_ADDR}"
echo "ELASTICSEARCH_PORT_9300_TCP_PORT: ${ELASTICSEARCH_PORT_9300_TCP_PORT}"
echo "TOMCAT_RAM: ${TOMCAT_RAM}"
echo "+++ admin settings:"
echo "DOMAIN: ${DOMAIN}"
echo "ADMIN_USERNAME: ${ADMIN_USERNAME}"
echo "ADMIN_PASSWORD: ${ADMIN_PASSWORD}"
echo "ADMIN_MAIL: ${ADMIN_MAIL}"
echo "+++ application user settings:"
echo "ORG_NAME: ${ORG_NAME}"
echo "APP_NAME: ${APP_NAME}"
echo "ORG_ADMIN_USERNAME: ${ORG_ADMIN_USERNAME}"
echo "ORG_ADMIN_PASSWORD: ${ORG_ADMIN_PASSWORD}"
echo "ORG_ADMIN_REALNAME: ${ORG_ADMIN_REALNAME}"
echo "ORG_ADMIN_EMAIL: ${ORG_ADMIN_EMAIL}"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++"


# start usergrid
# ==============

echo "+++ configure usergrid"

USERGRID_PROPERTIES_FILE=/usr/share/tomcat7/lib/usergrid-deployment.properties

sed -i "s/cassandra.url=localhost:9160/cassandra.url=${CASSANDRA_PORT_9160_TCP_ADDR}:${CASSANDRA_PORT_9160_TCP_PORT}/g" $USERGRID_PROPERTIES_FILE
sed -i "s/cassandra.cluster=Test Cluster/cassandra.cluster=$CASSANDRA_CLUSTER_NAME/g" $USERGRID_PROPERTIES_FILE
sed -i "s/#usergrid.cluster_name=default-property/usergrid.cluster_name=$USERGRID_CLUSTER_NAME/g" $USERGRID_PROPERTIES_FILE
sed -i "s/usergrid.version.build=\${version}/usergrid.version.build=unknown/g" $USERGRID_PROPERTIES_FILE
sed -i "s/usergrid.sysadmin.login.name=superuser/usergrid.sysadmin.login.name=$ADMIN_USERNAME/g" $USERGRID_PROPERTIES_FILE
sed -i "s/usergrid.sysadmin.login.email=super@usergrid.com/usergrid.sysadmin.login.email=$ADMIN_MAIL/g" $USERGRID_PROPERTIES_FILE
sed -i "s/usergrid.sysadmin.login.password=test/usergrid.sysadmin.login.password=$ADMIN_PASSWORD/g" $USERGRID_PROPERTIES_FILE
sed -i "s/usergrid.test-account/#usergrid.test-account/g" $USERGRID_PROPERTIES_FILE
sed -i "s/#elasticsearch.hosts=127.0.0.1/elasticsearch.hosts=${ELASTICSEARCH_PORT_9300_TCP_ADDR}/g" $USERGRID_PROPERTIES_FILE
sed -i "s/#elasticsearch.port=9300/elasticsearch.port=${ELASTICSEARCH_PORT_9300_TCP_PORT}/g" $USERGRID_PROPERTIES_FILE
sed -i "s/#usergrid.use.default.queue=false/usergrid.use.default.queue=true/g" $USERGRID_PROPERTIES_FILE
sed -i "s/#elasticsearch.queue_impl=LOCAL/elasticsearch.queue_impl=LOCAL/g" $USERGRID_PROPERTIES_FILE
sed -i "s/#cassandra.version=1.2/cassandra.version=2.1/g" $USERGRID_PROPERTIES_FILE

sed -i "s/usergrid.org.sysadmin.email=/usergrid.org.sysadmin.email=${ORG_ADMIN_EMAIL}/g" $USERGRID_PROPERTIES_FILE
sed -i "s/usergrid.admin.sysadmin.email=/usergrid.admin.sysadmin.email=${ADMIN_MAIL}/g" $USERGRID_PROPERTIES_FILE

sed -i "s/usergrid.organization.activation.url=http:\/\/localhost:8080\/ROOT\/management\/organizations\/%s\/activate/usergrid.organization.activation.url=http:\/\/usergrid.${DOMAIN}:8080\/management\/organizations\/%s\/activate/g" $USERGRID_PROPERTIES_FILE
sed -i "s/usergrid.organization.activation.url=http:\/\/localhost:8080\/ROOT\/management\/organizations\/%s\/activate/usergrid.organization.activation.url=http:\/\/usergrid.${DOMAIN}:8080\/management\/organizations\/%s\/activate/g" $USERGRID_PROPERTIES_FILE
sed -i "s/usergrid.admin.activation.url=http:\/\/localhost:8080\/ROOT\/management\/users\/%s\/activate/usergrid.admin.activation.url=http:\/\/usergrid.${DOMAIN}:8080\/management\/users\/%s\/activate/g" $USERGRID_PROPERTIES_FILE
sed -i "s/usergrid.admin.confirmation.url=http:\/\/localhost:8080\/ROOT\/management\/users\/%s\/confirm/usergrid.admin.confirmation.url=http:\/\/usergrid.${DOMAIN}:8080\/management\/users\/%s\/confirm/g" $USERGRID_PROPERTIES_FILE
sed -i "s/usergrid.admin.resetpw.url=http:\/\/localhost:8080\/ROOT\/management\/users\/%s\/resetpw/usergrid.admin.resetpw.url=http:\/\/usergrid.${DOMAIN}:8080\/management\/users\/%s\/resetpw/g" $USERGRID_PROPERTIES_FILE
sed -i "s/usergrid.user.activation.url=http:\/\/localhost:8080\/ROOT\/%s\/%s\/users\/%s\/activate/usergrid.user.activation.url=http:\/\/usergrid.${DOMAIN}:8080\/%s\/%s\/users\/%s\/activate/g" $USERGRID_PROPERTIES_FILE
sed -i "s/usergrid.user.confirmation.url=http:\/\/localhost:8080\/ROOT\/%s\/%s\/users\/%s\/confirm/usergrid.user.confirmation.url=http:\/\/usergrid.${DOMAIN}:8080\/%s\/%s\/users\/%s\/confirm/g" $USERGRID_PROPERTIES_FILE
sed -i "s/usergrid.user.resetpw.url=http:\/\/localhost:8080\/ROOT\/%s\/%s\/users\/%s\/resetpw/usergrid.user.resetpw.url=http:\/\/usergrid.${DOMAIN}:8080\/%s\/%s\/users\/%s\/resetpw/g" $USERGRID_PROPERTIES_FILE

# append missing entries
cat <<EOT >> $USERGRID_PROPERTIES_FILE
usergrid.management.admin_users_require_confirmation=false
usergrid.management.admin_users_require_activation=false
usergrid.management.notify_admin_of_activation=false
usergrid.management.organizations_require_confirmation=false
usergrid.management.organizations_require_activation=false
usergrid.management.notify_sysadmin_of_new_organizations=true
usergrid.management.notify_sysadmin_of_new_admin_users=true
EOT

# configure sending mails
cat <<EOT >> $USERGRID_PROPERTIES_FILE
mail.transport.protocol=smtp
mail.smtp.host=mail.dzbw.de
mail.smtp.port=25
mail.smtp.quitwait=false
#mail.smtp.auth=true
#mail.smtp.username=<email username>
#mail.smtp.password=<email password>
EOT

# update tomcat's java options
sed -i "s#\"-Djava.awt.headless=true -Xmx128m -XX:+UseConcMarkSweepGC\"#\"-Djava.awt.headless=true -XX:+UseConcMarkSweepGC -Xmx${TOMCAT_RAM} -Xms${TOMCAT_RAM} -verbose:gc\"#g" /etc/default/tomcat7

echo "+++ start usergrid"
service tomcat7 start


# database setup
# ==============

while [ -z "$(curl -s localhost:8080/status | grep '"cassandraAvailable" : true')" ] ;
do
  echo "+++ tomcat log:"
  tail -n 20 /var/log/tomcat7/catalina.out
  echo "+++ waiting for cassandra being available to usergrid"
  sleep 2
done

echo "+++ usergrid database setup"
curl --user ${ADMIN_USERNAME}:${ADMIN_PASSWORD} -X PUT http://localhost:8080/system/database/setup

echo "+++ usergrid database bootstrap"
curl --user ${ADMIN_USERNAME}:${ADMIN_PASSWORD} -X PUT http://localhost:8080/system/database/bootstrap

echo "+++ usergrid superuser setup"
curl --user ${ADMIN_USERNAME}:${ADMIN_PASSWORD} -X GET http://localhost:8080/system/superuser/setup

echo "+++ create organization and corresponding organization admin account"
echo "organization: ${ORG_NAME}"
echo "username: ${ORG_ADMIN_USERNAME}"
echo "name: ${ORG_ADMIN_REALNAME}"
echo "email: ${ORG_ADMIN_EMAIL}"
echo "password: ${ORG_ADMIN_PASSWORD}"
curl -D - \
     -X POST  \
     -d "organization=${ORG_NAME}&username=${ORG_ADMIN_USERNAME}&name=${ORG_ADMIN_REALNAME}&email=${ORG_ADMIN_EMAIL}&password=${ORG_ADMIN_PASSWORD}" \
     http://localhost:8080/management/organizations

echo "+++ create admin token with permissions"
export ADMINTOKEN=$(curl -X POST --silent "http://localhost:8080/management/token" -d "{ \"username\":\"${ADMIN_USERNAME}\", \"password\":\"${ADMIN_PASSWORD}\", \"grant_type\":\"password\"} " | cut -f 1 -d , | cut -f 2 -d : | cut -f 2 -d \")
echo ADMINTOKEN=$ADMINTOKEN

echo "+++ create app"
echo "name: ${APP_NAME}"
curl -D - \
     -H "Authorization: Bearer ${ADMINTOKEN}" \
     -H "Content-Type: application/json" \
     -X POST -d "{ \"name\":\"${APP_NAME}\" }" \
     http://localhost:8080/management/orgs/${ORG_NAME}/apps

echo "+++ delete guest permissions"
curl -D - \
     -H "Authorization: Bearer ${ADMINTOKEN}" \
     -X DELETE "http://localhost:8080/${ORG_NAME}/${APP_NAME}/roles/guest"

echo "+++ delete default permissions which are too permissive"
curl -D - \
     -H "Authorization: Bearer ${ADMINTOKEN}" \
     -X DELETE "http://localhost:8080/${ORG_NAME}/${APP_NAME}/roles/default" 

echo "+++ create new guest role"
curl -D - \
     -H "Authorization: Bearer ${ADMINTOKEN}" \
     -X POST "http://localhost:8080/${ORG_NAME}/${APP_NAME}/roles" \
     -d "{ \"name\":\"guest\", \"title\":\"Guest\" }"

echo "+++ create new default role, applied to each logged in user"
curl -D - \
     -H "Authorization: Bearer ${ADMINTOKEN}" \
     -X POST "http://localhost:8080/${ORG_NAME}/${APP_NAME}/roles" \
     -d "{ \"name\":\"default\", \"title\":\"User\" }"

echo "+++ create guest permissions post:/token required for login"
curl -D - \
     -H "Authorization: Bearer ${ADMINTOKEN}" \
     -X POST "http://localhost:8080/${ORG_NAME}/${APP_NAME}/roles/guest/permissions" \
     -d "{ \"permission\":\"post:/token\" }"

echo "+++ create guest permissions post:/users required for login"
curl -D - \
     -H "Authorization: Bearer ${ADMINTOKEN}" \
     -X POST "http://localhost:8080/${ORG_NAME}/${APP_NAME}/roles/guest/permissions" \
     -d "{ \"permission\":\"post:/users\" }"

curl -D - \
     -H "Authorization: Bearer ${ADMINTOKEN}" \
     -X POST "http://localhost:8080/${ORG_NAME}/${APP_NAME}/roles/guest/permissions" \
     -d "{ \"permission\":\"get:/auth/facebook\" }"

curl -D - \
     -H "Authorization: Bearer ${ADMINTOKEN}" \
     -X POST "http://localhost:8080/${ORG_NAME}/${APP_NAME}/roles/guest/permissions" \
     -d "{ \"permission\":\"get:/auth/googleplus\" }"

echo "+++ create default permissions for a logged in user"
curl -D - \
     -H "Authorization: Bearer ${ADMINTOKEN}" \
     -X POST "http://localhost:8080/${ORG_NAME}/${APP_NAME}/roles/default/permissions" \
     -d "{ \"permission\":\"get,put,post,delete:/users/\${user}/**\" }"

curl -D - \
     -H "Authorization: Bearer ${ADMINTOKEN}" \
     -X POST "http://localhost:8080/${ORG_NAME}/${APP_NAME}/roles/default/permissions" \
     -d "{ \"permission\":\"post:/notifications\" }"

echo "+++ create user"
curl -D - \
     -H "Authorization: Bearer ${ADMINTOKEN}" \
     -X POST "http://localhost:8080/${ORG_NAME}/${APP_NAME}/users" \
     -d "{ \"username\":\"${ORG_NAME}user\", \"password\":\"${ORG_NAME}user\", \"email\":\"${ORG_NAME}user@example.com\" }"

echo
echo "+++ done"

# log usergrid output do stdout so it shows up in docker logs.
# Use -f to keep the container running
tail -f /var/log/tomcat7/catalina.out /var/log/tomcat7/localhost_access_log.*.txt
