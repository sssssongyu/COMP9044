#!/bin/bash

for argument in $*
do
    echo $argument
done

if test $# = 0
then
    echo "Usage $0: files"
    exit 1
fi

for filename in "$@"
do
    newfilename=$filename
    if test -r "$newfilename"
    then
        echo "$0: $newfilename exists" 
    elif test -e "$filename"
    then
        echo "$0: $filename exists"
    fi
done