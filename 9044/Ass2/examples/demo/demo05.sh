#!/bin/dash

echo casetest 
char=$1
case $char in
    [a-zA-Z]) echo "\nletter\n" ;;
    [0-9]) echo "\nDigit\n" ;;
    [0-9]) echo "\nDigit\n" ;;
    [,.?!]) echo "\nPunctuation\n" ;;
    *) echo "\nerror\n" ;;
esac
