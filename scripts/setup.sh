#!/bin/bash
sudo apt update
sudo apt install openjdk-11-jdk -y
sudo apt install maven -y

# Install Jenkins
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install jenkins -y
sudo systemctl start jenkins

# Install Tomcat
sudo mkdir /opt/tomcat
cd /opt/tomcat
sudo wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.80/bin/apache-tomcat-9.0.80.tar.gz
sudo tar xzvf apache-tomcat-9.0.80.tar.gz --strip-components=1
sudo chmod +x /opt/tomcat/bin/*.sh
sudo /opt/tomcat/bin/startup.sh
