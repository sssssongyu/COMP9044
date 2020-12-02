#!/bin/dash

sed -e '/master/d' branch > branch1
cp "branch1" "branch"
cat branch | sort