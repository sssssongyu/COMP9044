#!/bin/sh

#test index=current!=commit
#a:commit change
#b:commit 0 change
#c:0 commit
echo The First Text>a
echo The Second Text>aa
echo The Third Text>aaa
./shrug-init>>test0
./shrug-add a aa >>test0
./shrug-commit -m "The First Commit">>test0
echo Add one line>>aa
./shrug-add a aa aaa>>test0
# ./shrug-commit -m "The First Commit">>test0
./shrug-status >>test0

echo "Initialized empty shrug repository in .shrug">test00
echo "Committed as commit 0">>test00
echo "a - same as repo">>test00
echo "aa - file changed, changes staged for commit">>test00
echo "aaa - added to index">>test00

head -5 test0>test1
d=$(diff "test1" "test00")
if [ "$d" == "" ];then
    echo "Test00 passed"
    else
    echo "Test00 failed"
    fi

rm a aa aaa
rm test0 test1 test00
rm -rf .shrug




