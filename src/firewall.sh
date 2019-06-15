export SSH_PORT=$1

apt-get install -y ufw

ufw default deny incoming
ufw default allow outgoing

# open ssh port
ufw allow $SSH_PORT/tcp

# open http port
ufw allow 80/tcp
ufw allow 443/tcp

# open ntp port : to sync the clock of your machine
ufw allow 123/udp

# turn on firewall
ufw --force enable

# check the status
ufw status

exit

