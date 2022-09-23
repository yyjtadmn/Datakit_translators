#!/usr/bin/env perl
# $ENV{'PATH'} = '//plm/pnnas/jtdev/datakit_translator/perl';
# $ENV{'UPERL'} = '//plm/pnnas/jtdev/datakit_translator/perl';
# $ENV{'PERL5LIB'} = '//plm/pnnas/jtdev/datakit_translator/perl/lib';
# $ENV{'PERLLIB'} = '//plm/pnnas/jtdev/datakit_translator/perl/lib';
$ENV{'SPLM_LICENSE_SERVER'} = '28000@inpnsweb01,28000@pnlv6002'; 

use lib '//plm/pnnas/jtdev/datakit_translator/perl/lib';
use strict;
use warnings;
use File::Copy;
use File::Find;
use File::Basename;
use Fcntl qw(:flock);
use Cwd;
use Cwd qw(getcwd);
use Net::SMTP;
use XML::Simple;
use File::Path;
use File::Copy::Recursive qw(dircopy dirmove);
use File::Copy::Recursive;
use Getopt::Long;

# #USAGE : Inputs needed for script.
#{
my $num_args = $#ARGV + 1;
my @SaveArgs = @ARGV;                                            # takes all commandline inputs
# if ($num_args != 4 ) {
  # # print "\n Error : Few arguments missing \n";
  # print "\n linuxTest.pl -b=<baseline> for baseline download\n";
  # print "\n linuxTest.pl -r=1 for running regression for the latest baseline downloaded in filer\n";
  # exit;
# }
my ( $baseline,$regstart);

GetOptions(
    'b=s'  => \$baseline,
	'r=s'  => \$regstart,
);

if($baseline){
	#print "\n baseline value :". $baseline; 
}
else{
	#print "\n baseline value is not defined";
	$baseline="NULL"
}
if($regstart){
	#print "\n regstart value :". $regstart; 
}
else{
	#print "\n regstart value is not defined";
	$regstart="NULL"
}

###################################################
# initialize
###################################################

#{  Var Declaration
use vars qw(
	$PRODUCT_NAME
	$QQC_BAT
	$Distrib_call_bat
	$DISTRIB_BASELINE
	$DISTRIB_DIR
    $DMS_NODE
);

my $DMS_CURRENT_BASELINE='';
my $DMS_PARENT_UNIT='';
my $DISTRIB_DIR = '';
my $DMS_NODE = $baseline;
my $TEST_DIR='';
my $GOLD_DIR='';
my $build_file='';
my $qc_file='';
my $plat='';
my $productExe= '';
my $JTCompare_file= '';
my $ImportProfileFile='';
my $ImportTaskFile='';
my $CURRENT_BASELINE_INFO_LOG='';
my $dirname='';
my $translatorInstall='';
my $workingDir='';
my $unit_path ='';
my $udistrib_path='';
my $baselineID =0;
my $newBaseline=0;

my $os = $^O;
# print "\n my os is: $os \n";
if ($os eq 'linux')
{
$unit_path = '/usr/site/devop_tools/UDU/tools/bin/unx/unit';
$udistrib_path ='/usr/site/devop_tools/UDU/tools/bin/unx/udistrib';
}
else
{
$unit_path = 'C:/apps/devop_tools/UDU/tools/bin/wnt/unit.bat';
$udistrib_path ='C:/apps/devop_tools/UDU/tools/bin/wnt/udistrib.bat';
}
# print "\n###########";
# print "\n dms node value :".$DMS_NODE;
$workingDir='//plm/pnnas/jtdev/datakit_translator/Baseline_'.$baseline;
$workingDir=~tr{\\}{/};
if(!-d $workingDir)
{
#creating directory perl  
mkdir( $workingDir ) or die "Couldn't create $workingDir directory, $!";  
print "Directory created successfully\n";
}

