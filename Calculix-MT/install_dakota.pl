#!/usr/bin/perl

# USAGE: Install Dakota

#######
# MAIN #
########

if ( ! -e 'dakota-6.10-release-public.src.tar' ) { `wget https://dakota.sandia.gov/sites/default/files/distributions/public/dakota-6.10-release-public.src.tar.gz'; }
`gunzip *.gz;gunzip *.tgz`;
tar -xvf dakota-6.10-release-public.src.tar;`;

# ajouter les librairies (Boost), etc
# https://www.cfd-online.com/Forums/openfoam-installation/174860-dakota-6-4-installation-ubuntu-16-04-a.html
# lancer la compilation
