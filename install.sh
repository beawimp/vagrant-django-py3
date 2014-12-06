#!/bin/bash

PGSQL_VERSION=9.3


echo ""
echo "apply locale fixes so postgres uses utf-8"
echo ""
cp -p /vagrant_data/etc-bash.bashrc /etc/bash.bashrc

export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
sudo locale-gen en_US.UTF-8
dpkg-reconfigure locales


echo ""
echo "update software"
echo ""
sudo apt-get update -y


echo ""
echo "install dev packages"
echo ""
sudo apt-get install -y libxml2-dev libxslt-dev curl libcurl4-openssl-dev
sudo apt-get install -y libreadline-dev
sudo apt-get install -y build-essential python3 python3-setuptools python-pip python3-pip libpq-dev python-dev pep8
sudo apt-get install -y libjpeg-dev libtiff-dev zlib1g-dev libfreetype6-dev liblcms2-dev
sudo apt-get install -y git git-core


echo ""
echo "setup postgres"
echo ""
if ! command -v psql; then
    sudo apt-get install -y postgresql-$PGSQL_VERSION libpq-dev
    cp /vagrant_data/pg_hba.conf /etc/postgresql/$PGSQL_VERSION/main/
    /etc/init.d/postgresql reload
fi


echo ""
echo "setup virtualenv"
echo ""
if [[ ! -f /usr/local/bin/virtualenv ]]; then
    easy_install virtualenv virtualenvwrapper stevedore virtualenv-clone
fi


echo ""
echo "copy bashrc"
echo ""
cp -p /vagrant_data/bashrc /home/vagrant/.bashrc


echo ""
echo "fetch required python packages"
echo ""

pip install -r /vagrant_data/pip_requirements.txt
pip3 install -r /vagrant_data/pip_requirements.txt


echo ""
echo "cleanup"
echo ""
apt-get clean