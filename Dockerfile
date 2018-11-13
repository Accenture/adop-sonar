FROM sonarqube:6.7.5

MAINTAINER Robert Northard, <robert.a.northard>

ENV SONARQUBE_PLUGINS_DIR=/opt/sonarqube/default/extensions/plugins \
    SONARQUBE_SERVER_BASE="http://localhost:9000" \
    SONARQUBE_WEB_CONTEXT="/sonar" \
    SONARQUBE_FORCE_AUTHENTICATION=true \
    ADOP_LDAP_ENABLED=true \
    SONARQUBE_JMX_ENABLED=false \
    DOCKERIZE_VERSION=v0.5.0

RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz

COPY resources/plugins.txt ${SONARQUBE_PLUGINS_DIR}/
COPY resources/sonar.sh resources/plugins.sh /usr/local/bin/
COPY resources/sonar.properties.tmpl /tmp/

RUN chmod +x /usr/local/bin/*
RUN /usr/local/bin/plugins.sh ${SONARQUBE_PLUGINS_DIR}/plugins.txt

VOLUME ["/opt/sonarqube/logs/"]

ENTRYPOINT ["/usr/local/bin/sonar.sh"]
