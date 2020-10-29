#!/bin/bash

echo "Installing Oracle JVM"
if [[ -n "${JVM_FILE}"  ]] && [ -f $JVM_FILE ]; then
	mkdir -p /opt/lucee/jvm/$JVM_VERSION
	tar -xzf $JVM_FILE -C /opt/lucee/jvm/$JVM_VERSION --strip-components=1
	chown -R root:root /opt/lucee/jvm
	chmod -R 755 /opt/lucee/jvm
	ln -s /opt/lucee/jvm/$JVM_VERSION /opt/lucee/jvm/current
	echo $'\nJAVA_HOME="/opt/lucee/jvm/current"' >> /etc/default/tomcat8
else
	echo "File $JVM_FILE not found, SKIPPING Oracle JVM Installation"
fi

echo "Tomcat / Lucee Configuration Done, Restarting Tomcat"
service tomcat8 restart
