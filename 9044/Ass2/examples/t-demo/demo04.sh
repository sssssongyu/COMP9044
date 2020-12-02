#!/bin/bash

for file in `ls ./`
do
	if test -d $file 
    then
        echo "file exist"
    fi
    if test -d $file/test.sh 
    then
        echo "file not exist"
    fi
done	

