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

function installApacheWebServer()
{	
	echo ""
	echo "Installing Apache web server"
	echo ""

	sudo su

	# Install Apache web server
	sudo apt-get install apache2 -y
	sudo a2enmod ssl
	sudo a2enmod proxy
	sudo a2enmod proxy_http
	sudo a2enmod rewrite
	sudo a2ensite default-ssl
	sudo service apache2 reload
}

function configureApacheWebServer()
{
	echo ""
	echo "Configuring Apache web server"
	echo ""

	# Configure Apache web server
	LINENUMBER=`sudo grep -n "<\/VirtualHost>" /etc/apache2/sites-available/default | sed 's/:.*//'`
	sudo sed -i "$LINENUMBER"i'\\tRewriteRule ^.*$ https:\/\/%{SERVER_NAME}%{REQUEST_URI} [L,R]' /etc/apache2/sites-available/default
	sudo sed -i "$LINENUMBER"i'\\tRewriteCond %{SERVER_PORT} !^443$' /etc/apache2/sites-available/default
	sudo sed -i "$LINENUMBER"i'\\tRewriteEngine on' /etc/apache2/sites-available/default
	sudo sed -i "$LINENUMBER"i'\\tDirectoryIndex index.cfm index.cfml default.cfm default.cfml index.htm index.html' /etc/apache2/sites-available/default
	LINENUMBER=`sudo grep -n "<\/VirtualHost>" /etc/apache2/sites-available/default-ssl | sed 's/:.*//'`
	
	# Uncomment the following lines if you want CFWheels rewrite support
	sudo sed -i "$LINENUMBER"i'\\tRewriteRule "^\/(.*)" http:\/\/127.0.0.1:8080\/rewrite.cfm\/$1 [P,QSA,L]' /etc/apache2/sites-available/default-ssl
	sudo sed -i "$LINENUMBER"i'\\tRewriteCond %{REQUEST_URI} !^.*\/(flex2gateway|jrunscripts|cfide|cfformgateway|railo-context|files|images|javascripts|miscellaneous|stylesheets|robots.txt|sitemap.xml|favicon.ico|rewrite.cfm)($|\/.*$) [NC]' /etc/apache2/sites-available/default-ssl
	sudo sed -i "$LINENUMBER"i'\\tRewriteEngine On' /etc/apache2/sites-available/default-ssl
	sudo sed -i "$LINENUMBER"i'\\t#Setup CFWheels with URL Rewriting' /etc/apache2/sites-available/default-ssl
	# end Uncomment

	sudo sed -i "$LINENUMBER"i'\\t<\/Location>' /etc/apache2/sites-available/default-ssl
	sudo sed -i "$LINENUMBER"i'\\t\tAllow from 192.168.0.0\/24' /etc/apache2/sites-available/default-ssl
	sudo sed -i "$LINENUMBER"i'\\t\tAllow from 172.16.0.0\/16' /etc/apache2/sites-available/default-ssl
	sudo sed -i "$LINENUMBER"i'\\t\tDeny from all' /etc/apache2/sites-available/default-ssl
	sudo sed -i "$LINENUMBER"i'\\t\tOrder deny,allow' /etc/apache2/sites-available/default-ssl
	sudo sed -i "$LINENUMBER"i'\\t<Location \/railo-context\/admin\/>' /etc/apache2/sites-available/default-ssl
	sudo sed -i "$LINENUMBER"i'\\t#Deny access to admin except for local clients' /etc/apache2/sites-available/default-ssl
	sudo sed -i "$LINENUMBER"i'\\t\tProxyPassReverse \/ http:\/\/127.0.0.1:8080\/' /etc/apache2/sites-available/default-ssl
	sudo sed -i "$LINENUMBER"i'\\t\tProxyPassMatch ^\/(.+\.cf[cm])(\/.*)?$ http:\/\/127.0.0.1:8080\/$1' /etc/apache2/sites-available/default-ssl
	sudo sed -i "$LINENUMBER"i'\\t#Proxy .cfm and cfc requests to Railo' /etc/apache2/sites-available/default-ssl
	sudo sed -i "$LINENUMBER"i'\\tDirectoryIndex index.cfm index.cfml default.cfm default.cfml index.htm index.html' /etc/apache2/sites-available/default-ssl
	sudo sed -i 's/Deny from all/Allow from all/' /etc/apache2/mods-available/proxy.conf

	# Restart Apache
	sudo service apache2 restart
}

