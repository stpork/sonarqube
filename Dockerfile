FROM openjdk:8-alpine

MAINTAINER stpork from Mordor team

ENV SONAR_VERSION=6.7 \
SONARQUBE_HOME=/opt/sonarqube \
SONARQUBE_JDBC_USERNAME=sonaruser \
SONARQUBE_JDBC_PASSWORD=sonar-pass \
SONARQUBE_JDBC_URL=jdbc:postgresql://postgresql:5432/sonarqube

# Http port
EXPOSE 9000

RUN addgroup -S sonarqube && adduser -S -G sonarqube sonarqube

RUN set -x \
&& apk update -qq \
&& update-ca-certificates \
&& apk add --no-cache ca-certificates curl bash unzip su-exec libressl \
&& rm -rf /var/lib/{apt,dpkg,cache,log}/ /tmp/* /var/tmp/* \
&& mkdir /opt \
&& cd /opt \
&& curl -fsSL \
"https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip" \
-o sonarqube.zip \
&& unzip -q sonarqube.zip \
&& mv sonarqube-$SONAR_VERSION sonarqube \
&& chown -R sonarqube:sonarqube sonarqube \
&& rm sonarqube.zip* \
&& rm -rf $SONARQUBE_HOME/bin/*

VOLUME "$SONARQUBE_HOME/data"

WORKDIR $SONARQUBE_HOME
COPY run.sh $SONARQUBE_HOME/bin/
ENTRYPOINT ["./bin/run.sh"]
