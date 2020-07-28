#!/bin/bash 

set -e

echo "####################### Components: $(basename $0) ###########################"
echo ">>>> Who am i: `whoami` ; UID=`id -u` ; GID=`id -g`"

PRODUCT=code-server
PRODUCT_EXE=/usr/bin/atom

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
    
    PRODUCT_VERSION=1.34.0
    
    wget --quiet --no-check-certificate -c https://github.com/atom/atom/releases/download/v${PRODUCT_VERSION}/atom-amd64.deb
    sudo apt-get install -y ./atom-amd64.deb
    rm -f ./atom-amd64.deb
    
    ## -- Atom API Workbench -- ##
    ## Ref: http://apiworkbench.com/
    apm install api-workbench
    
    #### ---- (END): Application installation specific above:  ---- #####
    #####################################################################

    #### ---- Installation marked done if successfully done: ----
    if [ -s ${PRODUCT_EXE} ]; then
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
function isAppRunning() {
    PID_EXE="`ps aux|grep -i ${1:-${PRODUCT_EXE}} | grep -v grep | awk '{print $2}'`"
    if [ "${PID_EXE}" != "" -o ${PID_EXE} -gt 0 ]; then
        echo "... App Component ${PRODUCT} is already existing and running as PID=${PID_EXE}"
        echo "... Skip request to run! ..."
        exit 0
    fi
}
isAppRunning $(basename ${PRODUCT_EXE})

echo "... Preparing to start application ..."
mkdir -p $(dirname ${PRODUCT_LOG}) ${PRODUCT_WORKSPACE}
cd ${PRODUCT_WORKSPACE}

echo "... Starting application ..."
#PRODUCT_EXE=`which ${PRODUCT_EXE}`
PRODUCT_EXE=`which $(basename ${PRODUCT_EXE})`
if [ -s  ${PRODUCT_EXE} ]; then
    nohup ${PRODUCT_EXE} . 2>&1 > ${PRODUCT_LOG} &
else
    echo "*** ERROR: Can't find ${PRODCUT_EXE}! Abort! ***"
fi

