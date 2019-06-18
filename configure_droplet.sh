#!/bin/bash

server_ip=$1

# This script configures a remote DigitalOcean server called a 'droplet'

# Before invoking this script:
#   - login to DigitalOcean
#   - create a droplet; (e.g. Debian, 1GB ($5/mth) Toronto or San Fran)
#   - make sure droplet includes your ssh key


# Then, from your desktop / laptop run:  ./configure_droplet.sh "server_ip"
#   - where "server_ip" is the ip address of the newly instantiated DigitalOcean server

if [[ -z "$server_ip" ]]; then
    echo 'Error:  you must provide the IP address of the remote server'
    exit
fi


echo Create remote sudo user: $USER

echo ''

echo What will be the password for $USER on "${server_ip}"
read new_password

echo ''

read -e -p "SSH Port? " -i "22" ssh_port
echo "${ssh_port}"

echo ''

echo 'What shell do you want to install? Enter the number that corresponds to your choice below'
options=("bash" "zsh")
select remote_shell in "${options[@]}"
do
    case "${remote_shell}" in
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
ssh-keygen -f $HOME/.ssh/known_hosts -R "${server_ip}"

echo ''
echo ''

echo Install basic components on "${server_ip}"
ssh root@"${server_ip}" "bash -s" -- < ./src/basic_setup.sh "$USER" "${new_password}" "${remote_shell}" "${ssh_port}"

echo ''
echo ''

echo Creating $USER on "${server_ip}" using this password: ${new_password}
ssh root@"${server_ip}" "bash -s" -- < ./src/create_new_user.sh "$USER" "${new_password}" "${remote_shell}" "${ssh_port}"

echo ''
echo ''

echo Installing Docker and Docker Compose
ssh root@"${server_ip}" "bash -s" -- < ./src/docker.sh "$USER" "${new_password}" "${remote_shell}" "${ssh_port}"

echo ''
echo ''


echo Configure the Uncomplicated Firewall
# Modify the firewall configuration but don't enable yet as we'll be locked out if the SSH port has changed
ssh root@"${server_ip}" "bash -s" -- < ./src/firewall.sh "$USER" "${new_password}" "${remote_shell}" "${ssh_port}"

echo ''
echo ''

echo Make the SSH Daemon more secure
# Modify the SSH Daemon configuration but don't enable it yet as we'll be locked out if the SSH port has changed
ssh root@"${server_ip}" "bash -s" -- < ./src/ssh_daemon.sh "$USER" "${new_password}" "${remote_shell}" "${ssh_port}"

echo ''
echo ''

echo Enable changes to the firewall and SSH Daemon
# After this command is executed, root can no longer ssh and the new ssh_port (if changed) is active
ssh root@"${server_ip}" 'service ssh restart; ufw --force enable; ufw status'


if [[ "${remote_shell}" == 'zsh' ]]; then

   ssh -p"${ssh_port}" $USER@"${server_ip}" "bash -s" -- < ./src/oh-my-zsh-install.sh "$USER" "${new_password}" "${remote_shell}" "${ssh_port}"

fi


