# Docker for Peakaboo

Install `docker` and `docker-compose`:

```shell
# centos
yum install docker-io
pip install docker-compose

# arch
pacaur -S docker docker-compose

# ubuntu (untested)
wget -qO- https://get.docker.com/ | sh
pip install docker-composer
```

Put `my.crt` and `my.key` and `.htaccess` for the galicaster user into `nginx/`

From this directory, run:

```shell
export SERVER_NAME=peakaboo.uscs.susx.ac.uk
docker-compose up
```

To rebuild the peakaboo image run:

```shell
docker-compose build peakaboo
```
