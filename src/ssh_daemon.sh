#!/usr/bin/env bash

: "${ssh_port:=$4}"

if [[ -z "${ssh_port}" ]]; then

    echo ******** Required parameter ssh_port not set ********
    exit

fi

echo Make backup of the ssh daemon config file
mv /etc/ssh/sshd_config /etc/ssh/sshd_config.BAK

echo '*************** Harden sshd_config ******************'

cat << EOF > /etc/ssh/sshd_config
PermitRootLogin no
MaxAuthTries 3
LoginGraceTime 20
PasswordAuthentication no
PermitEmptyPasswords no
ChallengeResponseAuthentication no
KerberosAuthentication no
GSSAPIAuthentication no
X11Forwarding no
PermitUserEnvironment no
AllowAgentForwarding no
AllowTcpForwarding yes
PermitTunnel no
AllowGroups ssh-access
EOF

diff --color=always /etc/ssh/sshd_config.BAK /etc/ssh/sshd_config

# We don't restart the ssh service now otherwise subsequent scripts could not login as root

exit
