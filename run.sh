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
-Dsonar.security.realm="$SONAR_SECURITY_REALM" \
-Dsonar.security.localUser=$SONAR_SECURITY_LOCALUSERS
-Dcrowd.application="$SONAR_CROWD_APPLICATION" \
-Dcrowd.password="$SONAR_CROWD_PASSWORD" \
-Dcrowd.url="$SONAR_CROWD_URL" \
-Dsonar.web.javaAdditionalOpts="$SONAR_WEB_JVM_OPTS \
-Duser.home=${SONAR_HOME} \
-Djava.security.egd=file:/dev/./urandom" \
"$@"
