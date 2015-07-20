#! /bin/bash
# FROM sonarqube
# COPY resources/plugins.txt ${PLUGINS_DIR}/plugins.txt
# RUN /usr/local/bin/plugins.sh ${PLUGINS_DIR}/plugins.txt
#
set -e

# Copy SonarQube plugins.
if [ "$(ls -A ${SONARQUBE_PLUGINS_DIR})" ]; then
    mv ${SONARQUBE_PLUGINS_DIR}/* /opt/sonarqube/extensions/plugins
fi

SONAR_ARGUMENTS="-Dsonar.web.context=${SONARQUBE_WEB_CONTEXT} \
  -Dsonar.core.serverBaseURL=${SONARQUBE_SERVER_BASE} \
  -Dsonar.forceAuthentication=${SONARQUBE_FORCE_AUTHENTICATION}"

if [ "$ADOP_LDAP_ENABLED" = true ]
  then
  SONAR_ARGUMENTS+=" -Dsonar.security.realm=LDAP \
    -Dsonar.security.savePassword=false \
    -Dldap.url=${LDAP_URL} \
    -Dldap.bindDn=${LDAP_BIND_DN} \
    -Dldap.bindPassword=${LDAP_BIND_PASSWORD} \
    -Dldap.user.baseDn=${LDAP_USER_BASE_DN} \
    -Dldap.user.request=${LDAP_USER_REQUEST} \
    -Dldap.user.realNameAttribute=${LDAP_USER_REAL_NAME_ATTRIBUTE} \
    -Dldap.user.emailAttribute=${LDAP_USER_EMAIL_ATTRIBUTE} \
    -Dldap.group.baseDn=${LDAP_GROUP_BASE_DN} \
    -Dldap.group.request=${LDAP_GROUP_REQUEST} \
    -Dldap.group.idAttribute=${LDAP_GROUP_ID_ATTRIBUTE}"
fi

# Start SonarQube
./bin/run.sh ${SONAR_ARGUMENTS}
