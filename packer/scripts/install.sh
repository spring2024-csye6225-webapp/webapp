#!/bin/bash


sudo yum update -y
sudo yum install -y curl wget 

curl -sL https://rpm.nodesource.com/setup_20.x  | sudo bash - 
sudo npm install -y nodejs 


node -v 
npm  -v 


sudo yum install -y postgresql-server postgresql-contrib

sudo postgresql-setup cloudusers

sudo systemctl start postgresql 

sudo systemctl enable postgresql 

sudo -u postgres psql -c "CREATE USER abhaydeshpande WITH PASSWORD 'abhaydeshpande'; ";
sudo -u postgres psql -c "CREATE DATABASE cloudusers;"    
sudo -u postgres psql -c "GRANT ALL PREVILEGES ON cloudusers to abhaydeshpande;"


sudo useradd -g csye6225 -s /usr/sbin/nologin csye6225 

sudo cp ./webapp.service /etc/systemd/system/webapp.service

# Reload systemd to read the new service file
sudo systemctl daemon-reload

# Enable your systemd service to start on boot
sudo systemctl enable webapp

sudo systemctl start webapp