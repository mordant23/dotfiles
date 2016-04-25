#!/usr/bin/env bash

# @todo filter for commented lines
# @todo filter for deb-src lines
# @todo change repo strings to account for repos such as Google's that uses '[arch=amd64]' after 'deb'

function has_repo() {
     grep "$1" /etc/apt/sources.list  /etc/apt/sources.list.d/* | grep -v list.save | grep -v list.distUpgrade
}

repositories=(\
"deb https://apt.dockerproject.org/repo ubuntu-$(lsb_release -c -s) main" \
"deb https://atlassian.artifactoryonline.com/atlassian/hipchat-apt-client $(lsb_release -c -s) main" \
"deb http://download.virtualbox.org/virtualbox/debian $(lsb_release -c -s) contrib" \
"deb http://dl.google.com/linux/chrome/deb/ stable main" \
"deb http://ppa.launchpad.net/maarten-baert/simplescreenrecorder/ubuntu $(lsb_release -c -s) main"
)
do
    if [[ $(has_repo "${i}") ]]; then
        echo "Repo ${i} found"
    else
        echo "Repo ${i} NOT found"
    fi
done