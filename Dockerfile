FROM ubuntu:14.04
MAINTAINER Martin Hong "hongzeqin@gmail.com"

RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
ADD ./sources.list /etc/apt/sources.list
RUN apt-get -y update && apt-get install -y mysql-server

# Enable remote access (default is localhost only, we change this
# otherwise our database would not be reachable from outside the container)

ENV mysql_config_file /etc/mysql/conf.d/my_override.cnf

ADD ./start_mysql_server.sh /usr/local/bin/start_mysql_server.sh

RUN chmod +x /usr/local/bin/start_mysql_server.sh

EXPOSE 3306

CMD ["/usr/local/bin/start_mysql_server.sh"]
