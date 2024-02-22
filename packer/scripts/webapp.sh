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

echo "Unzip the zip folder"
sudo unzip -o /tmp/webapp-new.zip -d /opt/csye6225

echo "+-------------------------------------------------------------+"
echo "|                    Setup csye6225 group                     |"
echo "+-------------------------------------------------------------+"
sudo groupadd csye6225
sudo useradd -s /usr/sbin/nologin -g csye6225 -d /opt/csye6225 -m csye6225

echo "+-------------------------------------------------------------+"
echo "|                    Changing Permissions                     |"
echo "+-------------------------------------------------------------+"

echo "+-------------------------------------------------------------+"
echo "|                    Install Node Modules                     |"
echo "+-------------------------------------------------------------+"
echo "Change directory to /opt/csye6225/webapp-new to install node modules"
cd /opt/csye6225/webapp-new
sudo npm install

echo "+-------------------------------------------------------------+"
echo "|                    Setup webapp.service                     |"
echo "+-------------------------------------------------------------+"
echo "Copy webapp.service to /etc/systemd/system"
sudo cp /opt/csye6225/webapp-new/packer/scripts/webapp.service /etc/systemd/system/webapp.service

echo "+-------------------------------------------------------------+"
echo "|                    Setup Systemd                            |"
echo "+-------------------------------------------------------------+"
sudo systemctl start webapp.service
sudo systemctl status webapp.service
sudo systemctl enable webapp.service
