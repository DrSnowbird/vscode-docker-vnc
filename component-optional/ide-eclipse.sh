#!/bin/bash -x

echo "####################### Components: $(basename $0) ###########################"

PRODUCT_VERSION=photon
PRODUCT_EXE=/opt/eclipse/eclipse
WORKSPACE=${HOME}/eclipse-workspace
INSTALL_DIR=${HOME}/tools

## ----------------------------------------------------------------------------
## ---- To change to different Eclipse version: e.g., oxygen, change here! ----
## ----------------------------------------------------------------------------

## -- 1.) Eclipse version: oxygen, photon, etc.: -- ##
ECLIPSE_VERSION=${ECLIPSE_VERSION:-photon}

## -- 2.) Eclipse Type: -- ##
ECLIPSE_TYPE=${ECLIPSE_TYPE:-jee}
#ECLIPSE_TYPE=${ECLIPSE_TYPE:-modeling}

## -- 3.) Eclipse Release: -- ##
ECLIPSE_RELEASE=${ECLIPSE_RELEASE:-R}
#ECLIPSE_RELEASE=${ECLIPSE_RELEASE:-2}

## -- 4.) Eclipse Download Mirror site: -- ##
#ECLIPSE_OS_BUILD=${ECLIPSE_OS_BUILD:-win32-x86_64}
ECLIPSE_OS_BUILD=${ECLIPSE_OS_BUILD:-linux-gtk-x86_64}

## -- 5.) Eclipse Download Mirror site: -- ##
#http://mirror.math.princeton.edu/pub/eclipse/technology/epp/downloads/release/photon/R/eclipse-jee-photon-R-linux-gtk-x86_64.tar.gz
#http://mirror.math.princeton.edu/pub/eclipse/technology/epp/downloads/release/photon/R/eclipse-modeling-photon-R-linux-gtk-x86_64.tar.gz
ECLIPSE_MIRROR_SITE_URL=${ECLIPSE_MIRROR_SITE_URL:-http://mirror.math.princeton.edu}

## ----------------------------------------------------------------------------------- ##
## ----------------------------------------------------------------------------------- ##
## ----------- Don't change below unless Eclipse download system change -------------- ##
## ----------------------------------------------------------------------------------- ##
## ----------------------------------------------------------------------------------- ##
## -- Eclipse TAR/GZ filename: -- ##
#ECLIPSE_TAR=${ECLIPSE_TAR:-eclipse-jee-photon-R-linux-gtk-x86_64.tar.gz}
ECLIPSE_TAR=${ECLIPSE_TAR:-eclipse-${ECLIPSE_TYPE}-${ECLIPSE_VERSION}-${ECLIPSE_RELEASE}-${ECLIPSE_OS_BUILD}.tar.gz}

## -- Eclipse Download route: -- ##
ECLIPSE_DOWNLOAD_ROUTE=${ECLIPSE_DOWNLOAD_ROUTE:-pub/eclipse/technology/epp/downloads/release/${ECLIPSE_VERSION}/${ECLIPSE_RELEASE}}

## -- Eclipse Download full URL: -- ##
## e.g.: http://mirror.math.princeton.edu/pub/eclipse/technology/epp/downloads/release/photon/R/
## e.g.: http://mirror.math.princeton.edu/pub/eclipse/technology/epp/downloads/release/photon/R/
ECLIPSE_DOWNLOAD_URL=${ECLIPSE_DOWNLOAD_URL:-${ECLIPSE_MIRROR_SITE_URL}/${ECLIPSE_DOWNLOAD_ROUTE}}

## http://ftp.osuosl.org/pub/eclipse/technology/epp/downloads/release/photon/R/eclipse-jee-photon-R-linux-gtk-x86_64.tar.gz
## http://mirror.math.princeton.edu/pub/eclipse/technology/epp/downloads/release/photon/R/eclipse-jee-photon-R-linux-gtk-x86_64.tar.gz
## http://mirror.math.princeton.edu/pub/eclipse/technology/epp/downloads/release/photon/R/eclipse-modeling-photon-R-linux-gtk-x86_64.tar.gz
cd ${HOME};
mkdir -p ${INSTALL_DIR} ${WORKSPACE}
wget -c ${ECLIPSE_DOWNLOAD_URL}/${ECLIPSE_TAR} && tar xvf ${ECLIPSE_TAR} && rm ${ECLIPSE_TAR} 

#################################
#### Install Eclipse Plugins ####
#################################
# ... add Eclipse plugin - installation here (see example in https://github.com/DrSnowbird/papyrus-sysml-docker)

sudo apt-get update -y && sudo apt-get install -y libwebkitgtk-3.0-0

##################################
#### Start up Application ####
##################################

cd ${WORKSPACE}

nohup /bin/bash -c "${PRODUCT_EXE} ${WORKSPACE}" 2>&1 >> /dev/null &

