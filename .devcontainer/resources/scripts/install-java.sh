#!/bin/bash

# Enable exit on error
set -e
# Show all commands
set -x

SDKMAN_DIR="/opt/sdkman"

echo ""
echo "Installing runtime for java..."
echo "Java version = ${JAVA_VERSION}-${JAVA_PROVIDER}"
echo ""

curl -s "https://get.sdkman.io" | bash 
source "$SDKMAN_DIR/bin/sdkman-init.sh"
sdk install java ${JAVA_VERSION}-${JAVA_PROVIDER}
chown $NB_USER:$NB_GID -R $SDKMAN_DIR

#install maven
sdk install maven

exit 0
