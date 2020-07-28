#!/bin/bash -x

set -e

echo "####################### Components: $(basename $0) ###########################"

echo ">>>> Who am i: `whoami` ; UID=`id -u` ; GID=`id -g`"

PRODUCT=SoapUI
PRODUCT_VERSION=5.4.0
PRODUCT_TAR_URL=https://s3.amazonaws.com/downloads.eviware/soapuios/${PRODUCT_VERSION}/SoapUI-${PRODUCT_VERSION}-linux-bin.tar.gz

INSTALL_DIR=${HOME}/tools
PRODUCT_HOME=${INSTALL_DIR}/SoapUI-${PRODUCT_VERSION}
PRODUCT_EXE=${PRODUCT_HOME}/bin/soapui.sh
PRODUCT_WORKSPACE=${HOME}/Projects/${PRODUCT}
PRODUCT_LOG=${PRODUCT_WORKSPACE}/logs/${PRODUCT}.log

ACTION=$1
if [ ! -s ${PRODUCT_HOME}/${PRODUCT}.installed ] || [ ! -s ${PRODUCT_EXE} ] ; then
    mkdir -p ${INSTALL_DIR} ${PRODUCT_HOME};
    cd ${PRODUCT_HOME}

    #####################################################################
    #### ---- (BEGIN): Application installation specific here: ---- #####

    cd ${INSTALL_DIR}
    
    # https://s3.amazonaws.com/downloads.eviware/soapuios/5.4.0/SoapUI-5.4.0-linux-bin.tar.gz
    wget --quiet --no-check-certificate -c ${PRODUCT_TAR_URL}
    tar xvf $(basename ${PRODUCT_TAR_URL})
    rm $(basename ${PRODUCT_TAR_URL})
    
    #### ---- (END): Application installation specific above:  ---- #####
    #####################################################################
    
    #### ---- Installation marked done if successfully done: ----
    if [ -s ${PRODUCT_EXE} ] ; then
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
    if [ "x${PID_EXE}" != "x" ]; then
        echo "... App Component ${PRODUCT} is already existing and running as PID=${PID_EXE}"
        echo "... Skip request to run! ..."
        exit 0
    fi
}
isAppRunning

export SOAPUI_HOME=${PRODUCT_HOME}

echo "... Preparing to start application ..."
mkdir -p $(dirname ${PRODUCT_LOG}) ${PRODUCT_WORKSPACE}
cd ${PRODUCT_WORKSPACE}

echo "... Starting application ..."

if [ -s  ${PRODUCT_EXE} ]; then
    nohup ${PRODUCT_EXE} . 2>&1 > ${PRODUCT_LOG} &
else
    echo "*** ERROR: Can't find ${PRODCUT_EXE}! Abort! ***"
fi

