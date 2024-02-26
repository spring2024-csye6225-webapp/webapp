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
sudo mkdir -p /opt/csye6225/webapp-new
sleep 1m
sudo unzip -q /tmp/webapp-new.zip -d /opt/csye6225/webapp-new/
if [ $? -ne 0 ]; then
    echo "Error: Failed to unzip webapp-new.zip"
    exit 1
fi

# Change directory to the newly created folder and install dependencies
sudo cd /opt
ls
sudo cd /csye6225
ls
sudo cd webapp-new

# Move the webapp.service file to systemd directory
sudo mv /packer/scripts/webapp.service /etc/systemd/system/webapp.service

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
sudo systemctl daemon-reload
sudo systemctl start webapp.service
sudo systemctl status webapp.service
sudo systemctl enable webapp.service
