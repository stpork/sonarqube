FROM openjdk:8-alpine

MAINTAINER stpork from Mordor team

ENV SONAR_VERSION=6.7.1 \
SONAR_HOME=/opt/sonarqube \
SONAR_JDBC_USERNAME=sonaruser \
SONAR_JDBC_PASSWORD=sonar-pass \
SONAR_JDBC_URL=jdbc:postgresql://postgresql:5432/sonarqube

ENV HOME=${SONAR_HOME}

RUN set -x \
&& apk update -qq \
&& update-ca-certificates \
&& apk add --no-cache ca-certificates curl bash unzip su-exec libressl tini \
&& rm -rf /var/cache/apk/* /var/lib/{apt,dpkg,cache,log}/ /tmp/* /var/tmp/* \
&& mkdir /opt \
&& cd /opt \
&& curl -fsSL \
"https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip" \
-o sonarqube.zip \
&& unzip -q sonarqube.zip \
&& mv sonarqube-$SONAR_VERSION sonarqube \
&& rm sonarqube.zip* \
&& rm -rf $SONAR_HOME/bin/* \
&& chown -R 1001:0 ${SONAR_HOME} \
&& chmod -R 775 ${SONAR_HOME}

USER 1001

EXPOSE 9000

VOLUME ["$SONAR_HOME/data", "$SONAR_HOME/extensions"]

WORKDIR $SONAR_HOME

COPY run.sh $SONAR_HOME/bin/

CMD ["./bin/run.sh"]
ENTRYPOINT ["/sbin/tini", "--"]
