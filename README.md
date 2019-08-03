# Postgres Database on EC2

**NOTE:** This service needs a static ip.

**NOTE:** Activate termination protection on the EC2!!!

## Install Docker:
[Get Docker CE for Ubuntu | Docker Documentation](https://docs.docker.com/install/linux/docker-ce/ubuntu/)

```
sudo apt-get update

sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
   
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io

sudo groupadd docker

sudo gpasswd -a $USER docker

newgrp docker

docker run hello-world
```

## Install other needed modules

#### Docker Compose:

[From Docker docs](https://docs.docker.com/compose/install/)

```
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose
```

#### HumbleClI

```
git clone https://github.com/marcopeg/humble-cli.git /home/ubuntu/.humble-cli
sudo ln -s /home/ubuntu/.humble-cli/bin/humble.sh /usr/local/bin/humble

sudo apt-get install make

```

#### MakeCLI

```
sudo apt-get install make
```

#### Npm

```
sudo apt-get install npm
```

## Clone repo

```
git clone https://github.com/alialfredji/srv-postgres.git
cd srv-postgres
```

and create `.env.local` with custom passwords, see what is commented out in `.env`.

## Manage instance volume and run postgres

1. Check if PG disk is initialized
    ````
    make status
    ````
2. Get more info about disk and validate if DISK_PATH is correct in scripts/utils.sh and change it if not
    ````
    make info
    ````
3. Mount disk to /docker-data
    ```
    make mount-disk
    ```
4. Start postgres machine
    ```
    make run-pg
    ```
5. Your pg container should be running now :)

**IMPORTANT:** set the automatic snapshot so you dont lose data or setup a backup container!!!

## Restore Backup

1. import a backup file with Cyberduck or scp
2. move the file in `/docker-data/backup`
3. `humble pg-restore {file-name-no-sql}`
4. `humble up -d` to restart the backups


## Resize EBS Volume

From your cloud console, edit the volume to the new desired size.

* When disk initialization is done, login to machine and run:
    ````
    make info

    make resize-disk
    ````

