#!/usr/bin/perl

use warnings;
use strict;
use File::Copy;

#different files "headerX" containing parts of your header/footer/etc
my $header1 = "header1";
my $header2 = "header2";
my $header3 = "header3";
my $over_file = "overmenu.temp";
my @file = <*.html>;
my $count;

#overmenu
my $overmenu;

foreach my $file (@file)
	{

#create file.final file and check file status
		my $final="$file".".final";
		$count = $file =~ tr/-//;

#set title
		my $title = "<title>".$file."</title>"."\n";

#split filenames correctly
		my @datas = split('-',$file);
		my @xdatas = @datas;

		for (@xdatas)
			{
				s/_/ /g;
			}

#cp $datas[0] variable in $menu
		my $menu = $datas[0];

#define $datas[0] 	specific file name for main menu nodes
		foreach ($datas[0]) 
                        {
				s/Mainmenu/Mainmenu_name/;
                        }

#we remove the .html from the last part
		$datas[-1] =~ s/.html//;
		$xdatas[-1] =~ s/.html//;

#set overmenu
		if ($count == 1) 	#change specific titles (if special characters)
			{ 
				if ($file =~ m/why_dyou/)
					{
						$xdatas[0] = "why d'you";
						if ($file =~ m/why_dyou/)
							{
								$xdatas[1] = "why d'you?";
							}
					}
		
		#set your html variables here
		$overmenu="<a class=\"overmenu_links_left\" href=\"index.html\">Home</a>\n>\n<a class=\"overmenu_links_left\" href=\"".$datas[0].".html\">".$xdatas[0]."</a>\n>\n<a class=\"overmenu_links_left\" href=\"".$file."\">".$xdatas[1]."</a>\n";
			}
		elsif ($file eq "index.html")
			{
				 $overmenu="<a class=\"overmenu_links_left\" href=\"index.html\">Home</a>\n";
			}
		else
			{
				print ">> error, file $file doesn't fit recognition system.\n";
			}
			
#copy overmenu in new file over_file.temp
		open(my $overmenu_temp, '>', $over_file);
		print $overmenu_temp $overmenu;
		close $overmenu_temp;
		
#open temp file 
		open (my $final_file, '>>', $final) or die ">>error, couldn't create temp file \n";

#first, copy header1 in final
		open (my $read_header1, '<', $header1) or die ">>error, couldn't read header 1 \n";
		while (my $a = <$read_header1>)
			{
				print $final_file $a;
			}
		close $read_header1;

#then copy title in final
		print $final_file "\t"x2 .$title;

#then copy header2 in final
		open (my $read_header2, '<', $header2) or die ">>error, couldn't read header 2 \n";
		while (my $a = <$read_header2>)
		    {
			    print $final_file $a;
		    }
		close $read_header2;

#then copy overmenu in final
		open($overmenu_temp, '<',$over_file);
		while (my $a = <$overmenu_temp>)
			{
				print $final_file "\t"x6 .$a;
			}
		print $final_file "\t"x5 ."</div>\n";
		close $overmenu_temp;

#then copy header3 in final
		open (my $read_header3, '<', $header3) or die ">>error, couldn't read header 3 \n";
		while (my $a = <$read_header3>)
			{
				print $final_file $a;
			}
		close $read_header3;

#copy file as file.bak
		my $file_temp = "$file".".tmp";
		copy($file,".".$file.".bak");

#open file 
		open (my $read, '<', $file) or die ">>error, couldn't read file $file";
		open (my $copy,'>',$file_temp) or die ">>error, couldn't create temp file $file_temp";

#copy in temp from <div id = "text">
		my $a="0";
		while (my $line = <$read>)
			{
				unless ($line =~ m/<div id="text">/ or $line =~ m/<div id="table">/ or $a=="1")
					{
						next;
					}
				if ($a=="1")
					{
						print $copy $line;
					}
				else
					{	
						print $copy $line;
						$a="1";
					}
			}
		
#close original file
		close $read;

#close .tmp and reopen it for input
		close $copy;
		open ($copy,'<',$file_temp) or die ">>error, couldn't reopen temp file $file_temp";
		
#now add .tmp to .final
		while (my $b = <$copy>)
			{
				print $final_file $b;
			}

#now delete .tmp and rename .final as $file

		close $final;
		unlink $file_temp;
		unlink $file;
		unlink $over_file;
		rename $final, $file;
		print "$file ok !\n";
	}

print ">all done =)\n";
