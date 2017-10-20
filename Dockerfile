FROM openjdk:8u121-alpine
MAINTAINER stpork from Mordor team

ENV SONAR_VERSION=6.6 \
    SONARQUBE_HOME=/opt/sonarqube \
    SONARQUBE_JDBC_USERNAME=sonar \
    SONARQUBE_JDBC_PASSWORD=sonar \
    SONARQUBE_JDBC_URL=

USER root
EXPOSE 9000
ADD root /

ARG DOWNLOAD_URL=https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-${SONAR_VERSION}.zip

RUN set -x \
    && cd /opt \
    && curl -o sonarqube.zip -L --silent ${DOWNLOAD_URL} \
    && unzip sonarqube.zip \
    && mv sonarqube-$SONAR_VERSION sonarqube \
    && rm sonarqube.zip* \
    && rm -rf $SONARQUBE_HOME/bin/*

WORKDIR $SONARQUBE_HOME
COPY run.sh $SONARQUBE_HOME/bin/

RUN useradd -r sonar
RUN /usr/bin/fix-permissions $SONARQUBE_HOME \
    && chmod 775 $SONARQUBE_HOME/bin/run.sh

USER sonar
ENTRYPOINT ["./bin/run.sh"]
