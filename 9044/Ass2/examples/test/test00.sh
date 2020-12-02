#!/bin/dash

test "$file1" = "$file2" && break 

test "$file1" = "$file2"

for file1 in "$@"
do
    for file2 in "$@"
    do
        if test "$file1" = "$file2"
        then
            echo "$file1 may be a copy of $file2"
        fi
    done
done

repeat_message() {
    n=$1
    message=$2
    for i in 0 $n
    do
        echo "$i: $message"
    done
}

i=0
while test $i -lt 4
do
    repeat_message 3 "hello Andrew"
    i=$((i + 1))
done

