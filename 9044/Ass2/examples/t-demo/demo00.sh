#!/bin/bash

echo I have $# arguments
echo My arguments separately are $*
echo My arguments together are "$@"
echo My 1th argument is $1

if test $# = 1
then
    start=1
    finish=$1
elif test $# = 2
then
    start=$1
    finish=$2
else
    echo "Usage: $0 start finish"
    exit 1
fi

number=$start
while test $number -le $finish
do
    echo $number
    number=`expr $number + 1`    # or number=$(($number + 1))
done