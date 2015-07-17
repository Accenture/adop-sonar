FROM sonarqube:4.5.4

MAINTAINER Robert Northard, <robert.a.northard>

ENV SONARQUBE_PLUGINS_DIR=/opt/sonarqube/extensions/default/plugins \
    SONARQUBE_SERVER_BASE="http://localhost:9000" \
    SONARQUBE_WEB_CONTEXT="/sonar" \
    ADOP_LDAP_ENABLED=true

COPY resources/plugins.txt ${SONARQUBE_PLUGINS_DIR}/
COPY sonar.sh plugins.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/* ; \
    /usr/local/bin/plugins.sh ${SONARQUBE_PLUGINS_DIR}/plugins.txt

VOLUME ["/opt/sonarqube/extensions/plugins/"]

ENTRYPOINT ["/usr/local/bin/sonar.sh"]
