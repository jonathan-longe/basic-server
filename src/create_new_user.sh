#!/usr/bin/env bash

export NEW_USER=$1
export NEW_USER_HOMEDIR=/home/$1
export NEW_PASSWORD=$2
export NEW_SHELL=$3

addgroup ssh-access

if [[ $NEW_SHELL == 'zsh' ]]; then

   apt-get install -y zsh

fi

echo Create user: $NEW_USER using password: $NEW_PASSWORD
# Create the user; add to group; create home directory (-m); set password hashed
useradd -G users,sudo,ssh-access -m -s /bin/$NEW_SHELL -p $(echo $NEW_PASSWORD | openssl passwd -1 -stdin) $NEW_USER

echo Show information about the user:
getent passwd $NEW_USER
id -Gn $NEW_USER

echo Copy public SSH keys installed by Digital Ocean in root into new users home directory
cp -R /root/.ssh/ $NEW_USER_HOMEDIR

chmod 700 $NEW_USER_HOMEDIR/.ssh
chmod 600 $NEW_USER_HOMEDIR/.ssh/*
chown -R $NEW_USER:$NEW_USER $NEW_USER_HOMEDIR/.ssh

exit


