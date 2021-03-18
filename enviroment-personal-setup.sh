#!/bin/sh
# @author Kevin Uehara
# @date 2020-03-17

LIST_OF_APPS_SNAP="slack intellij-idea-community discord code spotify"
LIST_OF_APPS_ADD_REPO="ppa:gnome-terminator/nightly 
	ppa:gnome-terminator/nightly-gtk3"
LIST_OF_APPS_GET="git terminator default-jdk default-jre nodejs npm"

sudo -n true
test $? -eq 0 || exit 1 "you should have sudo priveledge to run this script"

for i in $LIST_OF_APPS_SNAP; do
	snap install "$i" --classic
done

echo "Preparing to add get Repositories Applications..."

for i in $LIST_OF_APPS_ADD_REPO; do
	add-apt-repository "$i"
done

apt-get update

echo "Preparing to get Applications..."

for i in $LIST_OF_APPS_GET; do
	apt-get install "$i"
done

echo "Preparing to install Chrome..."
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add - &&
sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' &&
apt-get update &&
apt install google-chrome-stable

echo "Preparing to install Docker"


read -p "Do you want to install Docker and Docker-Compose?(y/n) " option
option=${option:-y}

if [ $option = "y" ]
then
	echo "Preparing to install Docker Client"
	apt install apt-transport-https ca-certificates curl software-properties-common &&
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - &&
	add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" &&
	apt update &&
	apt-cache policy docker-ce &&
	apt install docker-ce &&
	usermod -aG docker ${USER} &&
	su - ${USER}

	echo "Preparing to install Docker Compose"
	curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose &&
	chmod +x /usr/local/bin/docker-compose
fi

read -p "Do you want to install Oh-My-Zsh?(y/n) " optionZsh
optionZsh=${optionZsh:-y}

if [ $option = "y" ]
then
	echo "Preparing to install Oh My ZSH"
	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