function installJava()
{
	echo ""
	echo "Downloading and Installing Java"
	echo ""

	# Download and Install Java Confirmed Working
	#wget https://dl.dropbox.com/s/763l63wev8tcysc/jdk-6u33-linux-x64.bin
	#sudo chmod +x jdk-6u33-linux-x64.bin
#sudo ./jdk-6u33-linux-x64.bin <<LimitString
#yes
#LimitString
#	sudo rm -Rf jdk-6u33-linux-x64
#	sudo mkdir -p /usr/local/java
#	sudo mv jdk1.6.0_33/ /usr/local/java
#	sudo rm /usr/local/java/latest
#	sudo ln -s /usr/local/java/jdk1.6.0_33 /usr/local/java/latest
#	sudo sed -i 1i'JAVA_HOME="/usr/local/java/latest"' /etc/environment
#	sudo sed -i 2i'JRE_HOME="/usr/local/java/latest/jre"' /etc/environment
#export JAVA_HOME="/usr/local/java/latest"
#export JRE_HOME="/usr/local/java/latest/jre"
#export PATH="$JAVA_HOME/bin:$PATH"
#	sudo rm /usr/local/bin/java
#	sudo ln -s /usr/local/java/latest/bin/java /usr/local/bin/java

	# Bleeding Edge 
	# Tested Confirmed Working
	sudo wget https://www.dropbox.com/s/mkbvemeyktz9q2b/jdk-7u25-linux-x64.gz 
	sudo tar -xvzf jdk-7u25-linux-x64.gz
	sudo mkdir -p /usr/local/java
	sudo mv jdk1.7.0_25/ /usr/local/java
	sudo rm /usr/local/java/latest
	sudo ln -s /usr/local/java/jdk1.7.0_25 /usr/local/java/latest
	sudo sed -i 1i'JAVA_HOME="/usr/local/java/latest"' /etc/environment
	sudo sed -i 2i'JRE_HOME="/usr/local/java/latest/jre"' /etc/environment
	export JAVA_HOME="/usr/local/java/latest"
	export JRE_HOME="/usr/local/java/latest/jre"
	export PATH="$JAVA_HOME/bin:$PATH"
	sudo rm /usr/local/bin/java
	sudo ln -s /usr/local/java/latest/bin/java /usr/local/bin/java
}

function installTomCatServer()
{
	echo ""
	echo "Downloading and Installing Apache Tomcat server"
	echo ""

	# Download and Install Apache Tomcat server
	# // TESTED AND WORKING
	#sudo wget https://dl.dropbox.com/s/7v44t942r316ozv/apache-tomcat-7.0.27.tar.gz 
	#sudo tar -xvzf apache-tomcat-7.0.27.tar.gz
	#sudo mv apache-tomcat-7.0.27 /opt/tomcat
	#sudo rm -Rf apache-tomcat-7.0.27.tar.gz
	
	# // Bleeding Edge July 16 2013 ///
	# // TESTED AND WORKING //
	sudo wget https://dl.dropbox.com/s/z1w2kwxb9yv5scn/apache-tomcat-7.0.42.tar.gz
	sudo tar -xvzf apache-tomcat-7.0.42.tar.gz
	sudo mv apache-tomcat-7.0.42 /opt/tomcat
	sudo rm -Rf apache-tomcat-7.0.42.tar.gz

}

