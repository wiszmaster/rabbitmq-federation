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


function initDebian()
{
	echo ""
	echo "Update the server with the latest updates"
	echo ""

	# Update the server with the latest updates
	sudo apt-get update

}

function initCentOS()
{
	echo ""
	echo "CentOS is not complete at this time, switch to Ubuntu for now sorry."
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