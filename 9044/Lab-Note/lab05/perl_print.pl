#!/usr/bin/perl -w

for ($i=0;$i<10;$i++)
{
print "$i\n";
if ($i == 5)
{
next;
}
print "hihi\n";
}
