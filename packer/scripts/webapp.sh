#!/bin/bash

echo "sudo yum update -y"

sudo yum install -y postgresql-server
sudo postgresql-setup initdb
sudo systemctl enable postgresql
sudo systemctl start postgresql
sudo -u postgres psql -U postgres -c "CREATE USER abhaydeshpande WITH PASSWORD 'abhaydeshpande';"
sudo -u postgres psql -U postgres -c "CREATE DATABASE cloudusers;"
sudo -u postgres psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE cloudusers to abhaydeshpande;"


sudo sed -i 's/host    all             all             127.0.0.1\/32            ident/host    all             all             127.0.0.1\/32            password/g' /var/lib/pgsql/data/pg_hba.conf

sudo sed -i 's/host    all             all             ::1\/128                 ident/host    all             all             ::1\/128                 password/g' /var/lib/pgsql/data/pg_hba.conf

echo "Node.js and npm Installation"
curl -fsSL https://rpm.nodesource.com/setup_16.x | sudo bash -
sudo yum install -y nodejs

echo "Node.js and npm Versions"
node -v
npm -v


echo "+-------------------------------------------------------------+"
echo "|                    UNZIP WEBAPP                             |"
echo "+-------------------------------------------------------------+"
sudo yum install -y unzip


echo "existing files"
cd /tmp

sleep 1m
echo "Unzip the zip folder"
sudo unzip -o webapp-new.zip


echo "zipped"
ls 

echo "Copy webapp-new.zip to user home directory"
sudo cp -r webapp-new /opt/csye6225
sudo cp -r webapp.service /opt/csye6225
cd /opt/csye6225

echo "logging files here"
ls
sleep 1m


echo "logging files before changing permissions"
ls 

mkdir /opt/csye6225
echo "+-------------------------------------------------------------+"
echo "|                    Setup csye6225 group                     |"
echo "+-------------------------------------------------------------+"
sudo groupadd csye6225
sudo useradd -s /usr/sbin/nologin -g csye6225 -d /opt/csye6225 -m csye6225

echo "after changing permissions"

ls

echo "Check webapp-new in the  directory"
ls
ls -ld /opt/csye6225
sudo chmod -R 777 /opt/csye6225


echo "Check if the webapp-new exists"
ls 

echo "+-------------------------------------------------------------+"
echo "|                    Install Node Modules                     |"
echo "+-------------------------------------------------------------+"
echo "install node modules"
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

sudo cp webapp.service /lib/systemd/system

echo "+-------------------------------------------------------------+"
echo "|                    Setup new user permissions               |"
echo "+-------------------------------------------------------------+"
echo "Get the home directory of the user"
echo ~csye6225
echo "Display permissions of user directory"
ls -la /opt/csye6225

echo "Change permissions of webapp-new"
sudo chown -R csye6225:csye6225 /opt/csye6225/
sudo chmod -R 777 /opt/csye6225/

echo "Display permissions of user directory after changes"
ls -la /opt/csye6225

echo "+-------------------------------------------------------------+"
echo "|                    Setup Systemd                            |"
echo "+-------------------------------------------------------------+"


sudo systemctl start webapp.service
sudo systemctl status webapp.service
sudo systemctl enable webapp.service
sleep 
