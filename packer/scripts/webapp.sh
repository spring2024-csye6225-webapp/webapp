#!/bin/bash

echo "sudo yum update -y"

# Install PostgreSQL and set it up
sudo yum install -y postgresql-server
sudo postgresql-setup initdb
sudo systemctl enable postgresql
sudo systemctl start postgresql
sudo -u postgres psql -U postgres -c "CREATE USER abhaydeshpande WITH PASSWORD 'abhaydeshpande';"
sudo -u postgres psql -U postgres -c "CREATE DATABASE cloudusers;"
sudo -u postgres psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE cloudusers to abhaydeshpande;"

# Update PostgreSQL configuration to use password authentication
sudo sed -i 's/host    all             all             127.0.0.1\/32            ident/host    all             all             127.0.0.1\/32            password/g' /var/lib/pgsql/data/pg_hba.conf
sudo sed -i 's/host    all             all             ::1\/128                 ident/host    all             all             ::1\/128                 password/g' /var/lib/pgsql/data/pg_hba.conf

# Install Node.js
sudo yum install -y gcc-c++ make
curl -sL https://rpm.nodesource.com/setup_16.x | sudo -E bash -
sudo yum install -y nodejs
node -v

# Check the contents of /tmp
ls -la /tmp
sudo yum install unzip -y

# Extract the zip file
cd /tmp && unzip -q webapp-new.zip
if [ $? -ne 0 ]; then
    echo "Error: Failed to unzip webapp-new.zip"
    exit 1
fi

# Move the extracted contents to a new folder named webapp-new
cd /tmp
sudo mkdir -p /opt/csye6225/
sudo mv /tmp/* /opt/csye6225/

# Change directory to the newly created folder
cd /opt/csye6225/ && npm install

# Move files to desired locations
sudo mv /opt/csye6225/packer/scripts/webapp.service /etc/systemd/system/webapp.service

# Set up user and permissions
echo "+-------------------------------------------------------------+"
echo "|                    Setup csye6225 group                     |"
echo "+-------------------------------------------------------------+"
sudo groupadd csye6225
sudo useradd -s /usr/sbin/nologin -g csye6225 -d /opt/csye6225 -m csye6225

echo "+-------------------------------------------------------------+"
echo "|                    Changing Permissions                     |"
echo "+-------------------------------------------------------------+"

# Start and enable the webapp service
sudo systemctl start webapp.service
sudo systemctl status webapp.service
sudo systemctl enable webapp.service
sleep 30m
