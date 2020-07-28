#!/bin/bash -x

echo "####################### Components: $(basename $0) ###########################"

echo ">>>> Who am i: `whoami` ; UID=`id -u` ; GID=`id -g`"

# Ref: 
# - https://github.com/DrSnowbird/rest
# - https://github.com/diegohaz/rest

INSTALL_DIR=${HOME}/tools
PRODUCT=$(basename $0)
PRODUCT=${PRODUCT%%.sh}
PRODUCT_HOME=${INSTALL_DIR}/${PRODUCT}
WORKSPACE=${HOME}/Projects/${PRODUCT}

ACTION=${1:-install}
if [ "$ACTION" = "install" ] && [ ! -s ${PRODUCT_HOME}/${PRODUCT}.installed ]; then
    mkdir -p $HOME/samples
    cd $HOME/samples
    sudo chown -R $USER:$(id -gn $USER) $HOME/.config
    mkdir restful
    cd restful/
    npm install -g yo generator-rest eslint
    
    echo "... Installed before already! ..."
    touch $HOME/$(basename $0).installed
    exit 0
fi

echo "... use yo to generate your project."
mkdir my-rest-api
cd my-rest-api/
yo rest


