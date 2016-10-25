#Supported tags and respective Dockerfile links

- [`0.1.0`, `0.1.0` (*0.1.0/Dockerfile*)](https://github.com/Accenture/adop-sonar/blob/master/Dockerfile.md)

# What is adop-sonar?

adop-sonar is a wrapper for the sonarqube image. It has primarily been built to perform extended configuration.
SonarQube® software (previously called Sonar) is an open source quality management platform, dedicated to continuously analyze and measure technical quality, from project portfolio to method.

# How to use this image

## Run SonarQube

To start the server with the default H2 database run the following, where VERSION is the release version of the Docker container.

      docker run -d --name sonarqube -p 9000:9000 -e ADOP_LDAP_ENABLED=false adop/sonar:VERSION

## Database configuration

By default, the image will use an embedded H2 database that is not suited for production.

The production database is configured with these variables: `SONARQUBE_JDBC_USERNAME`, `SONARQUBE_JDBC_PASSWORD` and `SONARQUBE_JDBC_URL`.

      docker run -d --name sonarqube \
          -p 9000:9000 -p 9092:9092 \
          -e SONARQUBE_JDBC_USERNAME=sonar \
          -e SONARQUBE_JDBC_PASSWORD=sonar \
          -e SONARQUBE_JDBC_URL="jdbc:mysql://sonar-mysql.service.adop.consul:3306/sonar?useUnicode=true&characterEncoding=utf8" \
          adop/sonar:VERSION

A standard MySQL database can be started with the following.

      docker run -td -p 3306:3306 -v /data/sonar:/var/lib/mysql  \
          -e MYSQL_USERNAME=sonar \
          -e MYSQL_PASSWORD=sonar \
          -e MYSQL_DATABASE=sonar \
          -e MYSQL_ROOT_PASSWORD=sonar mysql:5.7

> [MySQL/Docker/Documentation](https://registry.hub.docker.com/_/mysql/)

## LDAP Authentication

By default, the image will enable LDAP authentication, setting the `ADOP_LDAP_ENABLED` environment variable to false will disable LDAP authentication.

The image reads the following LDAP environment variables:

 * ldap.bindDn=${`LDAP_BIND_DN`} - the ldap root user bindn
 * ldap.bindPassword=${`LDAP_BIND_PASSWORD`} - LDAP user roo user password
 * ldap.user.baseDn=${`LDAP_USER_BASE_DN`} - user basedn
 * ldap.user.request=${`LDAP_USER_REQUEST`} - user query
 * ldap.user.realNameAttribute=${`LDAP_USER_REAL_NAME_ATTRIBUTE`} - user's real name attribute e.g. displayName
 * ldap.user.emailAttribute=${`LDAP_USER_EMAIL_ATTRIBUTE`} - user's email attribute, e.g. mail
 * ldap.group.baseDn=${`LDAP_GROUP_BASE_DN`} - group basedn
 * ldap.group.request=${`LDAP_GROUP_REQUEST`} - group query
 * ldap.group.idAttribute=${`LDAP_GROUP_ID_ATTRIBUTE`} - user group id attribute, e.g. cn

> [SonarQube/plugin/LDAP/Documentation](http://redirect.sonarsource.com/plugins/ldap.html)

## Other configuration variables

 * `SONARQUBE_WEB_CONTEXT` - sonar web context e.g. /sonar
 * `SONARQUBE_SERVER_BASE` - sonar base e.g. http//domain.com/sonar
 * `SONARQUBE_JMX_ENABLED` - Enable JMX. Allowed values are true or false. Default : `false`
 * `SONARQUBE_JMX_AUTH` - Enable Authentication on JMX Connections when JMX is enabled. Allowed values are true or false. Default : `false`
 * `SONARQUBE_JMX_HOST` - Hostname or IP address of the host to which JMX clients connect. Default : `localhost`
 * `SONARQUBE_JMX_PORT` - JMX Port. Default : `10433`
 * `SONARQUBE_JMX_USER` - Set username when authentication for JMX is enabled. Default: `admin`
 * `SONARQUBE_JMX_USER_PASSWORD` - Set password for JMX user. Default: `adminpassword`

# License
Please view [licence information](LICENCE.md) for the software contained on this image.

# Supported Docker versions

This image is officially supported on Docker version 1.9.1.
Support for older versions (down to 1.6) is provided on a best-effort basis.

# User feedback

## Documentation
Documentation for this image is available in the [Sonar documentation page](http://docs.sonarqube.org/display/SONAR/Documentation).
Additional documentaion can be found under the [`docker-library/docs` GitHub repo](https://github.com/docker-library/docs). Be sure to familiarize yourself with the [repository's `README.md` file](https://github.com/docker-library/docs/blob/master/README.md) before attempting a pull request.

## Issues
If you have any problems with or questions about this image, please contact us through a [GitHub issue](https://github.com/Accenture/adop-sonar/issues).

## Contribute
You are invited to contribute new features, fixes, or updates, large or small; we are always thrilled to receive pull requests, and do our best to process them as fast as we can.

Before you start to code, we recommend discussing your plans through a [GitHub issue](https://github.com/Accenture/adop-sonar/issues), especially for more ambitious contributions. This gives other contributors a chance to point you in the right direction, give you feedback on your design, and help you find out if someone else is working on the same thing.
