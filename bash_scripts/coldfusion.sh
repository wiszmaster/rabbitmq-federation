# RabbitMQ Worker Installation script for CentOS and Debian based distros

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

function installColdfusion()
{
	apt-get install openssh-server
	apt-get install apt-get install vim-nox

	apt-get install apache2 -y

	# Setup default Coldfusion page
	sudo echo '<html>' > ~/index.cfm
	sudo echo '<head>' >> ~/index.cfm
	sudo echo '<title>' >> ~/index.cfm
	sudo echo 'Welcome to Coldfusion!' >> ~/index.cfm
	sudo echo '</title>' >> ~/index.cfm
	sudo echo '</head>' >> ~/index.cfm
	sudo echo '<body>' >> ~/index.cfm
	sudo echo '<h1>' >> ~/index.cfm
	sudo echo 'It works! - Coldfusion 9' >> ~/index.cfm
	sudo echo '</h1>' >> ~/index.cfm
	sudo echo '<h2>' >> ~/index.cfm
	sudo echo 'Current date and time are <cfoutput>#Now()#</cfoutput>' >> ~/index.cfm
	sudo echo '</h2>' >> ~/index.cfm
	sudo echo '</body>' >> ~/index.cfm
	sudo echo '</html>' >> ~/index.cfm
	sudo mv ~/index.cfm /var/www/index.cfm
	sudo chown root /var/www/index.cfm
	sudo chgrp tomcat /var/www/index.cfm

	apt-get install libstdc++5
}

function initDebian()
{
   echo "Installing RabbitMQ Worker Debian Distro"
	apt-get update

	apt-get install -q -y tmux screen htop vim curl wget build-essentials git-core

	installColdfusion
}

function initCentOS()
{
	echo ""
	echo ""
	echo "CentOS is not complete at this time, switch to Ubuntu for now sorry."
	echo ""
	echo ""
    exit 1
	
   echo "Installing RabbitMQ Worker CentOS Distro"
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