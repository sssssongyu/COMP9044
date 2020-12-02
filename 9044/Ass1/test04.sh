#!/bin/sh

#test shrug-init shrug-add
#no int add
#int no file add
#int again
#int no all file add

./shrug-add a>>test0
./shrug-init>>test0
./shrug-add a>>test0
echo The First Text>a
./shrug-init>>test0
./shrug-add a b>>test0
./shrug-add a>>test0

echo "shrug-add: error: no .shrug directory containing shrug repository exists">test00
echo "Initialized empty shrug repository in .shrug">>test00
echo "shrug-add: error: can not open 'a'">>test00
echo "shrug-init: error: .shrug already exists">>test00
echo "shrug-add: error: can not open 'b'">>test00

d=$(diff "test0" "test00")
if [ "$d" == "" ];then
    echo "Test04 passed"
    else
    echo "Test04 failed"
    fi

rm a
rm test0 test00
rm -rf .shrug

