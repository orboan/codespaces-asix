#!/bin/bash

# Enable exit on error
set -e
# Show all commands
set -x

echo "Installing system basics ..."

apt-get update --yes && \
    # - apt-get upgrade is run to patch known vulnerabilities in apt-get packages as
    #   the ubuntu base image is rebuilt too seldom sometimes (less than once a month)
    apt-get upgrade --yes && \
    apt-get install --yes --no-install-recommends \
    ca-certificates \
    locales \
    sudo \
    tini \
    wget \
  apt-transport-https \
  net-tools \
  libcurl4 \
  curl \
  apt-utils \
  rsync \
  vim \
  iputils-ping \
  ssh \
  git \
  openssl \
  less \
  tree \
  bash-completion \
  socat \
  jq \
  psmisc \
  zip \
  gzip \
  unzip \
  bzip2 \
  lzop \
  tzdata \
  fonts-liberation \
  pandoc \
  run-one \
  texlive-xetex \
  texlive-fonts-recommended \
  texlive-plain-generic \
  xclip 

  # required by mysql and postgresql
apt-get install -y --no-install-recommends \
  libmysqlclient-dev \
  libpq-dev
  
exit 0
