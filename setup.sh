#!/bin/bash
sudo apt-get install git xclip synaptic gdebi

# Install Google Chrome
if [[ ! $(command -v google-chrome) ]]; then
cd ~/Downloads/
curl -O https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome*.deb
fi

# Download Intellij
if [[ ! $(command -v google-chrome) ]]; then
curl -O https://download.jetbrains.com/idea/ideaIU-2016.1.1.tar.gz
fi

# Create directories
directories=( projects src bin )
cd ~
for i in "${directories[@]}"
do
if [ ! -d ${i} ]; then
mkdir ${i}
fi
done

echo "=== Manual Steps ==="
echo "Make Chrome default browser and add it to launcher"
echo "Add Google apps Keep and Hangout and add them to launcher"
echo "Change terminal profile to white on black"
