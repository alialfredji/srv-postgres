# Postgres Database on EC2

**NOTE:** This service needs a static ip.

**NOTE:** Activate termination protection on the EC2!!!

## Install Docker:
[Get Docker CE for Ubuntu | Docker Documentation](https://docs.docker.com/install/linux/docker-ce/ubuntu/)


```
# Docker
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

sudo gpasswd -a $USER docker

newgrp docker

sudo docker run hello-world

sudo usermod -aG docker ubuntu
```


## Install Docker Compose:
[From Docker docs](https://docs.docker.com/compose/install/)

```
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose
```


## Install HumbleCLI:

```
git clone https://github.com/marcopeg/humble-cli.git /home/ubuntu/.humble-cli
sudo ln -s /home/ubuntu/.humble-cli/bin/humble.sh /usr/local/bin/humble
```

## Install Make:

```
sudo apt install make
```


## EBS Data Volume:

From the volumes console, choose the data volume -> actions -> attach volume.
Choose the EC2 instance and accept "/dev/sdf"

Mount disk:
[Making an Amazon EBS Volume Available for Use on Linux - Amazon Elastic Compute Cloud](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-using-volumes.html)

```
lsblk

# "nvme1n1" could change
sudo file -s /dev/nvme1n1

# IF {previous command} show "data"
sudo mkfs -t xfs /dev/nvme1n1

sudo mkdir /docker-data

sudo mount /dev/nvme1n1 /docker-data
```

Automatic re-mount on reboot:

```
# make a copy of the automount file
sudo cp /etc/fstab /etc/fstab.orig

# find the UUID of "nvm1n1"
sudo blkid

sudo vim /etc/fstab

#> UUID=71a60a03-806e-4afb-b0ca-defab857f79b  /docker-data  xfs  defaults,nofail  0  2
```

**IMPORTANT:** set the automatic snapshot!!!


## Login Docker Deploy User

```
ssh-keygen -t rsa -b 4096 -C "your@email.se"

# copy it to your git account ssh keys
cat ~/.ssh/id_rsa.pub

# test
ssh -T git@github.com
```


## Clone repo

```
git clone git@github.com:alialfredji/srv-postgres.git
cd srv-postgres
```

and create `.env.local` with custom passwords, see what is commented out in `.env`.

    HUMBLE_ENV=prod


## Restore Backup

1. import a backup file with Cyberduck or scp
2. move the file in `/docker-data/backup`
3. `humble pg-restore {file-name-no-sql}`
4. `humble up -d` to restart the backups


## Resize EBS Volume

From the console, edit the volume to the new desired size.

```
# check the proper volume and make sure that the new size is visible
sudo lsblk

# check the old data, should show the old size
df -h

# grow the partition
sudo xfs_growfs -d /docker-data

# check it out again
df -h
```


