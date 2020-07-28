FROM openkbs/jdk-mvn-py3-vnc

MAINTAINER DrSnowbird "DrSnowbird@openkbs.org"

###############################
#### ---- User setup: ---- ####
###############################
ENV USER=${USER:-developer}
ENV HOME=/home/${USER}

#### ---- Install Directory: ---- ####
ENV INSTALL_DIR=${HOME}

#### ---- App Preparation: ---- ####
ENV PRODUCT_NAME=${PRODUCT_NAME:-vscode-docker-vnc}
ENV PRODUCT_HOME=${PRODUCT_HOME:-${INSTALL_DIR}/${PRODUCT_NAME}}
ENV SCRIPT_DIR=${SCRIPT_DIR:-${PRODUCT_HOME}/script}
ENV COMPONENT_DIR=${COMPONENT_DIR:-${PRODUCT_HOME}/component}
ENV NPM_PREFIX=${COMPONENT_DIR:-${PRODUCT_HOME}/npm}

USER ${USER}
WORKDIR ${HOME}

#### ---- Transfer setup ---- ####
COPY ./script ${SCRIPT_DIR}
COPY ./component ${COMPONENT_DIR}
COPY ./wrapper_process.sh ${PRODUCT_HOME}/wrapper_process.sh

#### ---- Permissions setup: ---- ####
RUN echo "`id -u`" && echo "`id -g`" && \
    sudo chown -R ${USER}:${USER} ${PRODUCT_HOME} ${HOME}/.config ${PRODUCT_HOME}/wrapper_process.sh && \
    sudo chmod +x ${PRODUCT_HOME}/*.sh ${SCRIPT_DIR}/*.sh ${COMPONENT_DIR}/*.sh && \
    ln -sf ${PRODUCT_HOME}/wrapper_process.sh ${HOME}/wrapper_process.sh && \
    sudo ln -sf /usr/bin/chromium-browser /usr/bin/chromium && \
    sudo find /usr/share -type d -user 4011 -maxdepth 1 && { [ $? -eq 0 ] && sudo chown root:root /usr /usr/share; }
    
# RUN sudo chown -R ${USER}:$(id -gn ${USER}) ${HOME}/.config 

#### ---- Apt (Ubuntu) Proxy setup ---- ####
#RUN cd ${SCRIPT_DIR}; ${SCRIPT_DIR}/setup_apt_proxy.sh 
#RUN sudo apt-get update --fix-missing -y

#### ---- NPM Proxy & NPM Permission setup: ---- ####
RUN cd ${SCRIPT_DIR}; ${SCRIPT_DIR}/setup_npm_proxy.sh
RUN cd ${SCRIPT_DIR}; ${SCRIPT_DIR}/setup_npm_with_no_sudo.sh

#### ---- Components Install: ---- ####
#RUN cd ${SCRIPT_DIR}; ${SCRIPT_DIR}/install-component-active.sh
RUN cd ${COMPONENT_DIR}; ${COMPONENT_DIR}/vs-code-server.sh -a install -t generic

#### ---- Permissions tidy up ---- ####
#RUN sudo chown -R root:root $(find /usr/share -type d -user 4011 -maxdepth 1)
    
##################################
####     ---- VNC: ----       ####
##################################
USER ${USER}
WORKDIR ${HOME}

ENTRYPOINT ["/dockerstartup/vnc_startup.sh"]

##################################
####     ---- Start: ----     ####
##################################
CMD "${HOME}/wrapper_process.sh"

