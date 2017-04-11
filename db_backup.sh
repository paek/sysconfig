#!/bin/bash
                                                                                                                                                                                               
# Backup data base directory.
backup_dir="/backup"
curdate=`date +"%Y%m%d"`
newcurdate=`date +"%Y%m%d%H%M%S"`

DB_USER="아이디"
DB_PASSWORD="패스워드"
DB_SOCK="/var/lib/mysql/mysql.sock"

## backup Directory check. and directory create.
if [ ! -d "$backup_dir/$curdate" ];
then
    mkdir -p "$backup_dir/$curdate"
fi

## Backup temp directory file delete.
rm -f $backup_dir/*.sql

#################################################################################################################
# DATABASE listing and db table dump process.

db_list=`mysql -u${DB_USER} -p${DB_PASSWORD} -S${DB_SOCK} -e "show databases" | tail -n+2`;

for db_name in $db_list;
do
    for db in $db_name
    do
        echo "=== $backup_dir/$curdate/$db";

        if [ ! -d "$backup_dir/$curdate/$db" ]; then
            mkdir -p "$backup_dir/$curdate/$db"
        fi

        TABLE_LIST=`mysql -u${DB_USER} -p${DB_PASSWORD} -S${DB_SOCK} $db -e "SHOW TABLES" | tail -n+2`;
        for TABLE in $TABLE_LIST;
        do
            echo "---- $db [ $TABLE ] ";
                mysqldump --extended-insert=0 -u${DB_USER} -p${DB_PASSWORD} -S${DB_SOCK} $db $TABLE > $backup_dir/$curdate/$db/$TABLE.sql
            done
        done
done
