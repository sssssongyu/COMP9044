#!/bin/dash

pwd
ls
id
date
ls -l /dev/null

a=hello
b=world
echo $a $b

start=$1
finish=$2

number=$start
while test $number -lt $finish
do
    echo $number
    number=`expr $number + 1`
done