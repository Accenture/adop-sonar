#! /bin/bash
# FROM sonarqube
# COPY resources/plugins.txt ${PLUGINS_DIR}/plugins.txt
# RUN /usr/local/bin/plugins.sh ${PLUGINS_DIR}/plugins.txt
#
set -e

mkdir -p ${SONARQUBE_PLUGINS_DIR}

while read plugin; do
    echo "Downloading ${plugin##*/}"
    curl -s -L -f ${plugin} -o ${SONARQUBE_PLUGINS_DIR}/${plugin##*/}
done  < $1
