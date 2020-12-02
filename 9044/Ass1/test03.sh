#!/bin/sh

#test index(0) current(1)/current(0)
#a:index(0) current(1) commit
#aa:index(0) current(0) commit(1)
#aaa:index(0) current(0) commit(0)

echo The First Text>a
echo The Second Text>aa
./shrug-init>>test0
./shrug-add aa >>test0
./shrug-commit -m "The First Commit">>test0
./shrug-rm --force aa >>test0
./shrug-status>>test0

echo "Initialized empty shrug repository in .shrug">test00
echo "Committed as commit 0">>test00
echo "a - untracked">>test00
echo "aa - deleted">>test00

head -4 test0>test1
d=$(diff "test1" "test00")
if [ "$d" == "" ];then
    echo "Test03 passed"
    else
    echo "Test03 failed"
    fi

rm a
rm test0 test1 test00
rm -rf .shrug