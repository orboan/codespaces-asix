#!/bin/bash

# Enable exit on error
set -e
# Show all commands
set -x

echo "Installing system basics (part 1) ..."

apt update -y
apt-get install -y --no-install-recommends \
  apt-transport-https \
  ca-certificates \
  net-tools \
  libcurl4 \
  curl \
  apt-utils \
  rsync \
  vim \
  iputils-ping \
  ssh \
  git \
  wget \
  openssl

  # required by mysql
apt-get install -y --no-install-recommends \
  libmysqlclient-dev 
  
exit 0
