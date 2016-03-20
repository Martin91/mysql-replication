docker run --name=mysql_master -p 3306 -e master_role=true -d martin91/mysql_server
sleep 5
docker run --name=mysql_slave --link=mysql_master -p 3306 -e slave_role=true -d martin91/mysql_server