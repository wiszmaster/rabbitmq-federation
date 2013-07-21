

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


function installMySQL()
{
	echo ""
	echo "Installing MySql"
	echo ""

	sudo apt-get install mysql-server -y
}

function configureMysql()
{
	echo ""
	echo "Installing MySql"
	echo ""

}


function initDebian()
{
	echo ""
	echo "Update the server with the latest updates"
	echo ""

	# Update the server with the latest updates
	sudo apt-get update
	sudo apt-get install -q -y tmux screen htop unzip vim curl wget build-essentials git-core
	# Install unzip utility
	sudo apt-get install unzip -y

	installMySQL
	configureMysql
}

function initCentOS()
{
	echo ""
	echo "Installing Cento Distro"
	echo "CentOS is not complete at this time, switch to Ubuntu for now sorry."
	echo ""

    exit 1
	
   echo "Installing CentOS Distro"
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