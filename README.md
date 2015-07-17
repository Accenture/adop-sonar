# Docker SonarQube Repository

This is the Git repo for the Accenture DevOps Platform SonarQube wrapper Docker file. It exposes a number of environment variable to enhance the configuration capabilities of the container.

# What is SonarQube?

SonarQube® software (previously called Sonar) is an open source quality management platform, dedicated to continuously analyze and measure technical quality, from project portfolio to method.

> [Sonar/Documentation](http://docs.sonarqube.org/display/SONAR/Documentation)

![logo](https://upload.wikimedia.org/wikipedia/commons/e/e6/Sonarqube-48x200.png)

# How to use this image?

## Run SonarQube

To start the server with the default H2 database run the following, where version is the release version of the Docker container.
    
      $ docker run -d --name sonarqube -p 9000:9000 -e ADOP_LDAP_ENABLED=false com.accenture.com/adop/sonar:VERSION

## Database configuration

By default, the image will use an embedded H2 database that is not suited for production.

The production database is configured with these variables: SONARQUBE_JDBC_USERNAME, SONARQUBE_JDBC_PASSWORD and SONARQUBE_JDBC_URL.

      $ docker run -d --name sonarqube \
          -p 9000:9000 -p 9092:9092 \
          -e SONARQUBE_JDBC_USERNAME=sonar \
          -e SONARQUBE_JDBC_PASSWORD=sonar \
          -e SONARQUBE_JDBC_URL="jdbc:mysql://sonar-mysql.service.adop.consul:3306/sonar?useUnicode=true&characterEncoding=utf8" \
          com.accenture.com/adop/sonar:VERSION

A standard MySQL database can be started with the following.

      $ docker run -td -p 3306:3306 -v /data/sonar:/var/lib/mysql  \
            -e MYSQL_USERNAME=sonar \
            -e MYSQL_PASSWORD=sonar \
            -e MYSQL_DATABASE=sonar a
            -e MYSQL_ROOT_PASSWORD=my-secret-pw mysql:5.7

> [MySQL/Docker/Documentation](https://registry.hub.docker.com/_/mysql/)

## LDAP Authentication

By default, the image will enable LDAP authentication, setting the ADOP_LDAP_ENABLED environment variable to false will disable LDAP authentication.

The image reads the following LDAP environment variables:

 * ldap.bindDn=${LDAP_BIND_DN} - the ldap root user bindn
 * ldap.bindPassword=${LDAP_BIND_PASSWORD} - LDAP user roo user password
 * ldap.user.baseDn=${LDAP_USER_BASE_DN} - user basedn
 * ldap.user.request=${LDAP_USER_REQUEST} - user query
 * ldap.user.realNameAttribute=${LDAP_USER_REAL_NAME_ATTRIBUTE} - user's real name attribute e.g. displayName
 * ldap.user.emailAttribute=${LDAP_USER_EMAIL_ATTRIBUTE} - user's email attribute, e.g. mail
 * ldap.group.baseDn=${LDAP_GROUP_BASE_DN} - group basedn
 * ldap.group.request=${LDAP_GROUP_REQUEST} - group query
 * ldap.group.idAttribute=${LDAP_GROUP_ID_ATTRIBUTE} - user group id attribute, e.g. cn

> [SonarQube/plugin/LDAP/Documentation](http://redirect.sonarsource.com/plugins/ldap.html)
