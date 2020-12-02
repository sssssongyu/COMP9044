#!/bin/dash

i=0
dirname=$i

while test -d $dirname
do
	i=$(expr $i + 1)
	dirname=$i
done

echo $dirname

echo Creating snapshot $i
for file in *
do 
	if [ "$file" != "snapshot-save.sh" ] && [ "$file" != "snapshot-load.sh" ]
	then 
		echo $file
	fi
done
