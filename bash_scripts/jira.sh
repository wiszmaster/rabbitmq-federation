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

function installJava()
{
  echo ""
  echo "Downloading and Installing Java"
  echo ""

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

function installPostgres()
{
  echo ""
  echo "Installing Postgres"
  echo ""

}

function installJira()
{
  echo ""
  echo "Installing Jira"
  echo

  # Download and InstallRailo 4.0.4.001
  sudo wget https://dl.dropbox.com/s/rx4bluyx759lf5x/atlassian-jira-6.0.5.tar.gz
  sudo tar -xvzf atlassian-jira-6.0.5.tar.gz
  sudo mv atlassian-jira-6.0.5-standalone /opt/atlassian/jira/
  sudo chown jira: /opt/atlassian/jira
  sudo rm -Rf atlassian-jira-6.0.5.tar.gz

  sudo su - jira

  export JRE_HOME="/opt/atlassian/jira"

  #sudo /usr/sbin/useradd --create-home --comment "Account for running JIRA" --shell /bin/bash jira
  sudo useradd --create-home -c "JIRA role account" jira

  sudo /opt/atlassian/jira/bin/start-jira.sh

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

  sudo apt-get install ubuntu-desktop -y

  #sudo apt-get update -y
  #sudo apt-get upgrade -y
  #sudo apt-get dist-upgrade -y

  installJava
  installPostgres
  #installJira

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


