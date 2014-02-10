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
    apt-get -y install build-essential git-core zlib1g-dev libssl-dev libxml2-dev libxslt-dev libreadline6-dev libyaml-dev >/dev/null
    touch /.vm/initial-setup-apt-get-update
    echo "Finished running initial-setup apt-get update"
fi



if [[ ! -f /.vm/soft-installed ]]; then


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
    



    touch /.vm/soft-installed
fi


if [[ ! -f /.vm/heroku-installed ]]; then


    wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh
#heroku plugins:install http://github.com/marcofognog/heroku-mongo-sync
#https://github.com/hsbt/heroku-mongodb

    touch /.vm/heroku-installed

fi


if [[ ! -f /.vm/bundle-installed ]]; then

    echo "gem: --no-rdoc --no-ri " >> /etc/gemrc
    cd /vagrant
    rvm --create use  ruby-2.0.0-p247@marino
    gem install bundler
    bundle install

    touch /.vm/bundle-installed

fi



    
#   If you do a repair operation as root user be shure 
#   that afterwards all db files are owned by the mongodb user, 
#   otherwise mongodb will not start

# service mongodb stop
# mongod --repair
# chown -R mongodb:mongodb /var/lib/mongodb
# rm /var/lib/mongodb/mongod.lock
# service mongodb start
# rm /var/log/mongodb/mongodb.log
