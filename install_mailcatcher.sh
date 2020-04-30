#!/bin/bash

function is_ruby_installed() {
    echo "Checking if Ruby is installed"
    if ruby --version
    then
        IS_RUBY_INSTALLED=1
    else
        IS_RUBY_INSTALLED=0
    fi
}

function install_ruby() {
    echo "Installing Ruby"
    install_ruby_gpg_keys
    install_rvm
    activate_rvm

    if rvm install ruby
    then
        echo "Ruby installed"
    else
        echo "Error installing Ruby"
        exit 4
    fi
}

function install_ruby_gpg_keys() {
    echo "Installing RVM GPG keys"
    if gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
    then
        echo "RVM GPG keys installed"
    else
        echo "Error installing GPG keys"
        exit 1
    fi
}

function install_rvm() {
    echo "Installing RVM"
    if curl -sSL https://get.rvm.io | bash -s stable
    then
        echo "RVM installed"
    else
        echo "Error installing RVM"
        exit 2
    fi
}

function activate_rvm() {
    echo "activating RVM"
    if source $HOME/.rvm/scripts/rvm
    then
        echo "RVM activated"
    else
        echo "Error activating RVM"
        exit 3
    fi
}

function install_mailcatcher() {
    echo "Installing Mailcatcher"
    if gem install mailcatcher
    then
        echo "Mailcatcher installed"
    else
        echo "Error installing mailcatcher"
        exit 4
    fi
}

function setup_supervisor() {
    echo "Setting up supervisor to run mailcatcher"
    if supervisorctl -h
    then
        echo "Supervisor installed"
    else
        echo "Supervisor doesn't seem to be installed, aborting"
        exit 5
    fi
}

# check that ruby is installed
is_ruby_installed
if [ "$IS_RUBY_INSTALLED" -eq 0 ]
then
    install_ruby
fi

# install mailcatcher
install_mailcatcher

# add supervisor configuration to keep mailcatcher running