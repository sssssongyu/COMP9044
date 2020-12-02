#!/bin/dash

echo You should enter at least 4 characters
echo I have $# arguments
echo My arguments separately are $*
echo My arguments together are "$@"
echo My 5th argument is "'$5'"

number=$1
while true
do
    echo $number
    number=$((number + 1))
    if test $number -eq 3
    then
    echo IM DOWN!
    echo Hi "'$4'"
    echo Hi '$4'
    echo Hi "$4"
    exit 0
    fi
done
