#!/bin/sh

#test shrug-show
echo The First Text>a

./shrug-show a>>test0
./shrug-init>>test0
./shrug-show a>>test0
./shrug-add a>>test0
./shrug-show :a>>test0
./shrug-show 1:a>>test0
./shrug-show a:a>>test0
./shrug-commit -m "The First Commit">>test0
./shrug-show 0:a>>test0
echo Add one line>>a
./shrug-commit -a -m "The Second Commit">>test0
./shrug-show 1:a>>test0

echo "shrug-show: error: no .shrug directory containing shrug repository exists">test00
echo "Initialized empty shrug repository in .shrug">>test00
echo "shrug-show: error: invalid object a">>test00
echo "The First Text">>test00
echo "shrug-show: error: unknown commit '1'">>test00
echo "shrug-show: error: unknown commit 'a'">>test00
echo "Committed as commit 0">>test00
echo "The First Text">>test00
echo "Committed as commit 1">>test00
echo "The First Text">>test00
echo "Add one line">>test00

d=$(diff "test0" "test00")
if [ "$d" == "" ];then
    echo "Test07 passed"
    else
    echo "Test07 failed"
    fi

rm a
rm test0 test00
rm -rf .shrug