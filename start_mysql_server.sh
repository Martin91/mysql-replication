#! /bin/bash

touch $mysql_config_file

echo "[mysqld]" >> $mysql_config_file
echo "bind-address = 0.0.0.0" >> $mysql_config_file

if [ -n "$master_role" ] && $master_role == true
then
  echo "config mysql server as a master db"
  echo "log-bin=/var/lib/mysql/binlog" >> $mysql_config_file
  echo "server-id=1" >> $mysql_config_file
fi

/etc/init.d/mysql start
mysql -e "grant all privileges on *.* to 'root'@'%' identified by '';"
mysql -e "grant all privileges on *.* to 'root'@'localhost' identified by '';"

if [ -n "$slave_role" ] && $slave_role == true
then
  /etc/init.d/mysql stop
  echo "server-id=2" >> $mysql_config_file
  /etc/init.d/mysql start

  MASTER_LOG_FILE=`mysql -u root -h mysql_master -e "show master status\G;" | grep -E "File:\s" | sed 's/.*: //'`
  MASTER_LOG_POS=`mysql -u root -h mysql_master -e "show master status\G;" | grep -E "Position:\s" | sed 's/.*: //'`
  echo "MASTER LOG FILE: $MASTER_LOG_FILE"
  echo "MASTER LOG POS: $MASTER_LOG_POS"

  echo "CHANGE MASTER TO MASTER_HOST='mysql_master',MASTER_PORT=3306,MASTER_USER='root',MASTER_LOG_FILE='$MASTER_LOG_FILE',MASTER_LOG_POS=$MASTER_LOG_POS;"
  mysql -u root -e "CHANGE MASTER TO MASTER_HOST='mysql_master',MASTER_PORT=3306,MASTER_USER='root',MASTER_LOG_FILE='$MASTER_LOG_FILE',MASTER_LOG_POS=$MASTER_LOG_POS;"
  mysql -u root -e "slave start;"
fi

/etc/init.d/mysql stop
/usr/bin/mysqld_safe
