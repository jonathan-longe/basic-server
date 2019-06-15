#!/usr/bin/env bash

echo '************* Installing Docker *****************'

apt-get install -y apt-transport-https ca-certificates gnupg2 software-properties-common

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

apt-key fingerprint 0EBFCD88
# verify the finger print is 9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88

# get the stable version
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"

apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io

echo '************* Installing Docker Compose *****************'

curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose

docker-compose --version

echo '************* Docker and Docker Compose Installed *******************'

echo ''
echo ''

echo '************* Installing Nodejs and NPM *******************'

apt-get install -y nodejs npm

echo '************* Installed Nodejs and NPM *******************'

exit
