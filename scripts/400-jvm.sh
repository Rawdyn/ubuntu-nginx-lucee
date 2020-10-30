#!/bin/bash

if [[ -n "${JVM_FILE}"  ]] && [ -f $JVM_FILE ]; then
	echo "Installing Custom JVM"
	mkdir -p /opt/lucee/jvm/$JVM_VERSION
	tar -xzf $JVM_FILE -C /opt/lucee/jvm/$JVM_VERSION --strip-components=1
	chown -R root:root /opt/lucee/jvm
	chmod -R 755 /opt/lucee/jvm
	ln -s /opt/lucee/jvm/$JVM_VERSION /opt/lucee/jvm/current
	echo $'\nJAVA_HOME="/opt/lucee/jvm/current"' >> /etc/default/tomcat8
else
	echo "Custom JVM File $JVM_FILE not specified or not found. OpenJDK will be used."
fi

echo "Tomcat / Lucee Configuration Done, Restarting Tomcat"
service tomcat8 restart