function configureTomcat()
{
	echo ""
	echo "Configuring Apache Tomcat"
	echo ""

	# Configure Apache Tomcat
	sudo touch /opt/tomcat/bin/setenv.sh
	echo 'JAVA_HOME="/usr/local/java/latest"' | sudo tee -a /opt/tomcat/bin/setenv.sh
	echo 'JRE_HOME="/usr/local/java/latest/jre"' | sudo tee -a /opt/tomcat/bin/setenv.sh

	echo ""
	echo "Removeing the default Tomcat applications"
	echo ""

	# Remove the default Tomcat applications
	sudo rm -Rf /opt/tomcat/webapps/docs
	sudo rm -Rf /opt/tomcat/webapps/examples
	sudo rm -Rf /opt/tomcat/webapps/host-manager
	sudo rm -Rf /opt/tomcat/webapps/manager
	sudo rm -Rf /opt/tomcat/webapps/ROOT

	echo ""
	echo "Secureing the Tomcat installation"
	echo ""

	# Secure the Tomcat installation
	sudo /usr/sbin/useradd --create-home --home-dir /opt/tomcat --shell /bin/bash tomcat
	sudo usermod -a -G www-data tomcat
	sudo chown -R tomcat:tomcat /opt/tomcat
	sudo chmod -R go-w /opt/tomcat
	sudo chmod -R ugo-rwx /opt/tomcat/conf
	sudo chmod -R u+rwx /opt/tomcat/conf
	sudo chmod -R ugo-rwx /opt/tomcat/temp
	sudo chmod -R u+rwx /opt/tomcat/temp
	sudo chmod -R ugo-rwx /opt/tomcat/logs
	sudo chmod -R u+wx /opt/tomcat/logs
}

function installRailo()
{
	echo ""
	echo "Download and Install Railo"
	echo ""

	# Download and Install Railo 3.3.3.001
	#sudo wget https://dl.dropbox.com/s/3jrije1r8bjqvky/railo-3.3.3.001-jars.tar.gz
	#sudo tar -xvzf railo-3.3.3.001-jars.tar.gz
	#sudo mv railo-3.3.3.001-jars /opt/railo
	#sudo rm -Rf railo-3.3.3.001-jars.tar.gz
	
	# Download and InstallRailo 4.0.4.001
	sudo wget https://www.dropbox.com/s/ux0o6vi5e95oo7g/railo-4.0.4.001-jars.tar.gz
	sudo tar -xvzf railo-4.0.4.001-jars.tar.gz
	sudo mv railo-4.0.4.001-jars /opt/railo/
	sudo rm -Rf railo-4.0.4.001-jars.tar.gz

	sudo rm -Rf /opt/railo/ehcache.jar
	sudo rm -Rf /opt/railo/railo-sl4j.jar
	sudo rm -Rf /opt/railo/slf4j-api.jar
}

