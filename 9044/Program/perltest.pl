#!/usr/bin/perl -w

$list=10;

if ($#ARGV<0)
{
@content=<STDIN>;
if ($#content+1>$list)
{
for ($i=$#content+1-$list;$i<$#content+1;$i++)
{
print "$content[$i]";
}
}
else
{for ($i=0;$i<$#content+1;$i++)
{
print "$content[$i]";
}
}
}

else
{
foreach $arg (@ARGV) {
if ($arg eq "--version") {
print "$0: version 0.1\n";
exit 0;
}
elsif  ($arg =~ /^-[0-9]*$/)
{
$list=$ARGV[0];
$list=~ s/-//;
}
else {
push @files, $arg;
}
}

foreach $file(@files)
{
open $file, '<', $file or die "$0: Can't open $file: $!\n";
if (@files!=1)
{
print "==> $file <==\n";
}
@content=();
while($answer=<$file>)
{
push @content,$answer;
}
    close $file;
if ($#content+1>$list)
{
for ($i=$#content+1-$list;$i<$#content+1;$i++)
{
print "$content[$i]";
}
}
else
{for ($i=0;$i<$#content+1;$i++)
{
print "$content[$i]";
}
}
}
}
