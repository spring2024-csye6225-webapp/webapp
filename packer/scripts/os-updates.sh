#!/bin/bash

echo "sudo yum update -y"

sudo yum install -y postgresql-server
sudo postgresql-setup initdb
sudo systemctl enable postgresql
sudo systemctl start postgresql

#!/bin/bash

echo "Creating PostgreSQL database and user"
sudo -u postgres psql -c "CREATE USER abhaydeshpande WITH PASSWORD 'abhaydeshpande';"
sudo -u postgres psql -c "CREATE DATABASE cloudusers;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE cloudusers to abhaydeshpande;"


echo "Node.js and npm Installation"
curl -fsSL https://rpm.nodesource.com/setup_16.x | sudo bash -
sudo yum install -y nodejs

echo "Node.js and npm Versions"
node -v
npm -v