function configureRailo()
{
	echo ""
	echo "Configuring Railo"
	echo ""

	# Configure Railo
	sudo sed -i 's/shared.loader=/shared.loader=\/opt\/railo\/*.jar/' /opt/tomcat/conf/catalina.properties
	LINENUMBER=`sudo grep -n "Built In Servlet Mappings" /opt/tomcat/conf/web.xml | sed 's/:.*//'`
	sudo sed -i "$LINENUMBER"i'\\t</servlet>' /opt/tomcat/conf/web.xml
	sudo sed -i "$LINENUMBER"i'\\t\t<load-on-startup>1</load-on-startup>' /opt/tomcat/conf/web.xml
	sudo sed -i "$LINENUMBER"i'\\t\t</init-param>' /opt/tomcat/conf/web.xml
	sudo sed -i "$LINENUMBER"i'\\t\t\t<description>Configuration directory</description>' /opt/tomcat/conf/web.xml
	sudo sed -i "$LINENUMBER"i'\\t\t\t<param-value>{web-root-directory}/WEB-INF/railo/</param-value>' /opt/tomcat/conf/web.xml
	sudo sed -i "$LINENUMBER"i'\\t\t\t<param-name>configuration</param-name>' /opt/tomcat/conf/web.xml
	sudo sed -i "$LINENUMBER"i'\\t\t<init-param>' /opt/tomcat/conf/web.xml
	sudo sed -i "$LINENUMBER"i'\\t\t<servlet-class>railo.loader.servlet.CFMLServlet</servlet-class>' /opt/tomcat/conf/web.xml
	sudo sed -i "$LINENUMBER"i'\\t\t<servlet-name>CFMLServlet</servlet-name>' /opt/tomcat/conf/web.xml
	sudo sed -i "$LINENUMBER"i'\\t<servlet>' /opt/tomcat/conf/web.xml

	LINENUMBER=`sudo grep -n "Built In Filter Definitions" /opt/tomcat/conf/web.xml | sed 's/:.*//'`

	echo ""
	echo "Configuring CFWheels rewrite support"
	echo ""

	# Uncomment the following lines IF you want CFWheels rewrite support
	sudo sed -i "$LINENUMBER"i'\\t</servlet-mapping>' /opt/tomcat/conf/web.xml
	sudo sed -i "$LINENUMBER"i'\\t\t<url-pattern>/rewrite.cfm/*</url-pattern>' /opt/tomcat/conf/web.xml
	sudo sed -i "$LINENUMBER"i'\\t\t<servlet-name>CFMLServlet</servlet-name>' /opt/tomcat/conf/web.xml
	sudo sed -i "$LINENUMBER"i'\\t<servlet-mapping>' /opt/tomcat/conf/web.xml
	sudo sed -i "$LINENUMBER"i'\\t</servlet-mapping>' /opt/tomcat/conf/web.xml
	sudo sed -i "$LINENUMBER"i'\\t\t<url-pattern>/index.cfm/*</url-pattern>' /opt/tomcat/conf/web.xml
	sudo sed -i "$LINENUMBER"i'\\t\t<servlet-name>CFMLServlet</servlet-name>' /opt/tomcat/conf/web.xml
	sudo sed -i "$LINENUMBER"i'\\t<servlet-mapping>' /opt/tomcat/conf/web.xml
	# end Uncomment

	# Railo 4 Rest web Services
	sudo sed -i "$LINENUMBER"i'\\t</servlet-mapping>' /opt/tomcat/conf/web.xml
	sudo sed -i "$LINENUMBER"i'\\t\t<url-pattern>/rest/*</url-pattern>' /opt/tomcat/conf/web.xml
	sudo sed -i "$LINENUMBER"i'\\t\t<servlet-name>RESTServlet</servlet-name>' /opt/tomcat/conf/web.xml
	sudo sed -i "$LINENUMBER"i'\\t<servlet-mapping>' /opt/tomcat/conf/web.xml

	sudo sed -i "$LINENUMBER"i'\\t</servlet>' /opt/tomcat/conf/web.xml  
	sudo sed -i "$LINENUMBER"i'\\t\t<load-on-startup>2</load-on-startup>' /opt/tomcat/conf/web.xml
	sudo sed -i "$LINENUMBER"i'\\t\t<servlet-class>railo.loader.servlet.RestServlet</servlet-class>' /opt/tomcat/conf/web.xml
	sudo sed -i "$LINENUMBER"i'\\t<servlet-name>RESTServlet</servlet-name>' /opt/tomcat/conf/web.xml
	sudo sed -i "$LINENUMBER"i'\\t<description>Railo Servlet for RESTful services</description>' /opt/tomcat/conf/web.xml
	sudo sed -i "$LINENUMBER"i'\\t<servlet id="RESTServlet">' /opt/tomcat/conf/web.xml
	sudo sed -i "$LINENUMBER"i'<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->' /opt/tomcat/conf/web.xml
	sudo sed -i "$LINENUMBER"i'<!-- Railo REST Servlet - handles Railos RESTful web services             -->' /opt/tomcat/conf/web.xml
	sudo sed -i "$LINENUMBER"i'<!--=====================================================================-->' /opt/tomcat/conf/web.xml


	sudo sed -i "$LINENUMBER"i'\\t</servlet-mapping>' /opt/tomcat/conf/web.xml
	sudo sed -i "$LINENUMBER"i'\\t\t<url-pattern>*.cfc</url-pattern>' /opt/tomcat/conf/web.xml
	sudo sed -i "$LINENUMBER"i'\\t\t<servlet-name>CFMLServlet</servlet-name>' /opt/tomcat/conf/web.xml
	sudo sed -i "$LINENUMBER"i'\\t<servlet-mapping>' /opt/tomcat/conf/web.xml
	sudo sed -i "$LINENUMBER"i'\\t</servlet-mapping>' /opt/tomcat/conf/web.xml
	sudo sed -i "$LINENUMBER"i'\\t\t<url-pattern>*.cfml</url-pattern>' /opt/tomcat/conf/web.xml
	sudo sed -i "$LINENUMBER"i'\\t\t<servlet-name>CFMLServlet</servlet-name>' /opt/tomcat/conf/web.xml
	sudo sed -i "$LINENUMBER"i'\\t<servlet-mapping>' /opt/tomcat/conf/web.xml
	sudo sed -i "$LINENUMBER"i'\\t</servlet-mapping>' /opt/tomcat/conf/web.xml
	sudo sed -i "$LINENUMBER"i'\\t\t<url-pattern>*.cfm</url-pattern>' /opt/tomcat/conf/web.xml
	sudo sed -i "$LINENUMBER"i'\\t\t<servlet-name>CFMLServlet</servlet-name>' /opt/tomcat/conf/web.xml
	sudo sed -i "$LINENUMBER"i'\\t<servlet-mapping>' /opt/tomcat/conf/web.xml
	LINENUMBER=`sudo grep -n "<\/welcome-file-list>" /opt/tomcat/conf/web.xml | sed 's/:.*//'`
	sudo sed -i "$LINENUMBER"i'\\t<welcome-file>index.cfm</welcome-file>' /opt/tomcat/conf/web.xml
	sudo sed -i "$LINENUMBER"i'\\t<welcome-file>index.cfml</welcome-file>' /opt/tomcat/conf/web.xml
	LINENUMBER=`sudo grep -n "SingleSignOn valve" /opt/tomcat/conf/server.xml | sed 's/:.*//'`
	sudo sed -i "$LINENUMBER"i'\\t\t<Context path="" docBase="/var/www"/>' /opt/tomcat/conf/server.xml
	sudo chown -R tomcat:tomcat /opt/railo 
}

