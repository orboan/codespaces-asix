#!/bin/bash

workdir=/resources/docker

mkdir -p /home/$NB_USER/.dockerc/mysql
cp -r $workdir/compose/mysql /home/$NB_USER/.dockerc/
cp -r $workdir/bin/my* /home/$NB_USER/.local/bin/
#cp -r $workdir/bin/mysql* /home/$NB_USER/.local/bin/
chmod +x /home/$NB_USER/.local/bin/my*
chown $NB_USER:$NB_GID -R /home/$NB_USER/.local/bin

cp /resources/dbs/mysql/apt-sources/mysql.list /etc/apt/sources.list.d/mysql.list

#apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 467B942D3A79BD29 

apt update 

apt install --no-install-recommends -y mysql-client

cp /resources/dbs/mysql/mysql.cnf /etc/mysql/conf.d/mysql.cnf

mkdir -p /var/run/mysqld && \
ln -s /var/lib/docker/volumes/mysql_sock/_data/mysqld.sock /var/run/mysqld/mysqld.sock
