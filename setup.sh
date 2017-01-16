#!/usr/bin/env bash

# @todo install selenium stand alone server
# @todo make mysql server setup idempotent
# @todo upgrade vagrant to version 1.8
# @todo add user to docker group and other steps as described http://stackoverflow.com/a/34869632
# @todo add checks and updates for repositories (for after upgrades) -- may need to be a separate script

MESSAGE_PREFIX="########## "

function check_program_msg ()
{
    echo ${MESSAGE_PREFIX} "Checking for " $1
}

function download_program_msg ()
{
    echo ${MESSAGE_PREFIX} "Downloading and installing " $1
}

function already_exists_msg ()
{
    echo ${MESSAGE_PREFIX} $1 " already exists"
}

# Edit Profile
cd ~

echo ${MESSAGE_PREFIX} "Editing ~/.profile"

echo ${MESSAGE_PREFIX} "Checking default editor"
if [[ ! $(echo ${EDITOR} | grep vi) ]]; then
    echo ${MESSAGE_PREFIX} "Adding vi as default editor"
    sed -i '$a export EDITOR=$(command -v vi)' .profile
fi

echo ${MESSAGE_PREFIX} "Checking PATH"
if [[ ! $(echo ${PATH} | grep npm-global) ]]; then
    echo ${MESSAGE_PREFIX} "Adding PATH"
    sed -i '$a export PATH=~/.npm-global/bin:$PATH' .profile
fi

# Installing useful packages from existing repos
echo ${MESSAGE_PREFIX} "Installing initial packages"
packages=( git xclip synaptic gdebi build-essential openjdk-8-jdk php7.0 php-xdebug php7.0-mcrypt mysql-server \
 mysql-client network-manager-openconnect-gnome apt-transport-https ca-certificates)
for i in "${packages[@]}"
do
    if [[ ! $(command -v ${i}) && ! $(dpkg-query -l "${i}" | grep ${i})  ]]; then
        download_program_msg ${i}
        sudo apt-get install -y ${i}
    else
        already_exists_msg ${i}
    fi
done

# Setup Mysql
echo ${MESSAGE_PREFIX} "Setting up mysql server"
sudo mysql_secure_installation
sudo mysql_install_db

# Create directories
echo ${MESSAGE_PREFIX} "Creating Directories"
directories=( projects src bin .npm-global )
cd ~
for i in "${directories[@]}"
do
    if [[ ! -d ${i} ]]; then
        mkdir ${i}
    fi
done

cd ~/Downloads/

# Install Vagrant (the one in the repo is old)
check_program_msg "Vagrant"
if [[ ! $(command -v vagrant) ]]; then
    download_program_msg "Vagrant"
    curl -O https://releases.hashicorp.com/vagrant/1.8.1/vagrant_1.8.1_x86_64.deb
    sudo dpkg -i vagrant*.deb
else
    already_exists_msg "Vagrant"
fi

# Install docker
if [[ ! $(command -v docker-engine) && ! $(dpkg-query -l docker-engine | grep docker-engine)  ]]; then
    download_program_msg "Docker"
    sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
    sudo add-apt-repository 'deb https://apt.dockerproject.org/repo ubuntu-$(lsb_release -c -s) main'
    sudo apt-get update
    sudo apt-get purge lxc-docker
    sudo apt-get install -y docker-engine
else
    already_exists_msg "Docker"
fi

# Install Google Chrome
check_program_msg "Google Chrome"
if [[ ! $(command -v google-chrome) ]]; then
    download_program_msg "Google Chrome"
    curl -O https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i google-chrome*.deb
else
    already_exists_msg "Google Chrome"
fi

# Download Intellij
check_program_msg "Intellij"
if [[ ! $(command -v idea) ]]; then
    download_program_msg "Intellij"
    curl -O https://download.jetbrains.com/idea/ideaIU-2016.3.2.tar.gz
    tar -zxvf ideaIU-2016.1.1.tar.gz
    mkdir bin/idea
    mv idea-IU*/* bin/idea/
    cd ~/bin/idea/bin/
    ./idea.sh
    cd ~/Downloads/
else
    already_exists_msg "Intellij"
fi

# Download Virtualbox
check_program_msg "Virtualbox"
if [[ ! $(command -v virtualbox) ]]; then
    download_program_msg "Virtualbox"
    sudo add-apt-repository 'deb http://download.virtualbox.org/virtualbox/debian $(lsb_release -c -s) contrib'
    wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
    sudo apt-get update && sudo apt-get install virtualbox-5.0
else
    already_exists_msg "Virtualbox"
fi

# Download node and npm
check_program_msg "node"
if [[ ! $(command -v node) ]]; then
    curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -
    sudo apt-get install -y nodejs
else
    already_exists_msg "node"
fi

# Setting npm prefix to ~/.npm-global
echo ${MESSAGE_PREFIX} "setting npm prefix to ~/.npm-global"
npm config set prefix '~/.npm-global'

if [[ ! $(echo ${NPM_CONFIG_PREFIX}) ]]; then
    echo ${MESSAGE_PREFIX} "adding NPM_CONFIG_PREFIX environment variable"
    sed -i '$a export NPM_CONFIG_PREFIX="~/.node-global"' ~/.profile
else
    echo ${MESSAGE_PREFIX} "NPM_CONFIG_PREFIX environment variable already set"
fi

# Install global npm packages
node_packages=( npm bower gulp grunt yo )
for i in "${node_packages[@]}"
do
    if [ ! $(command -v ${i}) ]; then
        download_program_msg ${i}
        npm install -g ${i}
    else
        already_exists_msg ${i}
    fi
done

. ~/.profile

echo "=== Manual Steps ==="
echo "Make Chrome default browser and add it to launcher"
echo "Add Google apps Keep and Hangout and add them to launcher"
echo "Change terminal profile to white on black"
echo "Add git autocompletion"
echo "Change prompt"
