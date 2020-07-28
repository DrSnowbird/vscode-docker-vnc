#!/bin/bash -x

set -e

echo "####################### Components: $(basename $0) ###########################"
echo ">>>> Who am i: `whoami` ; UID=`id -u` ; GID=`id -g`"

PRODUCT=postman
PRODUCT_EXE=/usr/bin/postman

INSTALL_DIR=${HOME}/tools
PRODUCT_HOME=${INSTALL_DIR}/${PRODUCT}
PRODUCT_WORKSPACE=${HOME}/Projects/${PRODUCT}
PRODUCT_LOG=${PRODUCT_WORKSPACE}/logs/${PRODUCT}.log

ACTION=$1
if [ ! -s ${PRODUCT_HOME}/${PRODUCT}.installed ] || [ ! -s ${PRODUCT_EXE} ]; then
    mkdir -p ${INSTALL_DIR} ${PRODUCT_HOME};
    cd ${PRODUCT_HOME}

    #####################################################################
    #### ---- (BEGIN): Application installation specific here: ---- #####
    
    wget --quiet --no-check-certificate -c https://dl.pstmn.io/download/latest/linux64 -O postman.tar.gz
    sudo tar -xzf postman.tar.gz -C ${INSTALL_DIR}
    rm postman.tar.gz
    sudo ln -s ${INSTALL_DIR}/Postman/Postman ${PRODUCT_EXE}

    #### Unity desktop for Postman Launcher ####
    mkdir -p ~/.local/share/applications/
    cat > ~/.local/share/applications/postman.desktop <<-EOL
[Desktop Entry]
Encoding=UTF-8
Name=Postman
Exec=postman
Icon=${INSTALL_DIR}/Postman/app/resources/app/assets/icon.png
Terminal=false
Type=Application
Categories=Development;
EOL

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
    echo "`ps aux|grep -i ${1:-${PRODUCT_EXE}} | grep -v grep`"
    PID_EXE="`ps aux|grep -i ${1:-${PRODUCT_EXE}} | grep -v grep | awk '{print $2}'`"
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
if [ -s  ${PRODUCT_EXE} ]; then
    nohup ${PRODUCT_EXE} 2>&1 > ${PRODUCT_LOG} &
else
    echo "*** ERROR: Can't find ${PRODCUT_EXE}! Abort! ***"
fi

