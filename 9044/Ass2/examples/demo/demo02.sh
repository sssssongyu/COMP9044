#!/bin/dash

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

i=0
j=1
while test $i -lt 4
do
    echo "Hello World!$j"
    i=$((i + 1))
done
