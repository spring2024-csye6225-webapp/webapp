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

sudo yum install -y gcc-c++ make
curl -sL https://rpm.nodesource.com/setup_16.x | sudo -E bash -
sudo yum install -y nodejs
node -v

ls -la /tmp
sudo yum install unzip -y


cd /tmp && unzip webapp-new.zip

cd /tmp/webapp-new && npm install
npm run build


sudo mkdir /opt/csye6225/

sudo mv /tmp/webapp-new/packer/scripts/webapp.service /etc/systemd/system/webapp.service
sudo mv /tmp/webapp-new /opt/csye6225

echo "+-------------------------------------------------------------+"
echo "|                    Setup csye6225 group                     |"
echo "+-------------------------------------------------------------+"
sudo groupadd csye6225
sudo useradd -s /usr/sbin/nologin -g csye6225 -d /opt/csye6225 -m csye6225

echo "+-------------------------------------------------------------+"
echo "|                    Changing Permissions                     |"
echo "+-------------------------------------------------------------+"



sudo systemctl start webapp.service
sudo systemctl status webapp.service
sudo systemctl enable webapp.service
