#!/bin/bash
# Install java, zip, wget
yum install java-1.8.0-openjdk-devel zip unzip wget

#Add tomcat User
useradd -m -U -d /opt/tomcat -s /bin/false tomcat

cd /tmp
wget https://mirrors.estointernet.in/apache/tomcat/tomcat-8/v8.5.59/bin/apache-tomcat-8.5.59.zip

unzip apache-tomcat-*.zip
sudo mkdir -p /opt/tomcat
sudo mv apache-tomcat-8.5.59 /opt/tomcat/

#Create symbolic

ln -s /opt/tomcat/apache-tomcat-8.5.59 /opt/tomcat/latest

#Change directory ownership

chown -R tomcat: /opt/tomcat

sh -c 'chmod +x /opt/tomcat/latest/bin/*.sh'


# create tomcat.service
cd /root
chmod +x tomcat.service
cp tomcat.service /etc/systemd/system/
systemctl daemon-reload
systemctl start tomcat
systemctl status tomcat
systemctl enable tomcat

#Disable Firewall

systemctl stop firewalld
systemctl disable firewalld
systemctl mask --now firewalld


#Oracle

# Add dependency library
yum install bc bind-utils compat-libcap1 compat-libstdc++-33 glibc-devel ksh libaio libaio-devel libstdc++-devel nfs-utils psmisc smartmontools sysstat xorg-x11-utils xorg-x11-xauth

# Download preinstaller for 18c xe
cd /tmp
wget oracle-database-preinstall-18c-1.0-1.el6.x86_64.rpm https://yum.oracle.com/repo/OracleLinux/OL6/latest/x86_64/getPackage/oracle-database-preinstall-18c-1.0-1.el6.x86_64.rpm
chmod +x oracle-database-preinstall-18c-1.0-1.el7.x86_64.rpm
yum localinstall oracle-database-preinstall-18c-1.0-1.el6.x86_64.rpm


# Install oracle db
cd /tmp
wget https://download.oracle.com/otn-pub/otn_software/db-express/oracle-database-xe-18c-1.0-1.x86_64.rpm
chmod +x oracle-database-xe-18c-1.0-1.x86_64.rpm
yum localinstall oracle-database-xe-18c-1.0-1.x86_64.rpm
/etc/init.d/oracle-xe-18c configure
#/etc/init.d/oracle-xe-18c start
#/etc/init.d/oracle-xe-18c stop
#Auto Start
systemctl enable oracle-xe-18c

# Deploy Project 
cd /root
TOMCAT_DIR=/opt/tomcat/latest
rm -rf $TOMCAT_DIR/webapps/project
cp -f project.war $TOMCAT_DIR/webapps/
systemctl restart tomcat