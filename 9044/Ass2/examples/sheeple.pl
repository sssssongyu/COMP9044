#!/usr/bin/perl -w
sub Echo{
    my ($data)=@_;
    # $data=~ s/^echo //g;
    if($data=~ /^-n(.*)(\n*)$/g)
    {
        $data=$1;
    }
    elsif ($data =~ /^\'(.*)\'(\n*)$/g)
    {
        $data="$1$2";
    }
    elsif ($data =~ /^\"(.*)\"(\n*)$/g)
    {
        $data="$1$2";
    }
    # print "####$data##############%%####\n";
    $data=~ s/\"\'(.*)\'\"/\'$1\'/g;
    $data=~ s/\'/\\\'/g;
    $data=~ s/\"/\\\"/g;
    return $data;
}

sub Equal{
    my ($data)=@_;
    $data=~ /(.*)=(.*)$/g;
    my $first=$1;
    my @second=split(' ',$2);
    my $f_data="";
    if($first=~/^\$/g)
    {
        $f_data="$first =";
    }
    else{
        $f_data="\$$first =";
    }

    foreach $i(@second)
    {
        # print "###$i\n";
        if ($i =~ /[\+\-\*\%\/]/g)
        {
            $i=~ s/\'//g;
            $f_data.=" $i";
        }
        elsif ($i =~ /^\d+$/g || $i =~ /^\$/g)
        {
            $f_data.=" $i";
        }
        else{
            $f_data.=" \'$i\'";   #########
        }
    }
    $f_data.=";";
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
    if ($data =~ /test (.*)$/g || $data =~ /\[ (.*) \]/g)
    {
        $add_str=Test($1);
        $if_str="$if_str($add_str)";
    }
    elsif ($data =~ /^(-[a-z]) (.*) /g)
    {
        $if_str="$if_str($1 \'$2\')";
    }
    elsif($data =~ /if (.*)/g)
    {
        $DDD_1=$1;
        $DDD_1=~ s/;//g;
        $if_str.="(! $DDD_1)";
    }
    return $if_str;
}

sub Test{
    my ($con)=@_;
    if ($con =~ /(.*) -eq (.*)/g)
    {
        return "$1 == $2";
    }
    elsif ($con =~ /(.*) -ne (.*)/g)
    {
        return "$1 != $2";
    }
    elsif ($con =~ /(.*) -gt (.*)/g)
    {
        return "$1 > $2";
    }
    elsif ($con =~ /(.*) -ge (.*)/g)
    {
        return "$1 >= $2";
    }
    elsif ($con =~ /(.*) -lt (.*)/g)
    {
        return "$1 < $2";
    }
    elsif ($con =~ /(.*) -le (.*)/g)
    {
        return "$1 <= $2";
    }
    elsif ($con =~ /(.*) = (.*)/g)
    {
        $first=$1;
        $second=$2;
        if ($1=~ /\"/g)
        {
            return "$first eq $second";
        }
        else{
            return "\'$first\' eq \'$second\'";
        }
    }
    elsif ($con =~ /(.*) != (.*)/g)
    {
        return "\'$1\' ne \'$2\'";
    }
    elsif ($con =~ /^(-[a-z]) (.*)/g)
    {
        $data_1=$1;
        $data_2=$2;
        if ($2 =~ /^\$/g)
        {
            return "$data_1 $data_2";
        }
        else{return "$data_1 \'$data_2\'";}
    }
    else{
        return $con;
    }
}

sub While{
    my ($data) = @_;
    if ($data=~ /^test (.*)/g)
    {
        $w_str=Test($1);
        return "($w_str)";
    }
    elsif ($data=~ /true/g)
    {
        return "(1)";
    }
    else{
        return $data;
    }

}

# print "#####\n";

$sub_flag=0;  ## sub in or not
$open_file=0;
$case_flag=0;
$case_word="";
$empty="";
while ($content=<>)
{
    $add="";
    $f_result=""; 
    if ($content =~ /^#!\/bin\/dash$/g) ##first line 
    {
        print "#!/usr/bin/perl -w\n";
        next;
    }
    if ($content=~ /^\n$/g){ ## \n
        print "\n";
        next;
    }
    if ($content=~ /^(\s+)/g)  ##get the empty space
    {
        $empty=$1;
        print "$empty";
        $content =~ s/^(\s+)//g;
    }
    if ($content =~ /^(\#.*)$/g || $content =~ /.*? (\#.*)$/g) ## #
    {
        # print "#####$content###\n"; #####
        $add=$1;
        $content =~ s/$1//g;
    }
    if ($content =~ /(.*?)(\"*)(\'*)\$(\d+)(\'*)(\"*)(.*)/g)  ## $1 to $ARGV[0]
    {   
        $first=$1;
        $first_k=$2;
        $first_s=$3;
        $n=$4;
        $num=$4-1;
        $second_s=$5;
        $second_k=$6;
        $last=$7;
        # print "############\n";
        if ($first_k=~ /^\"$/g && $second_k =~ /^\"$/g)
        {
            if ($num==-1)
            {
                $content ="$first$first_s\$0$second_s$last\n";
            }
            elsif ($sub_flag == 0){
                $content = "$first$first_s\$ARGV[$num]$second_s$last\n";}
            else{
                $content = "$first$first_s\$_[$num]$second_s$last\n";
            }
        }
        elsif($first_s=~ /^\'$/g && $second_s =~ /^\'$/g)
        {
            $content = "$first\\\$$n$last\n";
        }
        else{
            if ($num==-1)
            {
                $content ="$first$first_s\$0$second_s$last\n";
            }
            elsif ($sub_flag == 0){
                $content = "$first$first_s\$ARGV[$num]$second_s$last\n";}
            else{
                $content = "$first$first_s\$_[$num]$second_s$last\n";
            }
        }
    }

    if ($content =~ /(.*?)\"*\$\@\"*(.*)/g)  ## $@ $*
    {
        $content ="$1\@ARGV$2\n";
        # print "#####111$content\n";
    }
    if ($content =~ /(.*?)(\"*)\$\*(\"*)(.*)/g)
    {   
        $first=$1;
        $first_k=$2;
        $second_k=$3;
        $last=$4;
        if ($first_k=~ /\"/g && $second_k =~ /\"/g)
        {
            $content ="$first$first_k\@ARGV$second_k$last\n";
        }
        else{
            $content ="$first\@ARGV$last\n";
        }
    }
    if ($content =~ /^(.*)\$\#(.*)$/g) ## $#
    {
        print "\$nnum=\$#ARGV+1;\n$empty";
        $content ="$1\$nnum$2\n";
    }
    if ($content =~ /^(.*)\`(.*)\`(.*)$/g || $content =~ /^(.*)\$\([^\(](.*)\)[^\)](.*)/g)  ## subset 3 / ` ` $()  
    {
        $content="$1$2$3";
    }
    if ($content =~ /^(.*)expr (.*)$/g)  ##expr
    {
        $content ="$1$2";
    }
    if ($content =~ /(.*)\(\((.*)\)\)(.*)/g)  ## $(())
    {
        $ff=$1;
        $ss=$2;
        $ll=$3;
        @dd=split / /,$2;
        if ($dd[2]=~ /^\d+$/)
        {
            $content = "$ff$ss$ll";
        }
        else
        {
            $content = "$ff$dd[0] $dd[1] \$$dd[2]$ll";
        }
    }
    $content=~ s/&&/and/g;  ## && ||
    $content=~ s/\|\|/or/g;
    $content=~ s/(pwd .*)/system \"$1\";/g;  ## system
    $content=~ s/(ls .*)/system \"$1\";/g;
    $content=~ s/(id .*)/system \"$1\";/g;
    $content=~ s/(date .*)/system \"$1\";/g;
    $content=~ s/(rm .*)/system \"$1\";/g;
    $content=~ s/(fgrep .*)/system \"$1\";/g;
    $content=~ s/(chmod .*)/system \"$1\";/g;
    $content=~ s/(mv .*)/system \"$1\";/g;
    $content=~ s/cd (.*)/chdir \'$1\';/g;

    if ($content =~ /^return (\d)/g)  ### return 
    {
        if ($1==0){
            $content =~ s/0/1/g;
        }else{
            $content =~ s/1/0/g;
        }
        print "$content;";
    }
    elsif ($content =~ /return (.*)/g)
    {
        if ($1==0){
            $content =~ s/0/1/g;
        }elsif($1==1){
            $content =~ s/1/0/g;
        }
    }
    #########
    while ($content =~ /-o/g || $content =~ /-a/g)
    {
        $content =~ s/-o/or/g;
        $content =~ s/-a/and/g;
    }
    if ($content =~ /(.*)(\>\>)[^\s=]+(.*)/g || $content =~ /(.*)(\>)[^\s=]+(.*)/g || $content =~ /(.*)(\<)[^\s=]+(.*)/g)  ##open F
    {
        print "open FFFF, \'$2\',$3 or die;\n$empty";
        $content = $1;
        $open_file=1;
    }  
    if ($content =~ /^esac$/g)
    {
        $case_flag=0;
        next;
    }
    if ($case_flag!=0) ## in case loop
    {   
        $content=~ /^(.*)\) (.*) \;\;/g;
        $second=$2;
        if ("$content" =~ /\*/g)
        {
            $first="\\\*";
        }
        else{
            $first=$1;
        }
        if ($case_flag==1)
        {
            $content="if($case_word =~ \/$first\/g){ $second";
            $case_flag=2;
        }
        else{
            $content="elsif($case_word =~ \/$first\/g){ $second";
        }

    }
    while ($content =~ / \= \d+/g)
    {
        $content=~ s/ \= / \=\= /g;
    }

    if ($content =~ /(.*)echo (.*\n*)(\;*)$/g)  ## subset 0 / echo = $ #
    {
        $f_result.=$1;
        # print "#####$f_result###\n";            
        $echo_d=Echo($2);
        $echo_last=$3;
        if ($open_file==0){
            $f_result.="print \"$echo_d\";$echo_last";
        }
        else{
            $f_result.="print FFFF \"$echo_d\n\";$echo_last";
        }
    }
    elsif ($content =~ /^case (.*) in$/g)  ## case
    {
        $case_flag=1;
        $case_word=$1;
        next;
    }
    elsif ($content =~ /^(el)*if/g) ## subset 2 / if elif $$$$$$
    {
        $if_data=If($content);
        $f_result.="$if_data";
    }        
    # elsif ($content =~ /^cd (.*)/g) ## subset 1 / ? * [] for do done exit read cd
    # {
    #     $f_result.="chdir \'$1\';"
    # }
    elsif ($content =~ /^for (.*) in (.*)/g )   ## subset 1 / ? * [] for do done exit read cd
    {
        $data=$2;
        # print "###########$content\n";
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
        else{
            $for_str.="$data)";
        }
        $f_result.="$for_str";
    }
    elsif ($content=~ /^do$/g){
        $f_result.="{";
    }
    elsif ($content=~ /^done$/g){
        $f_result.= "}";
    }
    elsif ($content =~ /^read (.*)/g){
        $f_result.= "\$$1 = <STDIN>;\n$empty";
        $f_result.= "chomp \$$1;";
    }
    elsif ($content =~ /^exit(.*)/g){
        $f_result.= "exit$1;";
    }
    elsif ($content =~ /^then/g){
        $f_result.= "{";
    }
    elsif ($content =~ /^else/g){
        $f_result.= "}else{";
    }
    elsif($content =~ /^fi$/g){
        $f_result.= "}";
    }
    elsif ($content =~ /^while (.*)/g) ## subset 2 / while $$$$$
    {
        $f_result.="while ";
        $while_str=While($1);
        $f_result.="$while_str";
    }
    elsif ($content =~ /^do/g){
        $f_result.="{";
    }
    elsif ($content =~ /^done/g){
        $f_result.="}";
    }
    elsif ($content =~ /(.*)\(\) {/g)  ## sub
    {
        $f_result.="sub $1 {\n";
        $sub_flag=1;
        print "$f_result";
        next;
    }
    elsif ($content =~ /^}$/g)
    {
        $f_result.="$content";
        $sub_flag=0;
    }
    elsif ($content =~ /local (.*)/g)  ## sub local
    {
        $f_result.="my ";
        $lo_num=0;
        foreach $i(split(/ /, $1))
        {
            if ($lo_num==0)
            {
                $f_result.="(\$$i";
                $lo_num=1;
            }
            else{
            $f_result.=", \$$i";}
        }
        $f_result.=");";
    }
    elsif ($content =~ /test (.*)/g)
    {
        $t_data=Test($1);
        $f_result.="$t_data;";
    }

    if ($content =~ /^(.*)=(.*)$/g) ##[^(e)*(i)]
    {
        $equal_d=Equal($content);
        $f_result.="$equal_d";
    }
    while ($content =~ /-lt/g || $content =~ /-ge/g || $content =~ /-eq/g || $content =~ /-le/g || $content =~ /-ge/g || $content =~ /-ne/g)  ## < > =
    {
        $content=Test($content);
    }

    print "$f_result";

    if($case_flag!=0)
    {
        print "}";
    }
    ##### 注释
    if($add ne "")
    {
        print "$add";
    }
    if($open_file==1)
    {
        print "\n$empty";
        print "close FFFF;";
        $open_file=0;
    }
    print "\n";
}
