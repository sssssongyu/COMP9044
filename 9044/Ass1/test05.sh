#!/bin/sh

#test shrug-commit shrug-log
#incorrect form

./shrug-commit>>test0
./shrug-commit a>>test0
./shrug-commit -m>>test0
./shrug-commit -m abc>>test0

echo The First Text>a
echo The Second Text>aa
echo The Third Text>aaa

./shrug-init>>test0
./shrug-add a aa>>test0
./shrug-commit -m "first commit" >> test0
./shrug-commit -m "first commit" >> test0
./shrug-add a aa aaa>>test0
./shrug-commit -m "second commit" >> test0
./shrug-log>>test0

echo "usage: shrug-commit [-a] -m commit-message">test00
echo "usage: shrug-commit [-a] -m commit-message">>test00
echo "usage: shrug-commit [-a] -m commit-message">>test00
echo "nothing to commit">>test00
echo "Initialized empty shrug repository in .shrug">>test00
echo "Committed as commit 0">>test00
echo "nothing to commit">>test00
echo "Committed as commit 1">>test00
echo "1 second commit">>test00
echo "0 first commit">>test00

d=$(diff "test0" "test00")
if [ "$d" == "" ];then
    echo "Test05 passed"
    else
    echo "Test05 failed"
    fi

rm a aa aaa
rm test0 test00
rm -rf .shrug