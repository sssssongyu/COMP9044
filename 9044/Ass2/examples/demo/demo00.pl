#!/usr/bin/perl -w







$i = 0;
$dirname = $i;

print "$dirname
";

print "Creating snapshot $i
";
foreach $file (glob("*"))
{
	if ('"$file" != "snapshot-save.sh" ] and [ "$file"' ne '"snapshot-load.sh"')
	{
		print "$file
";
	}
}