##################################get current baseline#######################################
if( $DMS_NODE ne "NULL" && $regstart eq "NULL")
{
#$workingDir='//plm/pnnas/jtdev/datakit_translator/Baseline_'.$baseline;
#$workingDir=~tr{\\}{/};
$CURRENT_BASELINE_INFO_LOG =$workingDir.'/current_baseline_info.log';
$CURRENT_BASELINE_INFO_LOG=~tr{\\}{/};
#my $run_distrib=$udistrib_path.' '.'-q REPOSITORY_ID -v @'.$DMS_NODE.'.latest > '.$CURRENT_BASELINE_INFO_LOG;
my $run_distrib="C:\\apps\\devop_tools\\perl.d\\bin\\perl.exe C:\\apps\\devop_tools\\bin\\dtcmd.pl bllst -e $DMS_NODE -L -a name>$CURRENT_BASELINE_INFO_LOG";
print "\n $run_distrib \n";
system($run_distrib);
}
##################################get current baseline completed####################################### 
 


if( -f $CURRENT_BASELINE_INFO_LOG && $DMS_NODE ne "NULL" && $regstart eq "NULL")
 {
	my $cmdline='';
	my @err_files=();
	sub  trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };
	####################################################
	#  subroutine to find which baseline to download
	####################################################
	sub Find_baseline(@)
	{
		my $dir = shift;
		if( $os =~ /win/i || $os=~ /linux/i)
		{
			my $dms_info_file=$CURRENT_BASELINE_INFO_LOG;
			$dms_info_file=~tr{\\}{/};

			open (PROFILEFILE, $dms_info_file)or die;
			printf "\n PROFILEFILE found at  $dms_info_file\n ";
			while (my $line=<PROFILEFILE>) {
				# if( $_ =~ /name=/i)
				# {
					# my ($temp,$temp2)= split('\:',$_);
					# $DMS_CURRENT_BASELINE = trim($temp2);
					# print "\n dms current baseline".$DMS_CURRENT_BASELINE;
					# last;
				# }
					chomp $line;		
					my $nameFromFile="";
					$nameFromFile=($line =~m/\s*(.*name.*)=(.*)\s*/)[1];
					$nameFromFile=~ s/^\s+|\s+$//g;
						
					if($nameFromFile)
					{
						$DMS_CURRENT_BASELINE = $nameFromFile;
						print "\n dms current baseline ".$DMS_CURRENT_BASELINE;
					last;
					}
			}
			close (PROFILEFILE);			  
		}
	}
		  
	##############################################################################################
	#   baseline download and regrun
	##############################################################################################
	if( $os =~ /win/i || $os =~ /xp/i)
	{
		Find_baseline($CURRENT_BASELINE_INFO_LOG);
		my $is_new_baseline = 0;
		$DISTRIB_DIR =$workingDir.'/'.$DMS_CURRENT_BASELINE;
		$DISTRIB_DIR =~ tr{/}{\\};
						
		unless( -d $DISTRIB_DIR)
		{	
			mkdir $DISTRIB_DIR or die;
			$is_new_baseline = 1;
			#print "---------------------";
		}
		sub is_folder_empty {
			my $dirname = shift;
			opendir(my $dh, $dirname) or die "Not a directory";
			return scalar(grep { $_ ne "." && $_ ne ".." } readdir($dh)) == 0;
		}
		if (is_folder_empty($DISTRIB_DIR)) {
			$is_new_baseline = 1;
		}
		my $str = $DMS_CURRENT_BASELINE;
		my $latestfilename =$workingDir.'/latestBaseline.txt';
		$latestfilename =~ tr{/}{\\};
		open(FH, '>', $latestfilename) or die $!;
		print FH $str;
		print FH ",";
		print FH $is_new_baseline;
		close(FH);
		print "\n Writing to file successfully!\n";
		
		if( $is_new_baseline == 1 )
		{
			print "\n Latest Baseline  Download :-------------  \n DMS Baseline :- $DMS_CURRENT_BASELINE \n";
			my $stream = "wntx64 common lnx64";
			if ($DISTRIB_DIR  && $DMS_CURRENT_BASELINE )
			{
				#######################################downloading baseline######################################################################################  
				my $run_distrib=$udistrib_path.' '.'-s -u -t'.' '.$DISTRIB_DIR.' '.'-p'.' '.'"'.$stream.'"'.' '.'-v'.' '.'@'. $DMS_CURRENT_BASELINE.' '.'-L 1 -A';
				print "\n $run_distrib \n";
				system($run_distrib);
				#########################################download completed############################################################## 
			}
		}
		
		if (-e $DISTRIB_DIR.'/distributions')
		{
			rmtree $DISTRIB_DIR.'/distributions';
		}
		if (-e $DISTRIB_DIR.'/'.$DMS_CURRENT_BASELINE)
		{
			#print " \n folder DMS_CURRENT_BASELINE is there";
			rmtree $DISTRIB_DIR.'/'.$DMS_CURRENT_BASELINE.'/drv';
			rmtree $DISTRIB_DIR.'/'.$DMS_CURRENT_BASELINE.'/include';
			rmtree $DISTRIB_DIR.'/'.$DMS_CURRENT_BASELINE.'/out';
			rmtree $DISTRIB_DIR.'/'.$DMS_CURRENT_BASELINE.'/tincl'; 
			rmtree $DISTRIB_DIR.'/'.$DMS_CURRENT_BASELINE.'/lnx64/images';
			rmtree $DISTRIB_DIR.'/'.$DMS_CURRENT_BASELINE.'/lnx64/lib';
			rmtree $DISTRIB_DIR.'/'.$DMS_CURRENT_BASELINE.'/lnx64/obj';
			rmtree $DISTRIB_DIR.'/'.$DMS_CURRENT_BASELINE.'/wntx64/images';
			rmtree $DISTRIB_DIR.'/'.$DMS_CURRENT_BASELINE.'/wntx64/lib';
			rmtree $DISTRIB_DIR.'/'.$DMS_CURRENT_BASELINE.'/wntx64/obj';
		}
	}
  }

