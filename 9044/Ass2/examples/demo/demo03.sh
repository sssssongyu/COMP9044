#!/bin/dash

pwd
ls
id
date
ls -l /dev/null

i=0
dirname=$i

echo $dirname

echo Creating snapshot $i
for file in *
do 
	if [ "$file" != "snapshot-save.sh" ] && [ "$file" != "snapshot-load.sh" ]
	then 
		echo $file
	fi
done
