#!/usr/bin/perl -w

$n = $ARGV[0];
foreach $file (glob("examples/$n/*.sh")) {
    $filename = $1 if $file =~ "examples/$n/(.*).sh";
    printf "testing subset $n $filename\n";
    system "./sheeple.pl < $file > $filename.pl";
    system "chmod 755 $filename.pl; ./$filename.pl > perl.out";
    system "chmod 755 $file; ./$file > shell.out";
    $result = system "diff perl.out shell.out > /dev/null";
    system "rm $filename.pl perl.out shell.out";
    next if $result == 0 && print "OK!!\n";
    print "!!EMERGENCY: Do not leave your bugs till next day!!\n";
}