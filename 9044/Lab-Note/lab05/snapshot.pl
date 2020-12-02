#!/usr/bin/perl -w
use File::Copy;

$i=0;

while(-e ".snapshot.$i"){
$i++;
}
mkdir ".snapshot.$i";

@files= glob "*";

foreach $file(@files)
{
if ($file ne "snapshot.pl")
{
copy("$file",".snapshot.$i/$file");
if ($#ARGV==1)
{
copy(".snapshot.$ARGV[1]/$file","$file");
}
}
}

print "Creating snapshot $i\n";
if ($#ARGV==1)
{
print "Restoring snapshot $ARGV[1]\n";
}
