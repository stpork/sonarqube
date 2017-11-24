#!/bin/sh

set -e

if [ "${1:0:1}" != '-' ]; then
  exec "$@"
fi

exec java -jar lib/sonar-application-$SONAR_VERSION.jar \
  -Dsonar.log.console=true \
  -Dsonar.jdbc.username="$SONAR_JDBC_USERNAME" \
  -Dsonar.jdbc.password="$SONAR_JDBC_PASSWORD" \
  -Dsonar.jdbc.url="$SONAR_JDBC_URL" \
  -Dsonar.web.javaAdditionalOpts="$SONAR_WEB_JVM_OPTS -Duser.home=${SONAR_HOME} -Djava.security.egd=file:/dev/./urandom" \
  "$@"
