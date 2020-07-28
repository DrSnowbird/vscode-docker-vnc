#!/bin/bash

set -e

echo "####################### Components: $(basename $0) ###########################"
echo ">>>> Who am i: `whoami` ; UID=`id -u` ; GID=`id -g`"

PRODUCT=mongodb-compass
PRODUCT_EXE=/usr/bin/mongodb-compass

INSTALL_DIR=${HOME}/tools
PRODUCT_HOME=${INSTALL_DIR}/${PRODUCT}
PRODUCT_WORKSPACE=${HOME}/Projects/${PRODUCT}
PRODUCT_LOG=${PRODUCT_WORKSPACE}/logs/${PRODUCT}.log

ACTION=$1
if [ ! -s ${PRODUCT_HOME}/${PRODUCT}.installed ] || [ "`which $(basename ${PRODUCT_EXE})`" = "" ] ; then
    mkdir -p ${INSTALL_DIR} ${PRODUCT_HOME};
    cd ${PRODUCT_HOME}

    #####################################################################
    #### ---- (BEGIN): Application installation specific here: ---- #####

    PRODUCT_VERSION=1.16.3
    PRODUCT_URL=https://downloads.mongodb.com/compass/mongodb-compass_${PRODUCT_VERSION}_amd64.deb

    # https://downloads.mongodb.com/compass/mongodb-compass-community_1.16.3_amd64.deb
    #sudo wget https://downloads.mongodb.com/compass/mongodb-compass-community_1.16.3_amd64.deb
    wget --quiet -c --no-check-certificate ${PRODUCT_URL}

    sudo apt-get update -y 
    sudo apt-get install -y libsecret-1-0 libgconf-2-4 libnss3 
    sudo dpkg -i $(basename ${PRODUCT_URL});

    #### ---- Plugin for Compass ---- ####
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash 

    export NVM_DIR="$HOME/.nvm" 
    sudo chown -R ${USER}:${USER} ${HOME}/.nvm
    chmod +x .nvm/nvm.sh && $NVM_DIR/nvm.sh
    #nvm install stable && \
    #npm install -g khaos && \
    mkdir -p ${HOME}/.mongodb/${PRODUCT}-community/plugins

    #cd ${HOME}/.mongodb/${PRODUCT}-community/plugins && khaos create mongodb-js/compass-plugin ./${USER}-plugin && \
    #cd ${HOME}/.mongo/compass/plugins

    #
    # This loads nvm
    # [ -s "$NVM_DIR/nvm.sh" ] && /bin/bash -c "$NVM_DIR/nvm.sh" 
    
    #### ---- (END): Application installation specific above:  ---- #####
    #####################################################################
    
    #### ---- Installation marked done if successfully done: ----
    if [ ! "`which $(basename ${PRODUCT_EXE})`" = "" ] ; then
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
    if [ "${PID_EXE}" != "" ]; then
        echo "... App Component ${PRODUCT} is already existing and running as PID=${PID_EXE}"
        echo "... Skip request to run! ..."
        exit 0
    fi
}
isAppRunning

echo "... Preparing to start application ..."
mkdir -p $(dirname ${PRODUCT_LOG}) ${PRODUCT_WORKSPACE}
cd ${PRODUCT_WORKSPACE}

echo "... Starting application ..."
PRODUCT_EXE=`which $(basename ${PRODUCT_EXE})`
if [ -s  ${PRODUCT_EXE} ]; then
    nohup ${PRODUCT_EXE} . 2>&1 > ${PRODUCT_LOG} &
else
    echo "*** ERROR: Can't find ${PRODCUT_EXE}! Abort! ***"
fi

