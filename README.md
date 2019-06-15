# Basic Secure Server

A command-line script for building a basic secure server on Digital Ocean

## Features

The script configures / installs the following on the remote server:

  * sets the timezone to Vancouver, Canada
  * creates a new user using the currently logged in user
  * sets a password for the new user with a password provided
  * gives new newly created user sudo privilages
  * updates and upgrades all packages
  * installs: ufw, docker, docker-compose, git, curl, zsh, wget, nodejs, npm
  * if zsh is selected as the shell, installs oh-my-zsh and the bullet-train-theme
  * replaces sshd_config with version that:
    * prohibits root logins
    * allows only you access with your public key
    * configures the ssh port selected
  * configures ufw (uncomplicated firewall) to expose only the following ports:
    * 80, 443, 123 and the port used by the ssh daemon


## Usage

1) Clone this repository:

 ```bash
 git clone https://github.com/jonathan-longe/basic-server.git
 ```

2) Login to your Digital Ocean account and create a new virtual server ("droplet").  The remote server must have your public ssh key installed -- for example `~/.ssh/id_rsa.pub

3) Then on a local machine:

```bash
./configure_droplet.sh <IP_ADDRESS_OF_REMOTE_SERVER>
```

4) After the script has finished, ssh from your local machine:
```bash
ssh <IP_ADDRESS_OF_REMOTE_SERVER>
```
If you've used a non-standard port for ssh, use a '-p' parameter like this:

```bash
ssh -p<SSH_PORT> <IP_ADDRESS_OF_REMOTE_SERVER>
```

## Credits

This script borrows heavily from [Bryan Gilbert's excellent instructions](https://github.com/bryan-gilbert/may14/)