function intallJavaLoader()
{
	echo ""
	echo "Installing JavaLoader"
	echo ""	

	sudo wget https://www.dropbox.com/s/19ccy3sqi8kahhk/javaloader_v1.1.zip
	sudo unzip javaloader_v1.1.zip -d /opt/railo/
	sudo rm -Rf javaloader_v1.1.zip
}

function installCFWheels()
{
	echo ""
	echo "Installing CFWheels"
	echo ""

	sudo wget https://dl.dropbox.com/s/f5s1ce3n3a6lnq6/cfwheels.1.1.8.zip
	sudo mkdir -p /var/www/millitalk_api
	sudo unzip cfwheels.1.1.8.zip -d /var/www/millitalk_api

	sudo rm -Rf cfwheels.1.1.8.zip
}

function installCFWheelsPlugins()
{
	echo ""
	echo "Installing CFWheels PluginManager"
	echo ""

	sudo wget https://dl.dropbox.com/s/6hkg3gj9ec1qvpi/PluginManager-1.0.6.zip
	sudo mkdir -p /var/www/millitalk_api/plugins	
	sudo mv PluginManager-1.0.6.zip/var/www/millitalk_api/plugins
}

function installedRabbitMQClient()
{
	echo ""
	echo "Installing RabbitMQ Java Client"
	echo ""

	sudo wget https://dl.dropbox.com/s/qhlnpqk0fzt7v0c/rabbitmq-java-client-bin-3.1.3.tar.gz
	sudo tar -xvzf rabbitmq-java-client-bin-3.1.3.tar.gz
	sudo mv rabbitmq-java-client-bin-3.1.3 /usr/local/java/latest/lib
	sudo rm -Rf rabbitmq-java-client-bin-3.1.3.tar.gz
}

