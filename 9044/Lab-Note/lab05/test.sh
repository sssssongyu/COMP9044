#!/bin/sh

base_directory="$(dirname $0)"
echo $base_directory

i=0
f=.snapshot
while true
do
if [ -d "$f.$i" ]
then i=$((i+1))
else
mkdir $f.$i
break
fi
done

for file in *
do
if [ -f snapshot-save.sh ]
then 
echo 0
continue
elif [ -f snapshot-load.sh ]
then 
echo 1 
continue
else
echo "its my turn"
fi
echo $file
done
