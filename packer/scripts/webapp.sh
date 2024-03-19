#!/bin/bash
echo "sudo yum update -y"

# Installing ops tools for compute instance 

curl -sSO https://dl.google.com/cloudagents/add-monitoring-agent-repo.sh
sudo bash add-monitoring-agent-repo.sh --also-install
sudo yum install -y stackdriver-agent
sudo systemctl start stackdriver-agent
sudo systemctl enable stackdriver-agent

sudo touch /var/log/webappLogger.log
ls -l /var/log

sudo mkdir -p /etc/google-fluentd/config.d/
sudo tee -a /etc/google-fluentd/config.d/webapp-logs.conf <<EOF
<source>
    @type tail
    format none
    path /var/log/webappLogger.log
    pos_file /var/lib/google-fluentd/pos/webappLogger.pos
    read_from_head true
    tag webappLogger
    <parse>
        @type none
    </parse>
</source>
EOF


# sudo yum install -y postgresql-server
# sudo postgresql-setup initdb
sudo systemctl enable postgresql
sudo systemctl start postgresql
# sudo -u postgres psql -U postgres -c "CREATE USER abhaydeshpande WITH PASSWORD 'abhaydeshpande';"
# sudo -u postgres psql -U postgres -c "CREATE DATABASE cloudusers;"
# sudo -u postgres psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE cloudusers to abhaydeshpande;"

echo "Node.js and npm Installation"
curl -fsSL https://rpm.nodesource.com/setup_16.x | sudo bash -
sudo yum install -y nodejs

echo "Node.js and npm Versions"
node -v
npm -v


# Install unzip
sudo yum install -y unzip

# Check if the directory /opt/csye6225/ exists, if not, create it
if [ ! -d "/opt/csye6225/" ]; then
    sudo mkdir -p /opt/csye6225/
fi
# Move webapp.zip and install node modules
sudo mv /tmp/webapp-new.zip /opt/csye6225/
cd /opt/csye6225/ || exit
sudo unzip webapp-new.zip
sudo rm webapp-new.zip
# Create new group and user if they don't exist
sudo groupadd -f csye6225
sudo useradd -s /usr/sbin/nologin -g csye6225 -d /opt/csye6225 -m csye6225
echo "USER CREATED SUCCESFULLY"

# Change ownership of /opt/csye6225/
sudo chown -R csye6225:csye6225 /opt/csye6225/
sudo chmod -R 775 /opt/csye6225/

echo "after changing permissions"

ls

echo "Check webapp-new in the  directory"
ls
ls -ld /opt/csye6225
sudo chmod -R 777 /opt/csye6225


echo "Check if the webapp-new exists"
ls 

# Create log file
sudo touch /var/log/csye6225.log
sudo chown csye6225:csye6225 /var/log/csye6225.log
sudo chmod 750 /var/log/csye6225.log

# Install unzip
#!/bin/bash
# Install node modules
cd /opt/csye6225
echo "listing contents"
ls
cd /opt/csye6225|| exit
sudo npm install

# Copy systemd service file
sudo cp /tmp/webapp.service /etc/systemd/system/

# Final permission changes
sudo chown csye6225:csye6225 /etc/systemd/system/webapp.service
sudo chmod 750 /etc/systemd/system/webapp.service
sudo chown -R csye6225:csye6225 /opt/csye6225/
sudo chmod -R 750 /opt/csye6225

# Reload systemd
sudo systemctl daemon-reload



# Enable and start the service
sudo systemctl enable webapp
sudo systemctl start webapp
sudo systemctl status webapp

# Install rsyslog for audit logs
sudo yum install -y rsyslog
sudo systemctl daemon-reload
