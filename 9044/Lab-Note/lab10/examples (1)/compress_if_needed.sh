#!/bin/sh

# for i in "$@"
# do
#     xz -z -k $i
#     data=`ls -l $i | awk '{print $5}'`
#     data_xz=`ls -l $i.xz | awk '{print $5}'`
#     if [ $data -ge $data_xz ]
#     then
#         echo $i $data bytes, compresses to $data_xz bytes, compressed
#         rm $i
#     else
#         echo $i $data bytes, compresses to $data_xz bytes, left uncompressed
#         rm $i.xz
#     fi 
# done

for i in `ls ./$1/*`
do
    if echo $i | egrep "Make"
    then
        path = $i
        make
        # continue
    fi
done

# for i in "$@"
# do
#     data=`curl -I ne $i 2>/dev/null| egrep -i ^server | cut -d ":" -f2`
#     echo "$i$data" 
# done