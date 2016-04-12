MySQL Replication
====
A simple docker file to setup mysql databases with both master and slave ones.

### Description
You can use this Docker file to setup a local development environment with master-slave MySQL databases architecture. Currently it supports only one master and one slave database in the wrapped `start_servers.sh` shell script, but it is possible to expand more slave through running command shown in that script.

### Getting Started
0. Ensure you have installed docker correctly, if not or do not know how to do this, you should read [official installation documents](http://docs.docker.com/mac/started/);

Then, you have two different ways to run containers, one is to build the image by yourself, while the other one is to pull the image through docker hub directly.

#### Build The Image By Yourself
1. Pull this repository to one of whatever directory whatever you like:
  ```sh
  cd /any/directory/you/want/to/work/on
  git clone git@github.com:Martin91/mysql-replication.git
  ```

2. Build the image:
  ```sh
  cd mysql-replication
  docker build -t "any-docker-image-name-you-like" .
  ```

3. After waiting a long time to finishing update apt and install mysql automatically, you can setup two containers now:
  ```sh
  chmod +x start_servers.sh
  ./start_servers.sh
  ```

#### Pull From Docker Hub (the latest image currently only contains mysql-server-5.5, if you need a newer version 5.6, use the above way insteadly)
```sh
docker pull martin91/mysql_server
docker run --name=mysql_master -p 3306 -e master_role=true -d martin91/mysql_server
# Wait about 5 seconds before run the below command
docker run --name=mysql_slave --link=mysql_master -p 3306 -e slave_role=true -d martin91/mysql_server
```

### Connect Servers Locally
```sh
docker-machine ip  # record your vm's ip address here
docker ps          # record ports of containers related to mysql
mysql -uroot -h{vm's ip address} -P{containers binded port on the vm}
```

### ATTENTIONS!
It is strongly recommended to setup these containers ONLY under development, test or staging evironments. Use it for production environment is VERY DANGEROUS. Instead, if you are looking for a safe and reliable image, you should checkout to MySQL official image: [official: mysql](https://hub.docker.com/_/mysql/).

### TODO
More flexible commands based on environment variables, includes:

* mount file dir as persisted data dir
* multiple master
* slave servers count
* explicitly specify ports binding
* database users and passwords
* refactor based on docker-compose
* etc...
