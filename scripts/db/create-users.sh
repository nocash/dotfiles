#!/bin/bash

mysql -u root \
  -e "CREATE USER 'monty'@'localhost' IDENTIFIED BY 'some_pass';" \
  -e "GRANT ALL PRIVILEGES ON *.* TO 'monty'@'localhost' WITH GRANT OPTION;" \
  -e "CREATE USER 'saint_augustine'@'localhost' IDENTIFIED BY 'thesinofadam';" \
  -e "GRANT ALL PRIVILEGES ON *.* TO 'saint_augustine'@'localhost' WITH GRANT OPTION;"
