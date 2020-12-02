#!/bin/sh

#test shrug-rm[--cached][--force]
#--cached
#a index(1) commit(1)
#aa index(1) current(11)
#aaa index(1) current(10)
#aaaa index(1) current(0)

echo The First Text>a
echo The Second Text>aa
echo The Third Text>aaa
echo The Forth Text>aaaa
./shrug-init>>test0
./shrug-rm>>test0
./shrug-add a >>test0
./shrug-rm>>test0
./shrug-commit -m "The First Commit">>test0
./shrug-rm>>test0
./shrug-rm -c>>test0
./shrug-add a aa aaa aaaa>>test0
./shrug-rm --cached a>>test0
./shrug-rm --cached aa>>test0
echo add a line>>aaa
./shrug-rm --cached aaa>>test0
rm aaaa
./shrug-rm --cached aaaa>>test0

echo "Initialized empty shrug repository in .shrug">>test00
echo "shrug-rm: error: your repository does not have any commits yet">>test00
echo "shrug-rm: error: your repository does not have any commits yet">>test00
echo "Committed as commit 0">>test00
echo "usage: shrug-rm [--force] [--cached] <filenames>">>test00
echo "usage: shrug-rm [--force] [--cached] <filenames>">>test00
echo "shrug-rm: error: 'aaa' in index is different to both working file and repository">>test00

d=$(diff "test0" "test00")
if [ "$d" == "" ];then
    echo "Test08 passed"
    else
    echo "Test08 failed"
    fi

rm a aa aaa
rm test0
rm -rf .shrug