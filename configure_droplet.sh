#!/bin/bash

export SERVER_IP=$1

# This script configures a remote DigitalOcean server called a 'droplet'

# Before invoking this script:
#   - login to DigitalOcean
#   - create a droplet; (e.g. Debian, 1GB ($5/mth) Toronto or San Fran)
#   - make sure droplet includes your ssh key


# Then, from your desktop / laptop run:  ./configure_droplet.sh "server_ip"
#   - where "server_ip" is the ip address of the newly instantiated DigitalOcean server

if [ -z "$SERVER_IP" ]
then
    echo 'Error:  you must provide the IP address of the remote server'
    exit
fi


echo Create remote sudo user: $USER

echo ''

echo What will be the password for $USER on $SERVER_IP
read NEW_PASSWORD

echo ''

read -e -p "SSH Port? " -i "22" SSH_PORT
echo $SSH_PORT

echo ''

echo 'What shell do you want to install? Enter the number that corresponds to your choice below'
options=("bash" "zsh")
select REMOTE_SHELL in "${options[@]}"
do
    case $REMOTE_SHELL in
        "bash")
            break
            ;;
        "zsh")
            break
            ;;
    esac
done

echo ''

echo '***************** Delete Known Host Key - if one exists ********************'
ssh-keygen -f $HOME/.ssh/known_hosts -R "$SERVER_IP"

echo ''
echo ''

echo Install basic components on $SERVER_IP
ssh root@$SERVER_IP "bash -s" -- < ./src/basic_setup.sh "$USER" "$NEW_PASSWORD" "$REMOTE_SHELL" "$SSH_PORT"

echo ''
echo ''

echo Creating $USER on $SERVER_IP using this password: $NEW_PASSWORD
ssh root@$SERVER_IP "bash -s" -- < ./src/create_new_user.sh "$USER" "$NEW_PASSWORD" "$REMOTE_SHELL" "$SSH_PORT"

echo ''
echo ''

echo Installing Docker and Docker Compose
ssh root@$SERVER_IP "bash -s" -- < ./src/docker.sh "$USER" "$NEW_PASSWORD" "$REMOTE_SHELL" "$SSH_PORT"

echo ''
echo ''


echo Configure the Uncomplicated Firewall
ssh root@$SERVER_IP "bash -s" -- < ./src/firewall.sh "$USER" "$NEW_PASSWORD" "$REMOTE_SHELL" "$SSH_PORT"

echo ''
echo ''

echo Make the SSH Daemon more secure
# After this script runs, root can no longer ssh
ssh root@$SERVER_IP "bash -s" -- < ./src/ssh_daemon.sh "$USER" "$NEW_PASSWORD" "$REMOTE_SHELL" "$SSH_PORT"

echo ''
echo ''


if [[ $REMOTE_SHELL == 'zsh' ]]; then

   ssh -p$SSH_PORT $USER@$SERVER_IP "bash -s" -- < ./src/oh-my-zsh-install.sh "$USER" "$NEW_PASSWORD" "$REMOTE_SHELL" "$SSH_PORT"

fi


