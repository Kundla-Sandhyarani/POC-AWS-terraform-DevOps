#!/bin/bash
# Update system
sudo yum update -y

# Install Java (Amazon Linux Extras)
sudo amazon-linux-extras enable java-openjdk11
sudo yum install java-11-openjdk -y

# Install Maven
sudo yum install maven -y

# Install Jenkins
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Install Tomcat
sudo mkdir /opt/tomcat
cd /opt/tomcat
sudo wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.80/bin/apache-tomcat-9.0.80.tar.gz
sudo tar xzvf apache-tomcat-9.0.80.tar.gz --strip-components=1
sudo chmod +x /opt/tomcat/bin/*.sh
sudo /opt/tomcat/bin/startup.sh
