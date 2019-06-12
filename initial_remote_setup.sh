
export NEW_USER=$1
export NEW_USER_HOMEDIR=/home/$1
export NEW_PASSWORD=$2

echo adding a favorite alias
alias ll='ls -lahG'

echo Set timezone
timedatectl set-timezone America/Vancouver

echo DigitalOcean recommends next line. See https://www.digitalocean.com/community/questions/debian-9-3-droplet-issues-with-useradd
apt-get remove -y unscd

echo Update system
apt-get update && apt-get -y upgrade

echo Installing essentials
apt-get install -y git curl git-core ufw zsh wget


echo Installing Docker

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

echo '************* Installed Docker Compose *******************'

echo '************* Installing Nodejs and NPM *******************'

apt-get install -y nodejs npm

echo '************* Installed Nodejs and NPM *******************'

addgroup ssh-access

echo Create user: $NEW_USER using password: $NEW_PASSWORD
# Create the user; add to group; create home directory (-m); set password hashed
useradd -G users,sudo,ssh-access -m -s /bin/zsh -p $(echo $NEW_PASSWORD | openssl passwd -1 -stdin) $NEW_USER

echo Show information about the user:
getent passwd $NEW_USER
id -Gn $NEW_USER

echo Copy public SSH keys installed by Digital Ocean in root into new users home directory
cp -R /root/.ssh/ $NEW_USER_HOMEDIR

chmod 700 $NEW_USER_HOMEDIR/.ssh
chmod 600 $NEW_USER_HOMEDIR/.ssh/*
chown -R $NEW_USER:$NEW_USER $NEW_USER_HOMEDIR/.ssh

echo *************** Switching user to new user ********************
su -l $NEW_USER

echo
echo     ----------- Install Oh-my-zsh -------------
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | /bin/zsh

echo
echo     ----------- Add the bullet-train theme -----------
cd ~/.oh-my-zsh/themes
wget https://raw.github.com/caiogondim/bullet-train-oh-my-zsh-theme/master/bullet-train.zsh-theme

echo
echo     ----------- Make bullet-train the default theme -----------
sed -i 's/"robbyrussell"/"bullet-train"/g' ~/.zshrc


exit
echo ***************** Switching back to root user *********************

echo Configure the Uncomplicated Firewall
ufw default deny incoming
ufw default allow outgoing

# open ssh port
ufw allow ssh

# open http port
ufw allow 80/tcp
ufw allow 443/tcp

# open ntp port : to sync the clock of your machine
ufw allow 123/udp

# turn on firewall
ufw --force enable

# check the status
ufw status

echo Make backup of the ssh daemon config file
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.BAK

#echo Replace default sshd_config with secure file uploaded previously
mv /etc/ssh/sshd_config.secure /etc/ssh/sshd_config

# Restart the ssh service:
echo Restart the ssh daemond
service ssh restart


