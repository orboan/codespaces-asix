#!/bin/bash

set -e

if [[ -z "$RESOURCES_PATH" ]]; then
                RESOURCES_PATH=/resources
fi

#### RUN HOOKS ####
run-hooks () {
    # Source scripts or run executable files in a directory
    if [[ ! -d "$1" ]] ; then
        return
    fi
    echo "$0: running hooks in $1"
    for f in "$1/"*; do
        case "$f" in
            *.sh)
                echo "$0: running $f"
                # shellcheck disable=SC1090
                source "$f"
                ;;
            *)
                if [[ -x "$f" ]] ; then
                    echo "$0: running $f"
                    "$f"
                else
                    echo "$0: ignoring $f"
                fi
                ;;
        esac
    done
    echo "$0: done running hooks in $1"
}


####### SUDOERS START #########
set_sudo() {
    msg=`sudo -l -U "$NB_USER"`
    substr='not allowed'
    if [ $? -eq 0 ]; then
      if [[ "$msg" == *"$substr"* ]]; then
          echo "$NB_USER  ALL=(ALL)       NOPASSWD: ALL" | sudo tee --append /etc/sudoers
      fi
    fi
}

set_sudo

sudo sed -i "s/#Port 22/Port 2222/g" /etc/ssh/sshd_config

# start sshd service
sudo service ssh start
