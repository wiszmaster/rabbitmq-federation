#!/bin/bash

# RabbitMQ Installation script for CentOS and Debian based distros

# Identify Linux Distribution
if [ -f /etc/debian_version ] ; then
    DIST="DEBIAN"
elif [ -f /etc/redhat-release ] ; then
    DIST="CENTOS"
else
    echo ""
    echo "This Installer should be run on a CentOS or a Debian based system"
    echo ""
    exit 1
fi

function initDebian()
{
   echo "Installing RabbitMQ Broker Debian Distro"
   
cat >> /etc/apt/sources.list <<EOT
deb http://www.rabbitmq.com/debian/ testing main
EOT

	wget http://www.rabbitmq.com/rabbitmq-signing-key-public.asc
	apt-key add rabbitmq-signing-key-public.asc

	apt-get -y update

	apt-get install -q -y screen htop vim curl wget
	apt-get install -q -y rabbitmq-server

	# RabbitMQ Plugins
	service rabbitmq-server stop
	rabbitmq-plugins enable rabbitmq_management
	rabbitmq-plugins enable rabbitmq_jsonrpc
	rabbitmq-plugins enable rabbitmq_federation
	rabbitmq-plugins enable rabbitmq_federation_management
	rabbitmq-plugins enable rabbitmq_mqtt
	service rabbitmq-server start

	rabbitmq-plugins list
}

function initCentOS()
{
	echo ""
	echo ""
	echo "CentOS is not complete at this time, switch to Ubuntu for now sorry."
	echo ""
	echo ""
    exit 1
	
   echo "Installing RabbitMQ Broker CentOS Distro"
	yum -y update
    VERS=$(cat /etc/redhat-release |cut -d' ' -f4 |cut -d'.' -f1)
	if [ "$VERS" = "6" ]
		then
			echo "version 6"
		else
			echo "version 5"	
	fi
}

case $DIST in
	'DEBIAN')
	initDebian
;;
    'CENTOS')
	initCentOS
;;
esac




