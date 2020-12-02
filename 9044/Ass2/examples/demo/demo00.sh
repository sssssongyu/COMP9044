#!/bin/dash

if test $# = 1
then
    start=1
    finish=$1
elif test $# = 2
then
    start=$1
    finish=$2
else
    echo "hello world\n"
    exit 1
fi

for argument in "$@"
do
    # clumsy way to check if argument is a valid integer
    if $# = 1
    then
        echo "$0: argument '$argument' is not an integer"
        exit 1
    fi
done

number=$start
while test $number -le $finish
do
    echo $number
    number=`expr $number + 1`    # or number=$(($number + 1))
done