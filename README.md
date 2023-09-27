***
# netCDF_auto_install
### Description
Code created to perform an automatic installation of the C and FORTRAN netCDF4 libraries.

Tested on Ubuntu 22.04.3 LTS 

### Usage
```bash
chmod +x netCDF_auto_install.sh
./netCDF_auto_install.sh
```
It is possible to modify the version of the libraries and the installation folder (ifolder_path):

```bash
# zlib version (1.2.8) 
zlinv=1.2.13
# hdf5 version (1.8.13) 
hdf5v=1.12.1
# netcdf-c- version (4.7.4) 
ncCv=4.9.2
# netcdf-FORTRAN version (4.5.4)
ncFv=4.5.4
# Installation folder
ifolder_path=/usr/local
```
