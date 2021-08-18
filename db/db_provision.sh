#!/bin/bash

sudo apt-get install gnupg

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv D68FA50FEA312927
echo "deb https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y mongodb-org=3.2.20 mongodb-org-server=3.2.20 mongodb-org-shell=3.2.20 mongodb-org-mongos=3.2.20 mongodb-org-tools=3.2.20 --allow-unauthenticated

curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - 
sudo apt-get install -y nodejs

# install pm2 package manager
npm install pm2 -g 

sudo apt-get install python-software-properties -y

cd /etc
sudo rm -rf mongod.conf # deletes config file for mongdb
# rewrites config file with 0.0.0.0 ip for ease of access
sudo echo "
storage:
  dbPath: /var/lib/mongodb
  journal:
    enabled: true
systemLog:
  destination: file
  logAppend: true
  path: /var/log/mongodb/mongod.log
net:
  port: 27017
  bindIp: 0.0.0.0
" >> mongod.conf

# restarts and enables with new config
sudo systemctl restart mongod
sudo systemctl enable mongod