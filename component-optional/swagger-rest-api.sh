#!/bin/bash

echo "####################### Components: $(basename $0) ###########################"

echo ">>>> Who am i: `whoami` ; UID=`id -u` ; GID=`id -g`"

#### Swagger-based REST API / NPM ####
# Ref: https://www.npmjs.com/package/swagger

ACTION=${1:-install}
if [ "$ACTION" = "install" ] && [ ! -s $HOME/$(basename $0).installed ]; then
    npm install -g swagger
    npm install -g swagger-editor-dist
    
    echo "... Installed before already! ..."
    touch $HOME/$(basename $0).installed
    exit 0
fi

WORKSPACE=${HOME}/Projects/swagger-projects

echo "... creating hello-world sample project:"
if [ ! -d ${WORKSPACE} ]; then

    mkdir -p ${WORKSPACE}; cd ${WORKSPACE}

    swagger project create hello-world

    echo "... Once it is done ..."
    echo "    You will see:"
    echo "      Success! You may start your new app by running: ..."
    echo ">> To Run: 'hello-world' sample project ...."
    echo "      swagger project start hello-world"

else
    cd ${WORKSPACE}
    echo "... hello-world project already being created before!"
    echo 
    echo ">> To Run again: 'hello-world' sample project ...."
    echo "      swagger project start hello-world"
    swagger project start hello-world
fi

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

