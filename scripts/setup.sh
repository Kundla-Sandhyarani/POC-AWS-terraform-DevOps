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

# Install Docker
sudo yum install docker -y
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ec2-user

# Install Tomcat
sudo mkdir /opt/tomcat
cd /opt/tomcat
sudo wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.80/bin/apache-tomcat-9.0.80.tar.gz
sudo tar xzvf apache-tomcat-9.0.80.tar.gz --strip-components=1
sudo chmod +x /opt/tomcat/bin/*.sh
sudo sed -i 's/port="8080"/port="9090"/' /opt/tomcat/conf/server.xml
sudo /opt/tomcat/bin/shutdown.sh
sudo /opt/tomcat/bin/startup.sh

# Create a simple Java web app
mkdir -p ~/java-webapp/src/main/webapp
mkdir -p ~/java-webapp/WEB-INF

cat > ~/java-webapp/src/main/webapp/index.jsp <<EOF
<html>
  <body>
    <h1>Hello from Dockerized WAR!</h1>
  </body>
</html>
EOF

cat > ~/java-webapp/WEB-INF/web.xml <<EOF
<web-app xmlns="http://java.sun.com/xml/ns/javaee" version="3.0">
  <display-name>SampleApp</display-name>
</web-app>
EOF

# Package WAR file
cd ~/java-webapp
mkdir -p target
jar -cvf target/sample.war -C src/main/webapp/ . -C WEB-INF/ .

# Create Dockerfile to deploy WAR in Tomcat
cat > Dockerfile <<EOF
FROM tomcat:9.0
COPY target/sample.war /usr/local/tomcat/webapps/sample.war
EOF

# Build Docker image
docker build -t sample-java-app .

# Run Docker container
docker run -d --name sample-app -p 8081:8080 sample-java-app
