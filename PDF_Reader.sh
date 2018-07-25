#!/bin/bash

function findpdfs()
{
for i in $(find . -iname 'εχαμπλε.pdf')
  do
  pdftotext -enc Latin1 "$i" - | grep --color=always -i $1
done
}


str2="q"
until [ "$varname" == "$str2"  ]; do
    echo 'What name to search?'
    read varname

    if [ "$varname" == "$str2" ]; then
    	echo 'The script will terminate'
        exit
    
    else
        findpdfs $varname
    fi
done
