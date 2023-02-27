FROM jupyter/minimal-notebook:latest

ARG ijava_version=1.3.0
ARG java_version=17.0.6
ARG java_provider=amzn
ARG SCALA3_VER=3.2.0
ARG python_major_version=3.10
ARG language=ca_ES
ENV NB_USER=jovyan

ENV \
    CONDA_BASE_PATH=/opt/conda \
    IJAVA_VERSION=$ijava_version \
    DOMAIN=pluralcamp.com \
    PYTHON_VERSION_MAJOR=$python_major_version \
    LANG="${language}.UTF-8" \
    LC_CTYPE="${language}.UTF-8" \
    LC_ALL="${language}.UTF-8" \
    LANGUAGE="${language}:ca" \      
    REMOVE_DASH_LINECOMMENT=true \
    SHELL=/bin/bash \
    HOME="/home/$NB_USER" \
    USER="${NB_USER}" \
    USER_GID="${NB_GID}" \
    XDG_CACHE_HOME="${HOME}/.cache/" \
    XDG_RUNTIME_DIR="/tmp" \
    DISPLAY=":1" \
    TERM="xterm" \
    DEBIAN_FRONTEND="noninteractive" \
    RESOURCES_PATH="/resources" \
    SSL_RESOURCES_PATH="/resources/ssl" \
    WORKSPACE_HOME="${HOME}" \
    JUPYTER_ENABLE_LAB=yes \
    PATH=/opt/conda/bin:${PATH} \
    SDKMAN_DIR="/opt/sdkman" \
    NOTEBOOK_ARGS="--notebook-dir=/home/$NB_USER --no-browser --NotebookApp.password='sha1:c4f869f064af:98fd6cb811e7e05beb33167b272554336c712f14'"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

COPY resources/scripts/clean-layer.sh  /usr/bin/clean-layer.sh

USER root

RUN \
    chmod a+rwx /usr/bin/clean-layer.sh && \
    mkdir -p $RESOURCES_PATH && chmod a+rwx $RESOURCES_PATH

## locales
RUN \
    if [ "$language" != "en_US" ]; then \
        apt-get -y update; \
        DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends locales; \
        echo "${language}.UTF-8 UTF-8" > /etc/locale.gen; \
        locale-gen; \
        dpkg-reconfigure --frontend=noninteractive locales; \
        update-locale LANG="${language}.UTF-8"; \
    fi \
    && clean-layer.sh


### BASICS START ###
COPY resources/scripts/install-basics-1.sh  /usr/bin/install-basics-1.sh
RUN \
    chmod a+rwx /usr/bin/install-basics-1.sh && \
    install-basics-1.sh && \
    clean-layer.sh

COPY resources/scripts/install-basics-2.sh  /usr/bin/install-basics-2.sh
RUN \
    chmod a+rwx /usr/bin/install-basics-2.sh && \
    install-basics-2.sh && \
    clean-layer.sh

# prepare ssh for inter-container communication for remote python kernel
COPY resources/scripts/install-ssh.sh  /usr/bin/install-ssh.sh
RUN \
    chmod a+rwx /usr/bin/install-ssh.sh && \
    install-ssh.sh && \
    # Cleanup
    clean-layer.sh

### BASICS END ###

### START RUNTIMES ###

## Java and Scala
ENV SCALA3_VER=${SCALA3_VER} \
    JAVA_VERSION=${java_version} \
    JAVA_PROVIDER=${java_provider}
COPY resources/scripts/install-java-scala.sh  /usr/bin/install-java-scala.sh
RUN \
    chmod a+rwx /usr/bin/install-java-scala.sh && \
    install-java-scala.sh && \
    # Cleanup
    clean-layer.sh
    
### END RUNTIMES ###

## VS Code Server: https://github.com/codercom/code-server -- latest
ENV CODESERVER_VER=4.10.0
COPY resources/ides/vs-code-server.sh $RESOURCES_PATH/ides/vs-code-server.sh
RUN \
    chmod +x $RESOURCES_PATH/ides/vs-code-server.sh && \
    /bin/bash $RESOURCES_PATH/ides/vs-code-server.sh && \
    # Cleanup
    clean-layer.sh


#### KERNELS START ####

COPY resources/ikernels $RESOURCES_PATH/ikernels/

## java kernel start ##

COPY resources/config/ijava $RESOURCES_PATH/config/ijava/

RUN \
    chmod +x $RESOURCES_PATH/ikernels/java-kernel.sh ;\
    /bin/bash $RESOURCES_PATH/ikernels/java-kernel.sh ;\
    # Cleanup
    clean-layer.sh

## java kernel end ##

#### KERNELS END ####

ARG password=pluralcamp

### Setting passwd for NB_USER and root
RUN \
    echo "${NB_USER}:$password" | chpasswd && \
    echo "root:$password" | chpasswd


## Jupyter Extensions
COPY resources/jupyter-extensions/install-basic-jupyter-extensions.sh $RESOURCES_PATH/jupyter-extensions/install-basic-jupyter-extensions.sh

RUN \
    chmod +x $RESOURCES_PATH/jupyter-extensions/install-basic-jupyter-extensions.sh && \
    /bin/bash $RESOURCES_PATH/jupyter-extensions/install-basic-jupyter-extensions.sh && \
    # Cleanup
    clean-layer.sh


## Jupyter Server Proxy config
ARG CONFIG_NB_FILE=/etc/jupyter/jupyter_server_config.py
COPY ./proxy-server.entorn-io.py ./jupyter_notebook_config.py /tmp/
RUN cat /tmp/proxy-server.entorn-io.py >> $CONFIG_NB_FILE && \
cat /tmp/jupyter_notebook_config.py >> $CONFIG_NB_FILE && \
clean-layer.sh

## Configurations

COPY resources/scripts/set-jupyter-config.sh /usr/bin/set-jupyter-config.sh
COPY resources/scripts/jpy-customize.sh /usr/bin/jpy-customize.sh
COPY resources/scripts/set-lab-themes.sh /usr/bin/set-lab-themes.sh
COPY resources/config $RESOURCES_PATH/config
COPY resources/logos/java $RESOURCES_PATH/logos/java

## jupyter customizations
RUN \
    chmod +x \
    /usr/bin/set-jupyter-config.sh \
    /usr/bin/jpy-customize.sh \
    /usr/bin/set-lab-themes.sh \
    && \
    /usr/bin/set-jupyter-config.sh && \
    /usr/bin/jpy-customize.sh && \
    /usr/bin/set-lab-themes.sh && \
# Directory for apps installed by user && \
 mkdir -p /opt/apps && \
 chown $NB_USER:$NB_GID /opt/apps && \
# icons for jupyter-server-proxy && \
 mkdir -p /etc/jupyter/icons

COPY resources/icons /etc/jupyter/icons

COPY resources/config/.bashrc resources/config/.profile /home/$NB_USER/

RUN chown $NB_USER:$NB_GID -R /opt/sdkman
RUN chown $NB_USER:$NB_GID -R /home/$NB_USER 

RUN jupyter labextension install jupyterlab-launcher-shortcuts

COPY resources/bin-hooks/before-custom.sh /usr/local/bin/before-notebook.d/
RUN chmod +x /usr/local/bin/before-notebook.d/*

USER $NB_USER

