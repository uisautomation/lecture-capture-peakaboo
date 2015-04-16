# Docker for Peakaboo

Install `docker` and `docker-compose`:

```shell
# centos 6.5
sudo yum install docker-io
sudo pip install docker-compose
sudo service docker start
sudo chkconfig docker on

# arch
pacaur -S docker docker-compose
sudo systemctl start docker
sudo systemctl enable docker

# ubuntu (untested)
wget -qO- https://get.docker.com/ | sh
sudo pip install docker-compose
```

Put `my.crt` and `my.key` and `.htpasswd` for the galicaster user into `nginx/`

From the .docker directory, run:

```shell
export SERVER_NAME=peakaboo.uscs.susx.ac.uk
docker-compose up
```

To rebuild the peakaboo image run:

```shell
docker-compose build peakaboo
```
