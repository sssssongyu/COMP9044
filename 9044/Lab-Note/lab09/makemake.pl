#!/usr/bin/perl -w

@files_c=glob("*.c");
$time=localtime(time);
print "# Makefile generated at $time\n";
print "\n";
print "CC = gcc\n";
print "CFLAGS = -Wall -g\n";
print "\n";

@fiii=@files_c;
foreach $file(@files_c)
{
    if ($file =~ /(.*main).*/g)
    {   
        print "$1: $1.o";
        $main_fn=$1;
        foreach $i(@fiii)
        {   

            if ($i ne "$main_fn.c"){
                $i=~ s/(\w+).c//g;
                print " $1.o";
                push @main_f, $1;
            }
        }
        print "\n";
        print "\t\$(CC) \$(CFLAGS) -o \$\@";
        print " $main_fn.o";
        foreach $i(@main_f)
        {
            print " $i.o";
        }
        print "\n\n";
    }

    else{
        $file=~ /(\w*).*/g;
        $file_name=$1;
        $string="";
        open $f, '<', $file or die;
        while($content=<$f>) 
        {
            if($content=~ /#include.*"(\w*.+)"/g){
                push @f_h, $1;
            }
        }
        while(@f_h!=0){
            $save=0;
            $current=shift(@f_h);
            
            foreach $ii(@savef_h){
                if ($current eq $ii){
                    $save=1;
                }
            }
            if ($save!=1){
                open $ff, '<', $current or die;
                push @savef_h,$current;
                $save=0;
                while($content=<$ff>)
                {
                    if ($content=~ /#include.*"(\w*.+)"/g)
                    {
                        foreach $i(@savef_h)
                        {
                            if ($i eq $1)
                            {
                                $save=1;
                            }
                        }
                        if ($save != 1)
                        {
                            push @f_h,$1;
                        }
                        $save=0;
                    }
                }
                close $ff;
            }
        }
        foreach $j(@savef_h)
        {
            $string.=" $j";
        }
        @savef_h=();
        $data{$file_name}=$string;
        close $f;
    }
}
@keys=keys%data;
foreach $i(@keys)
{
    print "$i.o:$data{$i} $i.c\n";
}
print "$main_fn.o:";
foreach $i(@main_f)
{
    print " $i.h";
}
print " $main_fn.c";
print "\n";
