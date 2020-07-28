#!/bin/bash -x

set -e

echo "####################### Components: $(basename $0) ###########################"
echo ">>>> Who am i: `whoami` ; UID=`id -u` ; GID=`id -g`"

#### RAML API Workbench ####
PRODUCT_VERSION="RAML 1.0"

PRODUCT=api-designer
PRODUCT_EXE=api-designer
# /home/developer/.nvm/versions/node/v11.9.0/bin/api-designer

INSTALL_DIR=${HOME}/tools
PRODUCT_HOME=${INSTALL_DIR}/${PRODUCT}
PRODUCT_WORKSPACE=${HOME}/Projects/${PRODUCT}
PRODUCT_LOG=${PRODUCT_WORKSPACE}/logs/${PRODUCT}.log

ACTION=$1
if [ ! -s ${PRODUCT_HOME}/${PRODUCT}.installed ] || [ ! -s "${PRODUCT_HOME}/package.json" ] ; then
    mkdir -p ${INSTALL_DIR} ${PRODUCT_HOME};
    cd ${PRODUCT_HOME}

    #####################################################################
    #### ---- (BEGIN): Application installation specific here: ---- #####
    cd ${INSTALL_DIR}

    # ref: https://github.com/mulesoft/api-designer
    sudo chown -R $(whoami):$(whoami) /usr/lib/node_modules ${HOME}/.npm
    if [ ! -s ${PRODUCT_HOME}/package.json ]; then
        rm -rf ${PRODUCT_HOME}
        git clone https://github.com/mulesoft/api-designer.git
        cd api-designer
        npm install
    
        cd ${INSTALL_DIR}
        npm install -g request
        echo "PRODUCT_EXE at: `which $(basename ${PRODUCT_EXE})`"
    fi
    
    #### ---- (END): Application installation specific above:  ---- #####
    #####################################################################

    #### ---- Installation marked done if successfully done: ----
    if [ -s "`which $(basename ${PRODUCT_EXE})`" ]; then
        #### ---- Installation marked done: ----
        echo "... Installed completed! ..." > ${PRODUCT_HOME}/${PRODUCT}.installed
    else
        echo "... Instllation failed!!! ..."
        rm -f ${PRODUCT_HOME}/${PRODUCT}.installed
        exit 999
    fi

fi

if [ "$ACTION" = "install" ]; then
    exit 0
fi

echo " ... Check Application already running or not: ..."
PID_EXE=""
IS_RUNNING=0
function isAppRunning() {
    #PID_EXE="`ps aux|grep api-designer | grep node | grep -v grep | awk '{print $2}'`"
    PID_EXE="`ps aux | grep -i ${1:-${PRODUCT_EXE}} | grep node | grep -v grep | awk '{print $2}'`"
    if [ "x${PID_EXE}" != "x" ]; then
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
PRODUCT_EXE=`which ${PRODUCT_EXE}`
if [ -s  ${PRODUCT_EXE} ]; then
    #nohup `which ${PRODUCT_EXE}` 2>&1 > ${PRODUCT_LOG} &
    nohup ${PRODUCT_EXE} . 2>&1 > ${PRODUCT_LOG} &
    # firefox http://localhost:3000/
    chrome http://localhost:3000/
else
    echo "*** ERROR: Can't find ${PRODCUT_EXE}! Abort! ***"
fi

