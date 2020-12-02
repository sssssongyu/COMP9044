#!/bin/sh

#test index(1) current(10)
#a:index(1) current(10) commit(11)
#aa:index(1) current(10) commit(10)
#aaa:index(1) current(10) commit(0)
echo The First Text>a
echo The Second Text>aa
echo The Third Text>aaa
./shrug-init>>test0
./shrug-add a aa >>test0
./shrug-commit -m "The First Commit">>test0
echo Add one line>>aa
./shrug-add a aa aaa>>test0
echo Add two line>>a
echo Add two line>>aa
echo Add two line>>aaa

./shrug-status>>test0

echo "Initialized empty shrug repository in .shrug">test00
echo "Committed as commit 0">>test00
echo "a - file changed, changes not staged for commit">>test00
echo "aa - file changed, different changes staged for commit">>test00
echo "aaa - added to index, file changed">>test00

head -5 test0>test1
d=$(diff "test1" "test00")
if [ "$d" == "" ];then
    echo "Test01 passed"
    else
    echo "Test01 failed"
    fi
    
rm test0 test1 test00
rm -rf .shrug
