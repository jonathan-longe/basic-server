# Basic Secure Server

A command-line script for building a basic secure server on Digital Ocean

## Features

The script configures / installs the following on the remote server:

  * sets the timezone to Vancouver, Canada
  * creates a new user using your local username with a password you provide
  * gives you sudo privilages
  * updates and upgrades all packages
  * installs: ufw, docker, docker-compose, git, curl, zsh, wget, nodejs, npm
  * installs: oh-my-zsh with the bullet-train-theme
  * replaces sshd_config with version that:
    * prohibits root logins
    * allows only you access with your public key
  * configures ufw (uncomplicated firewall) to expose only the following ports:
    * 80, 443, 22 and 123
  


## Usage

1) Login to your Digital Ocean account and create a new virtual server ("droplet").  The new virtual server must have a public ssh key installed -- the same key that resides at `~/.ssh/id

2) Then on your local machine:

```bash
./configure_droplet.bash <IP_ADDRESS_OF_REMOTE_SERVER>
```

3) After the script has finished, ssh from your local machine:
```bash
ssh <YOUR_USERNAME>@<IP_ADDRESS_OF_REMOTE_SERVER>
```

## Credits

This script borrows heavily from [Bryan Gilbert's excellent instructions](https://github.com/bryan-gilbert/may14/)
