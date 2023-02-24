#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
CLEAR='\033[0m'
GREEN_CHECK="${GREEN}\xE2\x9C\x94${CLEAR}"
RED_X="${RED}\xE2\x9D\x8C${CLEAR}"

print_message() {
    local MESSAGE=$1
    local IS_ERROR=$2
    if (($IS_ERROR))
    then
        echo -e "${RED_X} ${MESSAGE}"
    else
        echo -e "${GREEN_CHECK} ${MESSAGE}"
    fi
}

install_ohmyzsh() {
    # TODO: check if Oh My Zsh was not installed?
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

install_homebrew() {
    # Check if Homebrew was not installed
    if ! command -v brew &> /dev/null
    then
        xcode-select --install /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/$USER/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
        brew analytics off
        brew update
    else
        print_message "Homebrew was already installed"
    fi
}

install_node() {
    # Check if Node was not installed with Hombrew
    if ! brew list --versions node &> /dev/null
    then
        # Check if Node was already installed
        if command -v node &> /dev/null
        then
            brew uninstall --force node
            rm -f /usr/local/bin/npm
        fi
        brew install nvm
        nvm install node
    else
        print_message "Node was already installed with Homebrew"
    fi
}

init() {
    # install_ohmyzsh
    install_homebrew
    install_node
}

init
