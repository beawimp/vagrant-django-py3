#!/bin/bash

PGSQL_VERSION=9.3


echo ""
echo "apply locale fixes so postgres uses utf-8"
echo ""
cp -p /vagrant_data/etc-bash.bashrc /etc/bash.bashrc
locale-gen en_GB.UTF-8
dpkg-reconfigure locales

export LANGUAGE=en_GB.UTF-8
export LANG=en_GB.UTF-8
export LC_ALL=en_GB.UTF-8


echo ""
echo "update software"
echo ""
apt-get update -y


echo ""
echo "install dev packages"
echo ""
apt-get install -y libxml2-dev libxslt-dev curl libcurl4-openssl-dev
apt-get install -y libreadline-dev
apt-get install -y build-essential python3 python3-setuptools python-pip python3-pip libpq-dev python-dev pep8
apt-get install -y libjpeg-dev libtiff-dev zlib1g-dev libfreetype6-dev liblcms2-dev
apt-get install -y git git-core


echo ""
echo "setup postgres"
echo ""
if ! command -v psql; then
    apt-get install -y postgresql-$PGSQL_VERSION libpq-dev
    cp /vagrant_data/pg_hba.conf /etc/postgresql/$PGSQL_VERSION/main/
    /etc/init.d/postgresql reload
fi


echo ""
echo "setup virtualenv"
echo ""
if ! command -v pip; then
    easy_install -U pip
fi
if [[ ! -f /usr/local/bin/virtualenv ]]; then
    easy_install virtualenv virtualenvwrapper stevedore virtualenv-clone
fi


echo ""
echo "copy bashrc"
echo ""
cp -p /vagrant_data/bashrc /home/vagrant/.bashrc


echo ""
echo "setup package caching for python"
echo ""
if [[ ! -e /home/vagrant/.pip_download_cache ]]; then
    su - vagrant -c "mkdir -p /home/vagrant/.pip_download_cache && \
        virtualenv /home/vagrant/yayforcaching && \
        PIP_DOWNLOAD_CACHE=/home/vagrant/.pip_download_cache /home/vagrant/yayforcaching/bin/pip install -r /vagrant_data/pip_requirements.txt && \
        rm -rf /home/vagrant/yayforcaching"
fi


echo ""
echo "cleanup"
echo ""
apt-get clean