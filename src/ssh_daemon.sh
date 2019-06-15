#!/usr/bin/env bash

export SSH_PORT=$4

echo Make backup of the ssh daemon config file
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.BAK

echo '*************** Secure sshd_config ******************'

sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
sed -i "s/#Port 22/Port $SSH_PORT/g" /etc/ssh/sshd_config
sed -i 's/ClientAliveInterval 120/ClientAliveInterval 600/g' /etc/ssh/sshd_config

sed -i '$ a ClientAliveCountMax 3' /etc/ssh/sshd_config
sed -i '$ a AllowGroups ssh-access' /etc/ssh/sshd_config

diff --color=always /etc/ssh/sshd_config.BAK /etc/ssh/sshd_config


# Restart the ssh service:
echo Restart the ssh daemond
service ssh restart

exit