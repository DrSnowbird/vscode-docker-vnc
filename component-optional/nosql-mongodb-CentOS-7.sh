#!/bin/bash -x

echo "####################### Components: $(basename $0) ###########################"

echo ">>>> Who am i: `whoami` ; UID=`id -u` ; GID=`id -g`"

MONGODB_VERSION=4.0

if [ ! -s /usr/bin/mongod ]; then

    sudo yum install -y libcurl openssl

    #https://repo.mongodb.org/yum/redhat/7/mongodb-org/4.0/x86_64/RPMS/mongodb-org-server-4.0.5-1.el7.x86_64.rpm

    cat <<EOF | sudo tee -a /etc/yum.repos.d/mongodb-org-${MONGODB_VERSION}.repo
    [mongodb-org-${MONGODB_VERSION}] 
    name=MongoDB Repository
    baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/${MONGODB_VERSION}/x86_64/
    gpgcheck=1
    enabled=1
    gpgkey=https://www.mongodb.org/static/pgp/server-${MONGODB_VERSION}.asc
    EOF

    sudo yum install -y mongodb-org

fi

#### Prepare to start Mongodb ####
MONGODB_DIR=$HOME/mongodb
mkdir -p $HOME/mongodb
nohup mongod --dbpath ${MONGODB_DIR) 2>&1 > $HOME/logs/$(basename $0).log &

## not work inside Docker Container: Use the above steps
sudo service mongod start
sudo service mongod enabled
