#!/bin/bash

#
# Code created to perform an automatic installation of the
# C and FORTRAN netCDF4 libraries.
#
# OS    : Ubuntu 22.04 LTS
# Author: Michele Martinazzo
# Usage : ./netCDF_auto_install.sh
#

# You may need to install also "curl", "libxml2-dev" and "libcurl4-openssl-dev": 
#                              >> sudo apt install libxml2-dev
#                              >> sudo apt install libcurl4-openssl-dev
#                              >> sudo apt install curl

# If you need to install netCDF4 for python you can export the following 
# envirorment variables (ifolder_ are defined below):
# export HDF5_DIR=ifolder_hdf5
# export NETCDF4_DIR=ifolder_ncC
# Then run: 
#          >>sudo -E pip install netCDF4 --upgrade

# zlib version (1.2.8) 
zlinv=1.2.13
# hdf5 version (1.8.13) 
hdf5v=1.12.1
# netcdf-c- version (4.7.4) 
ncCv=4.9.2
# netcdf-FORTRAN version (4.5.4)
ncFv=4.5.4
# Installation folder
ifolder_path=.

#############################################################################################

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
ENDCOLOR="\e[0m"

#############################################################################################

og_path=$(pwd)

# Creation log file
if [ -f installation_log.txt ]; then
  rm installation_log.txt
  touch installation_log.txt
else
  touch installation_log.txt
fi

# Creation of the installation folder
ifolder=$ifolder_path/netCDF_auto_install
ifolder_zlib=$ifolder/zlib
ifolder_hdf5=$ifolder/hdf5
ifolder_ncC=$ifolder/netcdf4_c
ifolder_ncF=$ifolder/netcdf4_f

if [ ! -d "$ifolder" ]; then
  echo -e "${YELLOW}Creation of the installation directory in $ifolder.${ENDCOLOR}"
  echo "Creation of the installation directory in $ifolder." >> installation_log.txt
  mkdir $ifolder
  mkdir $ifolder_zlib
  mkdir $ifolder_hdf5
  mkdir $ifolder_ncC
  mkdir $ifolder_ncF
else
  echo -e "${RED}The directory $ifolder already exist!${ENDCOLOR}"
  exit
fi


################# zlib #################

echo -e "${YELLOW}Downloading zlib version ${zlinv}${ENDCOLOR}"
echo "Downloading zlib version ${zlinv}" >> installation_log.txt
wget https://zlib.net/fossils/zlib-${zlinv}.tar.gz
tar xvzf zlib-${zlinv}.tar.gz >/dev/null
cd zlib-${zlinv}

echo -e "${YELLOW}Installing zlib version ${zlinv}${ENDCOLOR}"
echo "Installing zlib version ${zlinv}" >> installation_log.txt

./configure --prefix=$ifolder_zlib 1>/dev/null
make #1>/dev/null
make check 1>/dev/null
make install

cd $og_path

################# hdf5 #################

echo -e "${YELLOW}Downloading hdf5 version ${hdf5v}${ENDCOLOR}"
echo "Downloading hdf5 version ${hdf5v}" >> installation_log.txt
hdf5vv=$(echo $hdf5v | cut -d '.' -f 1,2)
wget --content-disposition --no-check-certificate https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-${hdf5vv}/hdf5-${hdf5v}/src/hdf5-${hdf5v}.tar.bz2
tar xvf hdf5-${hdf5v}.tar.bz2 >/dev/null
cd hdf5-${hdf5v}

echo -e "${YELLOW}Installing hdf5 version ${hdf5v}${ENDCOLOR}"
echo "Installing hdf5 version ${hdf5v}" >> installation_log.txt

./configure --enable-shared --enable-hl --with-zlib=$ifolder_zlib --prefix=$ifolder_hdf5 1>/dev/null
make #1>/dev/null
make check #1>/dev/null
make install
cd $og_path


################# netcdf-C #################

echo -e "${YELLOW}Downloading netcdf-C version ${ncCv}${ENDCOLOR}"
echo "Downloading netcdf-C version ${ncCv}" >> installation_log.txt
wget https://github.com/Unidata/netcdf-c/archive/v${ncCv}.tar.gz
mv v${ncCv}.tar.gz ncC_v${ncCv}.tar.gz
tar xvzf ncC_v${ncCv}.tar.gz >/dev/null

cd netcdf-c-${ncCv}

echo -e "${YELLOW}Installing netcdf-c version ${ncCv}${ENDCOLOR}"
echo "Installing netcdf-c version ${ncCv}" >> installation_log.txt

CPPFLAGS=-I$ifolder_hdf5/include LDFLAGS=-L$ifolder_hdf5/lib ./configure --enable-netcdf-4 --enable-shared --enable-dap --prefix=$ifolder_ncC 1>/dev/null

make #1>/dev/null
make check #1>/dev/null
make install
cd $og_path


################# netcdf-F #################

echo -e "${YELLOW}Downloading netcdf-F version ${ncFv}${ENDCOLOR}"
echo "Downloading netcdf-F version ${ncFv}" >> installation_log.txt
wget https://github.com/Unidata/netcdf-fortran/archive/v${ncFv}.tar.gz
mv v${ncFv}.tar.gz ncF_v${ncFv}.tar.gz
tar xvzf ncF_v${ncFv}.tar.gz >/dev/null

cd netcdf-fortran-${ncFv}

echo -e "${YELLOW}Installing netcdf-f version ${ncFv}${ENDCOLOR}"
echo "Installing netcdf-f version ${ncFv}" >> installation_log.txt

CPPFLAGS=-I$ifolder_ncC/include LDFLAGS=-L$ifolder_ncC/lib ./configure --enable-netcdf-4 --enable-shared --enable-dap --prefix=$ifolder_ncF 1>/dev/null
make #1>/dev/null
make check #1>/dev/null
make install

cd $og_path

echo "Installation complete!" >> installation_log.txt
echo -e "${GREEN}Installation complete!${ncFv}${ENDCOLOR}"

# General comments:
# --enable-hl          Enables high level library support, for libraries such as netcdf4-python.
# --enable-shared	     Will (attempt to) build shared libraries on your system.
# --enable-netcdf-4	   Builds netCDF so that netCDF-4/HDF5 files may be produced. 
#                      NetCDF-4/HDF5 files are necessary to use any of the new 
#                      features of netCDF-4, including compression, parallel I/O, 
#                      and the enhanced data model. Without this option (that is, 
#                      by default) you do not get the netCDF-4/HDF5 features.
# --enable-dap         Built with OPenDAP support.