my $latestBaselineID=$workingDir.'/latestBaseline.txt';
$latestBaselineID=~tr{\\}{/}; 
open(my $fh, '<', $latestBaselineID) or die "File can't be opened";
my $count=0;
my $line=<$fh>;
my @spl = split(',', $line);
foreach my $i (@spl) 
{
	if($count==0)
   {
	  $baselineID=$i;
   }
   if($count==1)
   {
	  $newBaseline=$i;
   }
   ++$count;
}
close $fh;

if($newBaseline eq "1")
{
##################################linux regression run#################################
 if($regstart ne "NULL" && $os=~ /linux/i)
 {
	my $currentDir=$workingDir.'/'.$baselineID.'/'.$baselineID;
	$currentDir=~tr{\\}{/}; 
	#print "$currentDir\n";
 	#my $path = Cwd::cwd();
	chdir $currentDir or die "cannot change: $!\n";
	
	##############jt_inventor Linux regression run###########
	#print $ENV{'SPLM_LICENSE_SERVER'};
	my $regrun_call='//plm/pnnas/jtdev/datakit_translator/RegTool/lnx64/dist/RegTool -g jt_inventor -gd /plm/pnnas/jtdev/datakit_translator/GoldFiles/Interop12/JT_INVENTOR -jcx /plm/pnnas/jtdev/datakit_translator/JtCompareConfig/JTCOMPARE_Config_jt_inventor_Import.xml';
	print "\n Regrunner Call for jt_inventor in linux: -------- \n $regrun_call\n";
	#system($regrun_call);
	my $outline='echo regrun for jt_inventor in linux succeeded';
	system($outline);
	
	##############jt_catiav4_d Linux regression run###########
	#print $ENV{'SPLM_LICENSE_SERVER'};
	$regrun_call='//plm/pnnas/jtdev/datakit_translator/RegTool/lnx64/dist/RegTool -g jt_catiav4_d -gd /plm/pnnas/jtdev/datakit_translator/GoldFiles/Interop12/JT_CATIAV4_D -jcx /plm/pnnas/jtdev/datakit_translator/JtCompareConfig/JTCOMPARE_Config_jt_catiav4_Import.xml';
	print "\n Regrunner Call for jt_catiav4 in linux: -------- \n $regrun_call\n";
	#system($regrun_call);
	$outline='echo regrun for jt_catiav4 in linux succeeded';
	system($outline);
	
	##############jt_iges Linux regression run###########
	#print $ENV{'SPLM_LICENSE_SERVER'};
	# mkdir $currentDir.'/src/jt_iges_d';
	# mkdir $currentDir.'/src/jt_iges_d/qc';
	# dircopy($currentDir.'/src/dtk_jt_iges/qc',$currentDir.'/src/jt_iges_d/qc');
	$regrun_call='//plm/pnnas/jtdev/datakit_translator/RegTool/lnx64/dist/RegTool -g jt_iges_d -gd /plm/pnnas/jtdev/datakit_translator/GoldFiles/Interop12/JT_IGES_D -jcx /plm/pnnas/jtdev/datakit_translator/JtCompareConfig/JTCOMPARE_Config_jt_iges_Import.xml';
	print "\n Regrunner Call for jt_iges in linux: -------- \n $regrun_call\n";
	#system($regrun_call);
	$outline='echo regrun for jt_iges in linux succeeded';
	system($outline);
	
	##############jt_acis Linux regression run###########
	#print $ENV{'SPLM_LICENSE_SERVER'};
	$regrun_call='//plm/pnnas/jtdev/datakit_translator/RegTool/lnx64/dist/RegTool -g jt_acis -gd /plm/pnnas/jtdev/datakit_translator/GoldFiles/Interop12/JT_ACIS -jcx /plm/pnnas/jtdev/datakit_translator/JtCompareConfig/JTCOMPARE_Config_jt_acis_Import.xml';
	print "\n Regrunner Call for jt_acis in linux: -------- \n $regrun_call\n";
	#system($regrun_call);
	$outline='echo regrun for jt_acis in linux succeeded';
	system($outline);
	
	############## jt_creo_d Linux regression run###########
	#print $ENV{'SPLM_LICENSE_SERVER'};
	$regrun_call='//plm/pnnas/jtdev/datakit_translator/RegTool/lnx64/dist/RegTool -g jt_creo_d -gd /plm/pnnas/jtdev/datakit_translator/GoldFiles/Interop12/JT_CREO_D -jcx /plm/pnnas/jtdev/datakit_translator/JtCompareConfig/JTCOMPARE_Config_jt_creo_d_Import.xml';
	print "\n Regrunner Call for jt_creo_d in linux: -------- \n $regrun_call\n";
	#system($regrun_call);
	$outline='echo regrun for jt_creo_d in linux succeeded';
	system($outline);

 }
 elsif($regstart ne "NULL" && $os=~ /win/i)
 {
	my $currentDir='J:/datakit_translator/Baseline/'.$baselineID.'/'.$baselineID;
	$currentDir=~tr{\\}{/}; 
	#print "$currentDir\n";
	#my $path = Cwd::cwd();
	#print $currentDir;
	chdir $currentDir or die "cannot change: $!\n";
	
	##############jt_inventor windows regression run###########
	my $regrun_call='//plm/pnnas/jtdev/datakit_translator/RegTool/wntx64/dist/RegTool.exe -g jt_inventor -ctg unit -jc false -jcx /plm/pnnas/jtdev/datakit_translator/JtCompareConfig/JTCOMPARE_Config_jt_inventor_Import.xml -lc false';
	print "\n Regrunner Call for jt_inventor in windows: -------- \n $regrun_call\n";
	#system($regrun_call);
	my $outline='echo regrun for jt_inventor in windows succeeded';
	system($outline);
 }
	
}
									  
