#!/bin/bash

echo "####################### Main Process: $(basename $0) ###########################"

env

printenv

echo ">>>> Who am i: `whoami` ; UID=`id -u` ; GID=`id -g`"

source $HOME/.bashrc

############################################################################
# -- usage (generic pattern / template for components "install" or "run": --
#  vs-code-server.sh             
#      [ -s|--server : (default) Install Server or not 
#      [ -d|--desktop : Install desktop or not 
#          (either VS Code or Code-Server; -s and -d are mutual exclusive) ] 
#      [ -a|--action : {install, run}] : default=install     
#      [ -t|--install-type : {              
#          generic : (*.tar.gz),            
#          package : (*.deb, or *.rpm),     
#          distribution : (auto-detect OS to install) } : default=generic ]
############################################################################
#
function run_components() {
    if [ ! -s "${SCRIPT_DIR}/components.list" ]; then
         echo "*** ERROR ***: Can't find ${SCRIPT_DIR}/components.list to continue!"
         exit 1
    fi
    echo ">>>> Active Components / tools in folder ${COMPONENT_DIR}:"
    ACTION="run"
    for active in `cat ${SCRIPT_DIR}/components.list | grep -v '^#'`; do
        comp=${COMPONENT_DIR}/$(basename $active)
        if [ -s ${comp} ]; then
            ${comp} -a ${ACTION}
        else
            echo -e "**** ERROR: ${comp}: NOT Found!"
        fi
    done
}
#run_components


tail -f /dev/null
