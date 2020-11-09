#!/bin/bash

echo -e "Hi, please type the full path where are the files that you want to delete: " \c
 read path
echo -e "Please type how many days old files you wish ti delete: " \c
read days
if [ $days =  '0' ];then
	echo `find "$path" -type f -exec rm {} \;`

else
    echo `find "$path" -type f -mtime +"$days" -exec rm {} \;`
	
fi