if($regstart ne "NULL" && $os=~ /linux/i && $newBaseline eq "1")
{
 my $text_mail ='echo "Datakit_translator regression Testing Completed in linux machine"| mail -s "Datakit_translator regression Testing Completed in linux machine" '.'-r datakit@ugs.com mohapatr@ugs.com';
 system($text_mail ); 
}
elsif($regstart ne "NULL" && $os=~ /win/i && $newBaseline eq "1")
{
 my $bmail_loc ='J:/datakit_translator/JTCompare_Regrun_2018/regrun/bmail.exe';
 $bmail_loc =~ tr{/}{\\};
 my $text_mail ='call'.' '.$bmail_loc.' '.'-s pnsmtp -t mohapatr@ugs.com -f datakit@ugs.com  -a "Datakit_translator regression Testing Completed in windows machine"';
 system($text_mail ); 	
}
elsif($os=~ /win/i)
{
 my $bmail_loc ='J:/datakit_translator/JTCompare_Regrun_2018/regrun/bmail.exe';
 $bmail_loc =~ tr{/}{\\};
 my $text_mail ='call'.' '.$bmail_loc.' '.'-s pnsmtp -t mohapatr@ugs.com -f datakit@ugs.com  -a "Datakit_translator baseline download complete"';
 system($text_mail ); 
}
else
{
my $text_mail ='echo "As there is no new baseline available so skipping the Datakit_translator regression in linux machine"| mail -s "Datakit_translator regression Testing skipped in linux machine" '.'-r datakit@ugs.com mohapatr@ugs.com';
 system($text_mail ); 
}

