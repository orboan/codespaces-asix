FROM jupyter/minimal-notebook:latest

ARG ijava_version=1.3.0
ARG java_version=17.0.6
ARG java_provider=amzn
ARG SCALA3_VER=3.2.0
ARG python_major_version=3.10
ARG language=ca_ES
ENV NB_USER=jovyan

ENV \
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
    SDKMAN_DIR="/home/$NB_USER/.sdkman" 
###    NOTEBOOK_ARGS="--notebook-dir=/home/$NB_USER --no-browser --NotebookApp.password='sha1:c4f869f064af:98fd6cb811e7e05beb33167b272554336c712f14'"

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
    # Fix permissions
    fix-permissions.sh $HOME && \
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

#### KERNELS START ####

COPY resources/ikernels $RESOURCES_PATH/ikernels/

## java kernel start ##

COPY resources/config/ijava $RESOURCES_PATH/config/ijava/

RUN \
    if [[ "$JAVA_KERNEL" == "true" ]]; then \
        chmod +x $RESOURCES_PATH/ikernels/java-kernel.sh ;\
        /bin/bash $RESOURCES_PATH/ikernels/java-kernel.sh ;\
    fi \
    # Cleanup
    && clean-layer.sh

## java kernel end ##

#### KERNELS END ####

USER $NB_USER


