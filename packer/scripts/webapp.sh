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

echo "Unzipping the zip folder"
sudo unzip -o /tmp/webapp-new.zip -d /tmp/

sleep 1m

echo "Unzipping completed"
ls
echo "Copy webapp-new.zip to user home directory"
sudo cp -r /tmp/webapp-new /opt/csye6225
sudo cp -r /tmp/webapp-new/packer/scripts/webapp.service /etc/systemd/system/webapp.service
echo "printing current directory"
pwd

echo "listing current directory items"
ls

echo "+-------------------------------------------------------------+"
echo "|                    Setup csye6225 group                     |"
echo "+-------------------------------------------------------------+"
sudo groupadd csye6225
sudo useradd -s /usr/sbin/nologin -g csye6225 -d /opt/csye6225 -m csye6225

echo "+-------------------------------------------------------------+"
echo "|                    Setup new user permissions               |"
echo "+-------------------------------------------------------------+"
echo "Change permissions of webapp-new"
sudo chown -R csye6225:csye6225 /opt/csye6225/
sudo chmod -R 777 /opt/csye6225/

echo " guess which directory I am in"
ls

cd /opt/csye6225

echo "current directory before npm install"
pwd

npm install


echo "+-------------------------------------------------------------+"
echo "|                    Setup Systemd                            |"
echo "+-------------------------------------------------------------+"
sudo systemctl start webapp.service
sudo systemctl status webapp.service
sudo systemctl enable webapp.service
sleep 30m