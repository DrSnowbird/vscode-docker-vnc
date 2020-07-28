#!/bin/bash -x

set -e

echo "####################### Components: $(basename $0) ###########################"

echo ">>>> Who am i: `whoami` ; UID=`id -u` ; GID=`id -g`"

INSTALL_DIR=${HOME}/tools

PRODUCT=json-editor
PRODUCT_HOME=${INSTALL_DIR}/${PRODUCT}
PRODUCT_WORKSPACE=${HOME}/Projects/${PRODUCT}
PRODUCT_LOG=${PRODUCT_WORKSPACE}/logs/${PRODUCT}.log

PRODUCT_TAR_URL=https://github.com/DrSnowbird/json-editor/archive/master.zip

ACTION=$1
if [ ! -s ${PRODUCT_HOME}/${PRODUCT}.installed ] || [ ! -s ${PRODUCT_HOME}/package.json ] ; then
    mkdir -p ${INSTALL_DIR} ${PRODUCT_HOME};
    cd ${PRODUCT_HOME}

    #####################################################################
    #### ---- (BEGIN): Application installation specific here: ---- #####

    sudo chown -R $USER:$(id -gn $USER) /home/developer/.config
    cd ${INSTALL_DIR}
    git clone https://github.com/DrSnowbird/json-editor.git
    cd json-editor
    npm install
    
    #### ---- (END): Application installation specific above:  ---- #####
    #####################################################################

    #### ---- Installation marked done if successfully done: ----
    if [ -s ${PRODUCT_HOME}/package.json ]; then
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

echo "... Preparing to start application ..."
mkdir -p $(dirname ${PRODUCT_LOG}) ${PRODUCT_WORKSPACE}
cd ${PRODUCT_WORKSPACE}

nohup /usr/bin/firefox ${PRODUCT_HOME}/docs/demo.html 2>&1 > ${PRODUCT_LOG} &

