#!/bin/sh

#test shrug-rm[--force]

echo The First Text>a
./shrug-init>>test0
./shrug-add a>>test0
./shrug-commit -m "The First Commit">>test0
./shrug-rm a>>test0
echo The First Text>a
./shrug-rm a>>test0
./shrug-add a>>test0
./shrug-commit -m "The First Commit">>test0
echo add a line>>a
./shrug-add a>>test0
./shrug-rm a>>test0

echo The Second Text>aa
./shrug-add aa>>test0
./shrug-commit -m "The Second Commit">>test0
./shrug-rm aa>>test0
./shrug-add aa>>test0
echo add a line>>aa
./shrug-add aa>>test0
echo add a line>>aa
./shrug-rm aa>>test0

echo "Initialized empty shrug repository in .shrug">test00
echo "Committed as commit 0">>test00
echo "shrug-rm: error: 'a' is not in the shrug repository">>test00
echo "nothing to commit">>test00
echo "shrug-rm: error: 'a' has changes staged in the index">>test00
echo "Committed as commit 1">>test00
echo "shrug-add: error: can not open 'aa'">>test00
echo "shrug-rm: error: 'aa' in index is different to both working file and repository">>test00

d=$(diff "test0" "test00")
if [ "$d" == "" ];then
    echo "Test09 passed"
    else
    echo "Test09 failed"
    fi

rm a aa
rm test0 test00
rm -rf .shrug