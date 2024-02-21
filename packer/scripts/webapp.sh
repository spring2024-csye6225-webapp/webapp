#!/bin/bash

echo "sudo yum update -y"

sudo yum install -y postgresql-server
sudo postgresql-setup initdb
sudo systemctl enable postgresql
sudo systemctl start postgresql
sudo -u postgres psql -c "CREATE USER abhaydeshpande WITH PASSWORD 'abhaydeshpande';"
sudo -u postgres psql -c "CREATE DATABASE cloudusers;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE cloudusers to abhaydeshpande;"


echo "Node.js and npm Installation"
curl -fsSL https://rpm.nodesource.com/setup_16.x | sudo bash -
sudo yum install -y nodejs

echo "Node.js and npm Versions"
node -v
npm -v




echo "+-------------------------------------------------------------+"
echo "|                    Setup csye6225 group                     |"
echo "+-------------------------------------------------------------+"
sudo groupadd csye6225
sudo useradd -s /usr/sbin/nologin -g csye6225 -d /opt/csye6225 -m csye6225

echo "+-------------------------------------------------------------+"
echo "|                    UNZIP WEBAPP                             |"
echo "+-------------------------------------------------------------+"
sudo yum install -y unzip

echo "Check webapp-new in the home directory"
ls
ls -ld /opt/csye6225
sudo chmod -R 770 /opt/csye6225

echo "Copy webapp-new.zip to user home directory"
sudo cp -r webapp-new.zip webapp.service /opt/csye6225
cd /opt/csye6225


ls
echo "Unzip in /opt/csye6225"
sudo unzip -o webapp-new.zip

echo "Check if the file exists"
ls 

echo "+-------------------------------------------------------------+"
echo "|                    Install Node Modules                     |"
echo "+-------------------------------------------------------------+"
echo "Change directory to webapp-new to install node modules"
cd webapp-new
sudo npm install

echo "+-------------------------------------------------------------+"
echo "|                    Setup webapp.service                     |"
echo "+-------------------------------------------------------------+"
echo "Copy webapp.service to /lib/systemd/system"
echo "logging current files strcuture" 
ls
echo "copy"

echo "node location"
which node

sudo cp ../webapp.service /lib/systemd/system

echo "logging systemd"
cd  /lib/systemd/system
ls 

echo "moving back" 
 cd /opt/csye6225/webapp-new

echo "+-------------------------------------------------------------+"
echo "|                    Setup new user permissions               |"
echo "+-------------------------------------------------------------+"
echo "Get the home directory of the user"
echo ~csye6225
echo "Display permissions of user directory"
ls -la /opt/csye6225

echo "Change permissions of webapp-new"
sudo chown -R csye6225:csye6225 /opt/csye6225/webapp-new
sudo chmod -R 770 /opt/csye6225/webapp-new

echo "Display permissions of user directory after changes"
ls -la /opt/csye6225

echo "+-------------------------------------------------------------+"
echo "|                    Setup Systemd                            |"
echo "+-------------------------------------------------------------+"


sudo systemctl start webapp.service
sudo systemctl status webapp.service
sudo systemctl enable webapp.service
