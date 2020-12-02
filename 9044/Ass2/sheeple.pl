#!/usr/bin/perl -w
sub Echo {
    my ($data)=@_;
    # $data=~ s/^echo //g;
    if ($data =~ /^\'(.*)\'(\n*)$/g)
    {
        $data="$1$2";
    }
    elsif ($data =~ /^\"(.*)\"(\n*)$/g)
    {
        $data="$1$2";
    }
    $data=~ s/\'/\\\'/g;
    $data=~ s/\"/\\\"/g;
    return $data;
}

sub Equal{
    my ($data)=@_;
    $data=~ /(.*)=(.*)$/g;
    my $first=$1;
    my $second=$2;
    my $f_data="";
    if($first=~/\$/g)
    {
        $f_data="$first =";
    }
    else{
        $f_data="\$$first =";
    }
    if ($second=~/^\d+$/g || $second=~ /^\$/g)
    {
        $f_data="$f_data $second;";
    }
    else{
        $f_data="$f_data \'$second\';";
    }
    return $f_data
}

sub If{
    my ($data)=@_;
    my $if_str="";
    my $new_content = $data;
    if ($new_content =~ /^elif/g){
        $if_str="}elsif ";
    }
    else{
        $if_str="if ";}
    if ($data =~ /test (.*)$/g)
    {
        $add_str=Test($1);
        $if_str="$if_str$add_str";
    }
    if ($data =~ /(-[a-z]) (.*) /g)
    {
        $if_str="$if_str($1 \'$2\')";
    }
    return $if_str;
}

sub Test{
    my ($con)=@_;
    if ($con =~ /(.*) -eq (.*)/g)
    {
        return "($1 == $2)";
    }
    elsif ($con =~ /(.*) -ne (.*)/g)
    {
        return "($1 != $2)";
    }
    elsif ($con =~ /(.*) -gt (.*)/g)
    {
        return "($1 > $2)";
    }
    elsif ($con =~ /(.*) -ge (.*)/g)
    {
        return "($1 >= $2)";
    }
    elsif ($con =~ /(.*) -lt (.*)/g)
    {
        return "($1 < $2)";
    }
    elsif ($con =~ /(.*) -le (.*)/g)
    {
        return "($1 <= $2)";
    }
    elsif ($con =~ /(.*) = (.*)/g)
    {
        return "(\'$1\' eq \'$2\')";
    }
    elsif ($con =~ /(.*) != (.*)/g)
    {
        return "(\'$1\' ne \'$2\')";
    }
    elsif ($con =~ /(-[a-z]) (.*)/g)
    {
        return "($1 \'$2\')";
    }   
}

sub While{
    my ($data) = @_;
    if ($data=~ /^test (.*)/g)
    {
        $w_str=Test($1);
        return $w_str;
    }

}

if (@ARGV!=0)
{
    open $f,'<',$ARGV[0] or die;
    while ($content=<$f>)
    {
        $add="";
        $f_result="";
        if ($content =~ /^#!\/bin\/dash$/g) ##first line 
        {
            print "#!/usr/bin/perl -w\n";
            next;
        }
        if ($content=~ /^\n$/g){
            print "\n";
            next;
        }
        if ($content=~ /^(\s+)/g)  ##get the empty space
        {
            $empty=$1;
            print "$empty";
            $content =~ s/^(\s+)//g;
        }
        if ($content =~ /\S*(\s*\#.*)$/g)
        {
            $add=$1;
            $content =~ s/$1//g;
        }
        if ($content =~ /(.*)\$(\d+)(.*)/g)  ## $1 to $ARGV[0]
        {
            $num=$2-1;
            $content = "$1\$ARGV[$num]$3\n";
        }
        if ($content =~ /(.*)\"\$\@\"(.*)/g)
        {
            $content ="$1\@ARGV$2\n";
        }
        if ($content =~ /^(.*)\`(.*)\`(.*)$/g)  ## subset 3 / ` ` expr
        {
            $content="$1$2$3";
        }
        if ($content =~ /^(.*)expr (.*)$/g)
        {
            $content ="$1$2";
        }
        if ($content =~ /(.*)\(\((.*)\)\)(.*)/g)
        {
            $content = "$1$2$3";
        }
        if ($content =~ /echo (.*\n*)$/g)  ## subset 0 / echo = $ #
        {
            
            $echo_d=Echo($1);
            $f_result.="print \"$echo_d\"";
            # print "print 11111\"$echo_d\";";
            # $f_result.=$content;
            # print "$f_result";
        }
        elsif ($content =~ /^(pwd.*)\n/g || $content =~ /^(ls.*)\n/g || $content =~ /^(id.*)\n/g || $content =~ /^(date.*)\n/g)
        {
            $f_result.="system \"$1\";";
            # print "$f_result";
        }
        elsif ($content =~ /^(el)*if/g) ## subset 2 / if elif $$$$$$
        {
            $if_data=If($content);
            $f_result.="$if_data";
        }
        elsif ($content =~ /^(.*)=(.*)$/g) ##[^(e)*(i)]
        {
            $equal_d=Equal($content);
            $f_result.="$equal_d";
        }
        elsif ($content =~ /^cd (.*)/g) ## subset 1 / ? * [] for do done exit read cd
        {
            $f_result.="chdir \'$1\';"
        }
        elsif ($content =~ /^for (.*) in (.*)/g )
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
                $for_str.= ")";
                $for_str=~ s/\'\'/\'\,\'/g;
            }
            elsif ($data =~ /\*/g) #file
            {
                $for_str.="glob(\"$data\")";
                $for_str.=")";
            }
            $f_result.="$for_str";
        }
        elsif ($content=~ /^do$/g)
        {
            $f_result.="{";
        }
        elsif ($content=~ /^done$/g){
            $f_result.= "}";
        }
        elsif ($content =~ /^read (.*)/g){
            $f_result.= "\$$1 = <STDIN>;\n$empty";
            $f_result.= "chomp \$$1;";

        }
        elsif ($content =~ /^(\s*)exit(.*)/g){
            $f_result.= "$1exit$2;";
        }
        # elsif ($content =~ /^(el)*if/g) ## subset 2 / if elif $$$$$$
        # {
        #     $if_data=If($content);
        #     print "$if_data";
        # }
        elsif ($content =~ /^then/g)
        {
            $f_result.= "{";
        }
        elsif ($content =~ /^else/g)
        {
            $f_result.= "}else{";
        }
        elsif($content =~ /^fi$/g)
        {
            $f_result.= "}";
        }
        elsif ($content =~ /^while (.*)/g) ## subset 2 / while $$$$$
        {
            $f_result.="while ";
            $while_str=While($1);
            $f_result.="$while_str";
        }
        elsif ($content =~ /^do/g)
        {
            $f_result.="{";
        }
        elsif ($content =~ /^done/g)
        {
            $f_result.="}";
        }
        elsif ($content =~ /(){/g)
        {
            $f_result.="sub $content";
        }
        elsif ($content =~ /^}$/g)
        {
            $f_result.="$content";
        }
        
        print "$f_result";

        ##### 注释
        if($add ne "")
        {
            print "$add";
        }
        print "\n";
    }
}