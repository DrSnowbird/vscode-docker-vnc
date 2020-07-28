#!/bin/bash

echo "####################### Components: $(basename $0) ###########################"

echo ">>>> Who am i: `whoami` ; UID=`id -u` ; GID=`id -g`"

#### Swagger-based REST API Editor ####
PRODUCT=swagger-editor
PRODUCT_EXE=/usr/bin/swagger-editor

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
    sudo chown -R $(whoami):$(whoami) /usr/lib/node_modules ${HOME}/.npm
    #wget --quiet --no-check-certificate -c https://github.com/swagger-api/swagger-editor/archive/master.zip
    #unzip master.zip; mv ${PRODUCT_HOME}-master ${PRODUCT_HOME}
    #npm install -g http-server
    git clone https://github.com/swagger-api/swagger-editor.git
    cd swagger-editor
    CI=true npm install
    #### ---- (END): Application installation specific above:  ---- #####
    #####################################################################

    #### ---- Installation marked done if successfully done: ----
    if [ -s "${PRODUCT_HOME}/package.json" ]; then
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
    PID_EXE="`ps aux|grep -i ${1:-${PRODUCT_EXE}} |grep http-server | grep -v grep | awk '{print $2}'`"
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
WAY_CHOICE=1
cd ${PRODUCT_HOME}
export DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket
if [ -s "${PRODUCT_HOME}/package.json" ]; then
    if [ ${WAY_CHOICE} -eq 1 ]; then
        # Way-1: Using NPM Server
        nohup npm start 2>&1 > ${PRODUCT_LOG} &
        echo "Swagger Editor: http://localhost:3001/"
        # (not needed for launch another chromium since npm above will auto-launch one for you!)
        #firefox http://localhost:3001/ &
	`which google-chrome` --no-sandbox http://localhost:3001/ &
    else
        # Way-2: Using http-server to host swagger-editor
        nohup http-server swagger-editor &
        #firefox http://localhost:8080/ &
	`which google-chrome` --no-sandbox http://localhost:8080/ &
    fi
else
    echo "*** ERROR: Can't find ${PRODCUT_EXE}! Abort! ***"
fi

echo
echo ">>> ---------------------------------------------------------------------------------------"
echo ">>> If you need standalone/individual docker stack for swagger,"
echo ">>>    https://github.com/DrSnowbird/swagger-all-in-one-docker-compose."
echo ">>>    0.) Go to your host VM or OS and then open a terminal / xterm"
echo ">>>    1.) git clone https://github.com/DrSnowbird/swagger-all-in-one-docker-compose"
echo ">>>    2.) cd swagger-all-in-one-docker-compose"
echo ">>>    3.) docker-compose up -d"
echo ">>>    4.) ... It will spin up the swagger all-in-one common 7 tools for REST API development,"
echo ">>>               including Mongodb too!"
echo ">>>    5.) ... Enjoy it also if you use that full stack!"
echo ">>> ---------------------------------------------------------------------------------------"
echo
