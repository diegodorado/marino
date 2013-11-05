#!/bin/bash

if [[ ! -d  /.vm ]]; then
    mkdir /.vm
    echo "Created directory /.vm"
fi

if [[ -f /root/.profile ]]; then
    rm /root/.profile
    echo "Removed rm /root/.profile that generates no tty warnings"
fi


if [[ ! -f /.vm/initial-setup-apt-get-update ]]; then
    echo "Running initial-setup apt-get update"
    apt-get update >/dev/null
    touch /.vm/initial-setup-apt-get-update
    echo "Finished running initial-setup apt-get update"
fi



if [[ ! -f /.vm/soft-installed ]]; then


    apt-get -y update >/dev/null
    apt-get -y install build-essential git-core zlib1g-dev libssl-dev libxml2-dev libxslt-dev libreadline6-dev libyaml-dev >/dev/null


    #Install Mongodb

    #Append the below line to the end of the file /etc/apt/sources.list
    #deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen

    echo "deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen" >> /etc/apt/sources.list

    #Add GPG key

    apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10 >/dev/null
    
    #Update package
    apt-get update >/dev/null
    
    #Install Mongodb
    apt-get install mongodb-10gen
    mkdir -p /data/db 
    chown -R mongodb:mongodb /data
    
    #Install Ruby.

    cd /tmp
    wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p286.tar.gz
    tar -xvzf ruby-1.9.3-p286.tar.gz
    cd ruby-1.9.3-p286/
    ./configure --prefix=/usr/local
    make
    make install

    echo "gem: --no-rdoc --no-ri " >> /etc/gemrc

    #Install bundler
    gem install bundler

    echo 'Finished installing basic packages'


    cd /vagrant
    bundle install


    touch /.vm/soft-installed
fi

#wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh
#heroku plugins:install http://github.com/marcofognog/heroku-mongo-sync
gem install mongo