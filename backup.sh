#!/bin/bash

#
# This script automatically creates backup archives for MySQL/MariaDB databases and Wordpress files in
# /var/backups/db and /var/backups/wp.
# Limiting the amount of stored backups to 3 and 5 archives for Wordpress files and databases respectively.
# This script use tar method (.tar.gz) means it first dump the database into a file, archiving the dump into
# .tar.gz file, then deleting the previous dump file. Which is quite inefficient.
#

#DEFINE VARIABLES
DATE=$(date +"%g%m%d_%H%M")
BACKUP_DIR='/var/backups'
DB_BACKUP_NAME=database-$DATE.sql
WP_BACKUP_NAME=wordpress-$DATE.zip
ROOT_DIR='/var/www/html'

MYSQL_HOST='localhost'
MYSQL_PORT='3306'
MYSQL_USER='backup_admin'
MYSQL_PASSWORD='12345'

#CREATE FUNCTION FOR LIMITING AMOUNT OF BACKUPS STORED
LIMIT_BACKUP () {
  if [ $(ls $BACKUP_DIR/$1 | wc -l) -gt $2 ]
  then
    rm -f $BACKUP_DIR/$1/$(ls $BACKUP_DIR/$1 --sort=time | tail -1)
  fi
}

#CREATE BACKUPS DIRECTORY
if  [ ! -f $BACKUP_DIR/db ]
then
  mkdir -p $BACKUP_DIR/db && mkdir -p $BACKUP_DIR/wp
fi

#DUMP & ARCHIVE MARIADB DATABASE
mysqldump -h $MYSQL_HOST \
          -P $MYSQL_PORT \
          -u $MYSQL_USER \
          -p$MYSQL_PASSWORD --all-databases > $DB_BACKUP_NAME
tar czf $BACKUP_DIR/db/$DB_BACKUP_NAME.tar.gz $DB_BACKUP_NAME
rm -f $DB_BACKUP_NAME

#ARCHIVE WORDPRESS FILES
cd $ROOT_DIR
zip -rqq  $BACKUP_DIR/wp/$WP_BACKUP_NAME ./wordpress

LIMIT_BACKUP db 5
LIMIT_BACKUP wp 3