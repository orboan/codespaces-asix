#!/bin/bash


# Stops script execution if a command has an error
set -e

if [ ! -f "/usr/local/bin/code-server"  ]; then
    echo "Installing VS Code Server. Please wait..."
    cd ${RESOURCES_PATH}
    VS_CODE_VERSION=${CODESERVER_VER}
    curl -fsSL https://code-server.dev/install.sh | sh
    #rmdir /home/$NB_USER/work
    mkdir -p /home/$NB_USER/workspaces && chown $NB_USER:$NB_GID -R /home/$NB_USER/workspaces
    mkdir -p /home/$NB_USER/.config/Code/ && chown $NB_USER:$NB_GID -R /home/$NB_USER/.config
    mkdir -p /home/$NB_USER/.vscode/extensions/ && chown $NB_USER:$NB_GID -R /home/$NB_USER/.vscode
    if [[ ! -e /usr/bin/code-server ]]; then 
        ln -s /opt/conda/share/npm-packages/bin/code-server /usr/bin/code-server
    fi 
else
    echo "VS Code Server is already installed"
fi

