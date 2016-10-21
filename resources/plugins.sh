#! /bin/bash
# FROM sonarqube
# COPY resources/plugins.txt ${PLUGINS_DIR}/plugins.txt
# RUN /usr/local/bin/plugins.sh ${PLUGINS_DIR}/plugins.txt
#
set -e

mkdir -p ${SONARQUBE_PLUGINS_DIR}

while read plugin; do
    fullname=$(basename "$plugin")
    extension="${fullname##*.}"
    filename="${fullname%.*}"
    echo "Downloading ${fullname}"
    case ${extension} in 
        'jar') curl -s -L -f ${plugin} -o ${SONARQUBE_PLUGINS_DIR}/${fullname}
		       ;;
        'zip') curl -s -L -f ${plugin} -o /tmp/${fullname}
               cd ${SONARQUBE_PLUGINS_DIR}
               unzip -j /tmp/${fullname} "*${filename}.jar"
               rm -rf /tmp/${fullname}
               ;;
        *) "ERROR: Unable to download ${fullname} doe to unsupported download url."
               ;;
    esac
done  < $1
