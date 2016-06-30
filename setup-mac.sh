#!/usr/bin/env bash

set -e

echo "DEV-SETUP: Starting installation of base development tools..."
echo "DEV-SETUP: NOTE: You will be asked for your password for sudo access!"

# Install xcode

if [[ ! $(command -v xcode-select) ]]; then
  echo "DEV-SETUP: Installing XCode CLI tools..."
  xcode-select --install
fi

# Install homebrew
if [[ ! $(command -v brew) ]]; then
  echo "DEV-SETUP:Installing homebrew..."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo "Updating Brew"
brew update

TAP_LIST="caskroom/cask
homebrew/php
"

# Tap repos that are not already tapped
for repo in ${TAP_LIST}; do
    if brew tap -1 | grep -q "^${repo}\$"; then
        echo "Tap '$repo' is already installed"
    else
        echo "Tapping '$repo'"
        brew tap ${repo}
    fi
done

BREW_LIST="brew-cask
autoconf
mysql
chromedriver
nmap
composer
node
docker
nvm
docker-compose
openssl
docker-machine
php70
freetype
php70-mcrypt
gettext
php70-xdebug
icu4c
readline
jpeg
selenium-server-standalone
libpng
sl
libyaml
tree
mcrypt
unixodbc
mhash
"

CASK_LIST="atom
cscreen
skitch
vagrant
bettertouchtool
firefox
slack
cakebrew
fluid
stay
clipmenu
screenhero
unrarx
intellij-idea
sequel-pro
"

NPM_LIST="bower
gulp
"

# Install tools that will not require cask
for pkg in ${BREW_LIST}; do
    if brew list -1 | grep -q "^${pkg}\$"; then
        echo "Package '$pkg' is already installed"
    else
        echo "Installing '$pkg'"
        brew install ${pkg}
    fi
done

# Install tools that will require cask
for pkg in ${CASK_LIST}; do
    if brew cask list -1 | grep -q "^${pkg}\$"; then
        echo "Package '$pkg' is already installed"
    else
        echo "Installing '$pkg'"
        brew cask install ${pkg}
    fi
done

# Install tools that will require npm
for pkg in ${NPM_LIST}; do
    if ls -h -1 `npm root -g` | grep -q "^${pkg}\$"; then
        echo "Package '$pkg' is already installed"
        echo "Updating '$pkg'"
        npm update -g ${pkg}
    else
        echo "Installing '$pkg'"
        npm install -g ${pkg}
    fi
done