function finalizeServerConfiguration()
{
	echo ""
	echo "Starting Tomcat, this creates the Railo server context"
	echo ""

	# Start Tomcat, this creates the Railo server context
	sudo -u tomcat /opt/tomcat/bin/startup.sh

	# Wait for Tomcat to start and load the Railo engine
	sleep 2m

	# Shutdown Tomcat 
	sudo -u tomcat /opt/tomcat/bin/shutdown.sh

	# Wait for Tomcat to shutdown
	sleep 1m

	echo ""
	echo "Configuring Tomcat to start with the system"
	echo ""

	# Configure Tomcat to start with the system
	echo '#!/bin/sh -e' > /etc/init.d/tomcat
	echo '### BEGIN INIT INFO' >> /etc/init.d/tomcat
	echo '# Provides: tomcat' >> /etc/init.d/tomcat
	echo '# Required-Start: $local_fs $remote_fs $network $syslog ' >> /etc/init.d/tomcat
	echo '# Required-Stop: $local_fs $remote_fs $network $syslog ' >> /etc/init.d/tomcat
	echo '# Default-Start: 2 3 4 5 ' >> /etc/init.d/tomcat
	echo '# Default-Stop: 0 1 6 ' >> /etc/init.d/tomcat
	echo '# X-Interactive: true ' >> /etc/init.d/tomcat
	echo '# Short-Description: Start/stop Tomcat as service ' >> /etc/init.d/tomcat
	echo '### END INIT INFO ' >> /etc/init.d/tomcat
	echo ' ' >> /etc/init.d/tomcat
	echo '# setup the JAVA_HOME environment variable ' >> /etc/init.d/tomcat
	echo 'export JAVA_HOME=/usr/local/java/latest ' >> /etc/init.d/tomcat
	echo ' ' >> /etc/init.d/tomcat
	echo 'ENV="env -i LANG=C PATH=/usr/local/bin:/usr/bin:/bin" ' >> /etc/init.d/tomcat
	echo ' ' >> /etc/init.d/tomcat
	echo '#set -e ' >> /etc/init.d/tomcat
	echo ' ' >> /etc/init.d/tomcat
	echo '#. /lib/lsb/init-functions ' >> /etc/init.d/tomcat
	echo ' ' >> /etc/init.d/tomcat
	echo '#test -f /etc/default/rcS && . /etc/default/rcS ' >> /etc/init.d/tomcat
	echo ' ' >> /etc/init.d/tomcat
	echo 'case $1 in ' >> /etc/init.d/tomcat
	echo 'start) ' >> /etc/init.d/tomcat
	echo 'exec sudo -u tomcat /opt/tomcat/bin/startup.sh ' >> /etc/init.d/tomcat
	echo 'echo ' >> /etc/init.d/tomcat
	echo ';; ' >> /etc/init.d/tomcat
	echo 'stop) ' >> /etc/init.d/tomcat
	echo 'exec sudo -u tomcat /opt/tomcat/bin/shutdown.sh ' >> /etc/init.d/tomcat
	echo ';; ' >> /etc/init.d/tomcat
	echo 'restart) ' >> /etc/init.d/tomcat
	echo 'exec sudo -u tomcat /opt/tomcat/bin/shutdown.sh ' >> /etc/init.d/tomcat
	echo 'sleep 30 ' >> /etc/init.d/tomcat
	echo 'exec sudo -u tomcat /opt/tomcat/bin/startup.sh ' >> /etc/init.d/tomcat
	echo 'sleep 30 ' >> /etc/init.d/tomcat
	echo ';; ' >> /etc/init.d/tomcat
	echo 'esac ' >> /etc/init.d/tomcat
	echo 'exit 0 ' >> /etc/init.d/tomcat
	cd /etc/init.d/
	sudo chmod 755 tomcat
	sudo update-rc.d tomcat defaults

	echo ""
	echo "Setting up default CFML page"
	echo ""
	# Setup default CFML page
	sudo echo '<html>' > ~/index.cfm
	sudo echo '<head>' >> ~/index.cfm
	sudo echo '<title>' >> ~/index.cfm
	sudo echo 'Welcome to Railo!' >> ~/index.cfm
	sudo echo '</title>' >> ~/index.cfm
	sudo echo '</head>' >> ~/index.cfm
	sudo echo '<body>' >> ~/index.cfm
	sudo echo '<h1>' >> ~/index.cfm
	sudo echo 'Welcome to Railo running on Tomcat!' >> ~/index.cfm
	sudo echo '</h1>' >> ~/index.cfm
	sudo echo '<h2>' >> ~/index.cfm
	sudo echo 'Current date and time are <cfoutput>#Now()#</cfoutput>' >> ~/index.cfm
	sudo echo '</h2>' >> ~/index.cfm
	sudo echo '</body>' >> ~/index.cfm
	sudo echo '</html>' >> ~/index.cfm
	sudo mv ~/index.cfm /var/www/index.cfm
	sudo chown root /var/www/index.cfm
	sudo chgrp tomcat /var/www/index.cfm

	# Give Tomcat some time, for some reason it needs this, before it can create the /var/www/WEB-INF
	sleep 2m

	echo ""
	echo "Starting Tomcat"
	echo ""

	# Start Tomcat, this still doesn't create the Railo web context, not sure why
	sudo -u tomcat /opt/tomcat/bin/startup.sh
	
	# Wait for Tomcat to start and load the Railo engine
	sleep 2m

	echo ""
	echo "Shutdown Tomcat"
	echo ""

	# Shutdown Tomcat 
	sudo -u tomcat /opt/tomcat/bin/shutdown.sh

	# Wait for Tomcat to shutdown
	sleep 1m

	echo ""
	echo "Start Tomcat, this finally creates the Railo web context"
	echo ""

	# Start Tomcat, this finally creates the Railo web context, not sure why it takes three starts
	sudo -u tomcat /opt/tomcat/bin/startup.sh

	# Wait for Tomcat to start and load the Railo engine
	sleep 2m

	echo ""
	echo "Secure the Railo web"
	echo ""

	# Secure the Railo web
	sudo mkdir -p /var/www/WEB-INF
	sudo chown -hR tomcat /var/www
	sudo chgrp -hR tomcat /var/www 
}

function installSublimtText3()
{
	echo ""
	echo "Installing and Configuring Sublime Text 2"
	echo ""

	sudo add-apt-repository ppa:webupd8team/sublime-text-2
	sudo apt-get update
	sudo apt-get install sublime-text
}

function initDebian()
{
	echo ""
	echo "Installing Debian Distro"
	echo ""

	# Update the server with the latest updates
	sudo apt-get update
	sudo apt-get install -q -y tmux screen htop unzip vim curl wget build-essentials git-core
	# Install unzip utility
	sudo apt-get install vim -y
	sudo apt-get install unzip -y
	sudo apt-get install python-software-properties -y

	#sudo apt-get update -y
	#sudo apt-get upgrade -y
	#sudo apt-get dist-upgrade -y

	installApacheWebServer
	configureApacheWebServer
	installJava
	installTomCatServer
	configureTomcat
	installRailo
	configureRailo
	installCFWheels
	intallJavaLoader
	installCFWheelsPlugins
	installedRabbitMQClient
	finalizeServerConfiguration

	#sudo apt-get update -y
	#sudo apt-get upgrade -y
	#sudo apt-get dist-upgrade -y
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