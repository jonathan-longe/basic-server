#!/bin/bash

# This script configures a remote DigitalOcean server called a 'droplet'

# Before invoking this script:
#   - login to DigitalOcean
#   - create a droplet; (e.g. Debian, 1GB ($5/mth) Toronto or San Fran)
#   - make sure droplet includes your ssh key


# Then, from your desktop / laptop run:  ./configure_droplet.sh "server_ip"
#   - where "server_ip" is the ip address of the newly instantiated DigitalOcean server

if [ -z "$1" ]
then
    echo 'Error:  you must provide the IP address of the remote server'
    exit
fi


echo Create remote sudo user: $USER

echo ''

echo What will be the password for $USER on $1
read NEW_PASSWORD

echo ''

read -e -p "SSH Port? " -i "22" SSH_PORT
echo $SSH_PORT

echo ''

echo 'What shell do you want to install? Enter the number that corresponds to your choice below'
options=("bash" "zsh")
select remote_shell in "${options[@]}"
do
    case $remote_shell in
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
ssh-keygen -f $HOME/.ssh/known_hosts -R "$1"

echo ''
echo ''

echo Creating $USER on $1 using this password: $NEW_PASSWORD
ssh root@$1 "bash -s" -- < ./remote.sh "$USER" "$NEW_PASSWORD" "$SSH_PORT" "$remote_shell"

if [[ $remote_shell == 'zsh' ]]; then

   ssh -p$SSH_PORT $USER@$1 "zsh -s" -- < ./oh-my-zsh-install.sh

 fi


