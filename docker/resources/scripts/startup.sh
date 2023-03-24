#!/bin/bash

    #mkdir -p /home/$NB_USER/.vscode
    #mkdir -p /home/$NB_USER/.local/share/code-server/extensions
    #rm -rf /home/$NB_USER/.vscode/extensions
    #ln -s /home/$NB_USER/.local/share/code-server/extensions /home/$NB_USER/.vscode/
    mkdir -p /usr/share/jupyter
    ln -s /opt/conda/share/jupyter/kernels  /usr/share/jupyter/kernels
    service ssh start
