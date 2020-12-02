#!/usr/bin/perl -w

## 需不需要判断是不是 #!/bin/dash shell文件
## 如果有输入
## read file 
if (@ARGV!=0)
{
    open $f,'<',$ARGV[0] or die;
    while ($content=<$f>)
    {
        ## subset 0 / echo = $ #
        if ($content =~ /(.*)\$(\d+)(.*)/g)
        {
            $num=$2-1;
            $content = "$1\$ARGV[$num]$3";
        }
        if ($content =~ /^#!\/bin\/dash$/g)
        {
            print "#!/usr/bin/perl -w\n";
        }
        if ($content =~ /^\s*echo/g)  ###############
        {
            # print "hihihi:\n";
            if ($content =~ /\'/g){ ## subset 2 '
                $content=~ s/\'//g;
            }
            $content=~ /^(\s*)echo (.+)$/g;
            print "$1print \"$2\n\";\n";
        }
        elsif ($content =~ /^(pwd.*)\n/g || $content =~ /^(ls.*)\n/g || $content =~ /^(id.*)\n/g || $content =~ /^(date.*)\n/g)
        {
            print "system \"$1\";\n";
        }
        elsif ($content =~ /^\s*[^(el)*if](.*)=(.*)$/g) #排除 if的情况
        {
            print "\$$1 = \'$2\';\n";
        }

        ## subet 1 / ? * [] for do done exit read cd
        elsif ($content =~ /^\s*cd (.*)/g)
        {
            print "chdir \'$1\';\n"
        }
        elsif ($content =~ /^\s*for (.*) in (.*)/g )
        {
            $data=$2;
            $for_str="foreach \$$1 (";
            if ($data =~ /.* .*/g) #string
            {
                # print $data;
                @string_array= split(' ',$data);
                foreach $i(@string_array)
                {
                    if ($i =~ /d+/g)
                    {
                        $for_str.= "$i";
                    }
                    else{
                        $for_str.= "\'$i\'";
                    }
                }
                $for_str.= ")\n";
                $for_str=~ s/\'\'/\'\,\'/g;
            }
            elsif ($data =~ /\*/g) #file
            {
                $for_str.="glob(\"$data\")";
                $for_str.=")\n";
            }
            print "$for_str";
        }
        elsif ($content=~ /^\s*do$/g)
        {
            print "{\n";
        }
        elsif ($content=~ /^\s*done$/g){
            print "}\n";
        }
        elsif ($content =~ /^\s*read (.*)/g){
            print "\$$1 = <STDIN>;\nchomp \$$1;\n";

        }
        elsif ($content=~ /^\n$/g){
            print "\n";
        }
        elsif ($content =~ /^(\s*)exit(.*)/g){
            print "$1exit$2;\n";
        }
        # else
        # {
        #     print "$content;\n";
        # }
        #subset 2 / if elif
        if ($content =~ /^\s*if/g )
        {
            $new_content = $content;
            if ($new_content =~ /elif/g)
            {
                $if_str="}elsif (";
            }
            else{
                $if_str="if (";}
            if ($content =~ /test (.*)$/g)
            {
                $data=$1;
                @string_array=split('\s+',$data);
                foreach $i(@string_array)
                {
                    $if_str.="\'$i\'";
                }
                $if_str.=")\n";
                $if_str=~ s/\'=\'/ eq /g;
            }
            print "$if_str";
        }
        elsif ($content =~ /^\s*then/g)
        {
            print "{\n";
        }
        elsif ($content =~ /^\s*else/g)
        {
            print "}else{\n";
        }
        elsif($content =~ /^\s*fi$/g)
        {
            print "}\n";
        }
 




    }

}

## subset 1

## subset 2

## subset 3

## subset 4

