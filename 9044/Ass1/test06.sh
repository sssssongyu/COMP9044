#!/bin/sh

#test shrug-commit[-a]

echo The First Text>a
echo The Second Text>aa

./shrug-init>>test0
./shrug-add a aa >>test0
./shrug-commit -m "The First Commit">>test0
echo Add one line>>aa
./shrug-commit -a -m "The Second Commit">>test0
./shrug-commit -m "The Second Commit">>test0

echo "Initialized empty shrug repository in .shrug">test00
echo "Committed as commit 0">>test00
echo "Committed as commit 1">>test00
echo "nothing to commit">>test00

d=$(diff "test0" "test00")
if [ "$d" == "" ];then
    echo "Test06 passed"
    else
    echo "Test06 failed"
    fi

rm a aa
rm test0 test00
rm -rf .shrug