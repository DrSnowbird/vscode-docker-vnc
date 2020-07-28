#!/bin/bash -x

echo "####################### Components: $(basename $0) ###########################"

echo ">>>> Who am i: `whoami` ; UID=`id -u` ; GID=`id -g`"

MONGODB_VERSION=4.0

INSTALL_DIR=${HOME}/tools
PRODUCT=nosql-mongodb
PRODUCT_HOME=${INSTALL_DIR}/${PRODUCT}
PRODUCT_EXE=/usr/bin/mongod
WORKSPACE=${HOME}/Projects/${PRODUCT}

ACTION=$1
if [ ! -s ${PRODUCT_HOME}/${PRODUCT}.installed ] || [ ! -s ${PRODUCT_EXE} ]; then
    mkdir -p ${INSTALL_DIR} ${PRODUCT_HOME};
    cd ${PRODUCT_HOME}

    #####################################################################
    #### ---- (BEGIN): Application installation specific here: ---- #####
    
z   sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
    echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/${MONGODB_VERSION} multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-${MONGODB_VERSION}.list
    sudo apt-get update -y
    sudo apt-get install -y mongodb-org
    #echo "mongodb-org hold" | sudo dpkg --set-selections
    #echo "mongodb-org-server hold" | sudo dpkg --set-selections
    #echo "mongodb-org-shell hold" | sudo dpkg --set-selections
    #echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
    #echo "mongodb-org-tools hold" | sudo dpkg --set-selections
    
    #### ---- (END): Application installation specific above:  ---- #####
    #####################################################################

    #### ---- Installation marked done if successfully done: ----
    if [ -s ${PRODUCT_EXE} ]; then
        #### ---- Installation marked done: ----
        echo "... Installed completed! ..." > ${PRODUCT_HOME}/${PRODUCT}.installed
    else
        echo "... Instllation failed!!! ..."
        rm -f ${PRODUCT_HOME}/${PRODUCT}.installed
    fi

fi

if [ "$ACTION" = "install" ]; then
    exit 0
fi

echo " ... Check Application already running or not: ..."
PID_EXE=""
function isAppRunning() {
    PID_EXE="`ps aux|grep -i ${1:-${PRODUCT_EXE}} | grep -v grep | awk '{print $2}'`"
    if [ "${PID_EXE}" != "" -o ${PID_EXE} -gt 0 ]; then
        echo "... App Component ${PRODUCT} is already existing and running as PID=${PID_EXE}"
        echo "... Skip request to run! ..."
        exit 0
    fi
}
isAppRunning $(basename ${PRODUCT_EXE})

#### Prepare to start Mongodb ####
MONGODB_DIR=$HOME/mongodb
mkdir -p $HOME/mongodb

echo "... Preparing to start application ..."
mkdir -p $(dirname ${PRODUCT_LOG}) ${PRODUCT_WORKSPACE}
cd ${PRODUCT_WORKSPACE}

echo "... Starting application ..."
#PRODUCT_EXE=`which ${PRODUCT_EXE}`
PRODUCT_EXE=`which $(basename ${PRODUCT_EXE})`
if [ -s  ${PRODUCT_EXE} ]; then
    nohup mongod --dbpath ${MONGODB_DIR} 2>&1 > ${PRODUCT_LOG} &
else
    echo "*** ERROR: Can't find ${PRODCUT_EXE}! Abort! ***"
fi

## not work inside Docker Container: Use the above steps
#sudo service mongod start
#sudo service mongod enabled
