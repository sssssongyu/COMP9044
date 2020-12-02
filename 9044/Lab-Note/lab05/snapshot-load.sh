#!/bin/dash

i=0
f=.snapshot
while true
do
if [ -d "$f.$i" ]
then i=$((i+1))
else
mkdir $f.$i
echo "Creating snapshot $i"
break
fi
done

for file in *
do
if [ "$file" = "snapshot-save.sh" ]
then
continue
elif [ "$file" = "snapshot-load.sh" ]
then
continue
else
cp "$file" '.snapshot.'$i'/'$file''
cp '.snapshot.'$1'/'$file'' '$file'
fi
done
echo "Restoring snapshot $1"
