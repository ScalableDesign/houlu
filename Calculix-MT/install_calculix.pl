#!/usr/bin/perl

# USAGE: Install Calculix with Spooles solver
#       perl install
# Install Calculix with Pardiso solver
#       perl install pardiso
#
# Need help? Send an email from feacluster.com !

##################

sub build_spooles {

`mkdir SPOOLES.2.2;mv spooles.2.2.tar SPOOLES.2.2/;cd SPOOLES.2.2;tar -xvf spooles.2.2.tar`;

`perl -i -wpe 's/drawTree/draw/' SPOOLES.2.2/Tree/src/makeGlobalLib`;

my $ccompiler = `which cc`;
if ( $ccompiler =~ /cc/ ) 	{	 
`perl -i -wpe 's/^  CC \=.*/  CC \= cc/' SPOOLES.2.2/Make.inc`;
`perl -i -wpe 's/\#cd MT/\tcd MT/g' SPOOLES.2.2/makefile`;
				}
else { print "\n**** C compiler not found! Install by doing as root: 'yum group install Development Tools'\n\n"; exit 1; }

print "\n** Building Spooles - may take several minutes! **\n\n";
`cd SPOOLES.2.2;make lib`;

} # end sub

##################

sub remove_files {

`rm -f ccx_2.15.src.tar arpack96.tar patch.tar SPOOLES.2.2/spooles.2.2.tar`;
`rm -rf ARPACK/ CalculiX/ SPOOLES.2.2/`;

} # end sub

########
# MAIN #
########

if ( ! -e 'arpack96.tar' ) { `wget http://www.feacluster.com/install/src/arpack96.tar.gz`; }
if ( ! -e 'patch.tar' ) { `wget http://www.feacluster.com/install/src/patch.tar.gz`; }
if ( ! -e 'spooles.2.2.tgz' ) { `wget http://www.feacluster.com/install/src/spooles.2.2.tgz`;}
if ( ! -e 'ccx_2.15.src.tar' ) { `wget http://www.dhondt.de/ccx_2.15.src.tar.bz2`; }
if ( ! -e 'Makefile' ) { `wget http://www.feacluster.com/install/src/Makefile`; }

`gunzip *.gz;gunzip *.tgz`;
`bunzip2 ccx_2.15.src.tar.bz2`;
`tar -xvf arpack96.tar;tar -xvf patch.tar;tar -xvf ccx_2.15.src.tar;`;

$pwd = `pwd`;
chomp ($pwd);
$pwd =~ s/\//\\\//g;
$pwd = "$pwd\\/ARPACK";

`perl -i -wpe 's/home \= .*/home \= $pwd/' ARPACK/ARmake.inc`;
`perl -i -wpe 's/PLAT \= .*/PLAT \= INTEL/' ARPACK/ARmake.inc`;

my $fortran_compiler = `which gfortran`;
$fortran_compiler =~ s/.*gfortran/gfortran/;

if ( $ARGV[0] =~ /pardiso/i ) { 
$fortran_compiler = `which ifort`;
if ( $fortran_compiler !~ /ifort/ ) {
	print "\n**** Intel fortran compiler not installed or configured. If you have already installed it, try doing:\n\nsource /opt/intel/compilers_and_libraries/linux/bin/compilervars.sh  -arch intel64 -platform linux\n\nIf you have not installed, then you can download a free evaluation copy from:\n\nhttps://registrationcenter.intel.com/en/forms/?productid=2274\n\n";
        &remove_files;
	exit 1;
			    }
	else { $fortran_compiler = 'ifort'; `rm -f spooles.2.2.tar`;}
				}
if ( $fortran_compiler =~ /gfortran|ifort/ ) { 
`perl -i -wpe 's/FC      \= .*/FC      \= $fortran_compiler/' ARPACK/ARmake.inc`;
`perl -i -wpe 's/^FFLAGS.*/FFLAGS  \= -O/' ARPACK/ARmake.inc`;
`perl -i -wpe 's/      EXTERNAL/\*     EXTERNAL/' ARPACK/UTIL/second.f`;
				}
else { print "\n**** gfortran compiler not found! Install by doing as root: 'yum install gcc-gfortran'\n\n"; exit 1; }

if ( $fortran_compiler =~ /ifort/ ) { 
`perl -i -wpe 's/^FFLAGS  \= -O/FFLAGS  \= -O -i8/' ARPACK/ARmake.inc`;
						}
my $make = `which make`;
if ( $make =~ /usr/ ) 		{		 
`perl -i -wpe 's/MAKE    \= .*/MAKE    \= \\/usr\\/bin\\/make/' ARPACK/ARmake.inc`;
				}	
print "\n** Building ARPACK - may take several minutes! **\n\n";
`cd ARPACK;make lib`;

if ( $fortran_compiler !~ /ifort/ ) { &build_spooles; }

if ( $fortran_compiler =~ /ifort/ ) { `cp Makefile CalculiX/ccx_2.15/src/Makefile_MT`; }
	else { `perl -i -wpe 's/\=gfortran/\=gfortran -w/g' CalculiX/ccx_2.15/src/Makefile_MT;`; }

`perl -i -wpe 's/\-Wall/\-w/g' CalculiX/ccx_2.15/src/Makefile_MT;`;

print "\n** Building Calculix - may take several minutes! **\n\n";

`cd CalculiX/ccx_2.15/src/;mv Makefile_MT Makefile;make`;
`cp CalculiX/ccx_2.15/src/ccx_2.15_MT ./;chmod 711 ccx_2.15_MT`;
$executable = 'ccx_2.15_MT';

if ( $fortran_compiler =~ /ifort/ ) { `mv ccx_2.15_MT ccx_2.15_MT_PARDISO`; $executable = 'ccx_2.15_MT_PARDISO'; } 

print "\n** Done! - To run, enter ./$executable . Set number of cpus to use by doing:\n\nexport OMP_NUM_THREADS=number_cpus_available\n\n";

if ( -e $executable ) { &remove_files; }

1;