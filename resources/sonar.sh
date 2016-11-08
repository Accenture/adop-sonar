#! /bin/bash
# FROM sonarqube
# COPY resources/plugins.txt ${PLUGINS_DIR}/plugins.txt
# RUN /usr/local/bin/plugins.sh ${PLUGINS_DIR}/plugins.txt
#
set -e

# Copy SonarQube plugins.
if [ "$(ls -A ${SONARQUBE_PLUGINS_DIR})" ]; then
    # Create a backup folder for the provided plugins
    mkdir -p /opt/sonarqube/extensions/plugins/backup

    # Move the downloaded plugins over and replace any existing versions
    # We assume that the only reason to provide another plugin URL is to provide a new or later version
    for plugin_path in $(ls ${SONARQUBE_PLUGINS_DIR}/*.jar 2> /dev/null); do
        if [ -f "${plugin_path}" ]; then
            plugin_name=$(echo "${plugin_path}" | rev | cut -d'/' -f1 | rev)
            plugin_base_name=$(echo "${plugin_name}" | sed 's/\(.*\)-\([0-9.]*\).jar/\1/')
            set +e
            existing_plugin_name=$(ls -A /opt/sonarqube/extensions/plugins/${plugin_base_name}-*.jar 2> /dev/null)
            set -e
            if [[ "$ADOP_LDAP_ENABLED" != "true" && "${plugin_name}" == *ldap* ]]; then continue ; fi
            if [ -f "${existing_plugin_name}" ]; then mv ${existing_plugin_name} /opt/sonarqube/extensions/plugins/backup/; fi
            mv ${plugin_path} /opt/sonarqube/extensions/plugins/
            existing_plugin_name=""
        fi
    done
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

if [ "$SONARQUBE_JMX_ENABLED" = true ]
  then
  SONARQUBE_WEB_JVM_OPTS+="-Dcom.sun.management.jmxremote \
    -Dcom.sun.management.jmxremote.ssl=false \
    -Dcom.sun.management.jmxremote.local.only=false \
    -Djava.rmi.server.hostname=${SONARQUBE_JMX_HOST:-localhost} \
    -Dcom.sun.management.jmxremote.port=${SONARQUBE_JMX_PORT:-10433} \
    -Dcom.sun.management.jmxremote.rmi.port=${SONARQUBE_JMX_PORT:-10433} "
  if [ "$SONARQUBE_JMX_AUTH" = true ]
  then
        SONARQUBE_WEB_JVM_OPTS+=" -Dcom.sun.management.jmxremote.authenticate=true -Dcom.sun.management.jmxremote.password.file=/opt/sonarqube/conf/jmxremote.password -Dcom.sun.management.jmxremote.access.file=/opt/sonarqube/conf/jmxremote.access"
	# Create JMX password and access file
	echo "${SONARQUBE_JMX_USER:-admin} readwrite \\" > /opt/sonarqube/conf/jmxremote.access
	echo '	create javax.management.monitor.*,javax.management.timer.*,com.sun.management.*,com.oracle.jrockit.* \' >> /opt/sonarqube/conf/jmxremote.access
	echo '	unregister' >> /opt/sonarqube/conf/jmxremote.access

	echo "${SONARQUBE_JMX_USER:-admin} ${SONARQUBE_JMX_USER_PASSWORD:-adminpassword}" > /opt/sonarqube/conf/jmxremote.password
        chmod 600 /opt/sonarqube/conf/jmxremote.access /opt/sonarqube/conf/jmxremote.password
  else
	SONARQUBE_WEB_JVM_OPTS+=" -Dcom.sun.management.jmxremote.authenticate=false "
  fi
  export SONARQUBE_WEB_JVM_OPTS
fi

# Get access logs on STDOUT
if [ ! -e "/opt/sonarqube/logs/access.log" ]
  then
  ln -s /dev/stdout /opt/sonarqube/logs/access.log
fi
# Start SonarQube
./bin/run.sh ${SONAR_ARGUMENTS}
