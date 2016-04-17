#!/bin/bash

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

# Installing useful packages from existing repos
echo ${MESSAGE_PREFIX} "Installing initial packages"
packages=( git xclip synaptic gdebi vagrant )
for i in "${packages[@]}"
do
    if [ ! $(command -v ${i}) ]; then
        download_program_msg ${i}
        sudo apt-get install ${i}
    else
        already_exists_msg ${i}
    fi
done

#sudo apt-get install git xclip synaptic gdebi vagrant

# Create directories
echo ${MESSAGE_PREFIX} "Creating Directories"
directories=( projects src bin )
cd ~
for i in "${directories[@]}"
do
    if [ ! -d ${i} ]; then
        mkdir ${i}
    fi
done

cd ~/Downloads/

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
    curl -O https://download.jetbrains.com/idea/ideaIU-2016.1.1.tar.gz
    tar -zxvf ideaIU-2016.1.1.tar.gz
    mkdir bin/idea
    mv idea-IU*/* bin/idea/
    cd ~/bin/idea/bin/
    ./idea.sh
else
    already_exists_msg "Intellij"
fi

# Download Hipchat
check_program_msg "Hipchat"
if [[ ! $(command -v hipchat4) ]]; then
    download_program_msg "Hipchat"
    sudo sh -c 'echo "deb https://atlassian.artifactoryonline.com/atlassian/hipchat-apt-client $(lsb_release -c -s) main" > /etc/apt/sources.list.d/atlassian-hipchat4.list'
    wget -O - https://atlassian.artifactoryonline.com/atlassian/api/gpg/key/public | sudo apt-key add -
    sudo apt-get update
    sudo apt-get install hipchat4
else
    already_exists_msg "Hipchat"
fi

# Download Virtualbox
check_program_msg "Virtualbox"
if [[ ! $(command -v virtualbox) ]]; then
    download_program_msg "Virtualbox"
    sudo add-apt-repository "deb http://download.virtualbox.org/virtualbox/debian wily contrib"
    wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
    sudo apt-get update && sudo apt-get install virtualbox-5.0
else
    already_exists_msg "Virtualbox"
fi

echo "=== Manual Steps ==="
echo "Make Chrome default browser and add it to launcher"
echo "Add Google apps Keep and Hangout and add them to launcher"
echo "Change terminal profile to white on black"
echo "Add git autocompletion"
echo "Change prompt"
