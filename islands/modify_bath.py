"""
Need to do: 
# module add anaconda/2.7-5.0.1
# python modify_bath.py

"""

import netCDF4
from netCDF4 import Dataset as NetCDFFile
import matplotlib
matplotlib.use("TkAgg")
import matplotlib.pyplot as plt
import numpy as np
from mpl_toolkits.basemap import Basemap
import os
import copy


nx=96
ny=73
nxp2=nx+2

do_ridge=1

os.system('cp 541_0_1deg_02o.nc 541_0_1deg_02o_new.nc')

# Read original data 
nc1 = NetCDFFile('541_0_1deg_02o.nc', 'r')
print(nc1)
lat = nc1.variables['lat'][:]
lon1 = nc1.variables['lon1'][:]
bath_orig = nc1.variables['depthmask_xancil'][:]
nc1.close()


# Modify data 
bath_new=copy.deepcopy(bath_orig)
bath_new[:]=bath_new[:]*1.0

# do loop over all gridcells
# if in region, then put in a ridge, of lengthscale x.

lam1d=160
phi1d=45
pi=np.pi
rearth=6371

for j in range(ny):
    for i in range(nx):
        print(i,j) 

        lam1=lam1d*2*pi/360.0
        phi1=phi1d*2*pi/360.
        lam2=lon1[i]*2*pi/360.0
        phi2=lat[j]*2*pi/360.0

        if do_ridge == 1:

            phi1=phi2
            dist=rearth*np.arccos(np.sin(phi1)*np.sin(phi2)+np.cos(phi1)*np.cos(phi2)*np.cos(abs(lam1-lam2)))
            ridge=20-12.0*np.exp(-1.0*dist/500.0)
            print(dist)
            
            if bath_new[j,i] > ridge:
                bath_new[j,i]=ridge



# copy to last 2 columns (note python bonkers numbering).
    bath_new[j,nx:nx+2]=bath_new[j,0:2]

# Write new data 
nc2 = NetCDFFile('541_0_1deg_02o_new.nc', 'r+')
nc2.variables['depthmask_xancil'][:]=bath_new[:]
nc2.close()


print(lon1.shape)
print(lat.shape)
print(bath_orig.shape)
print(bath_orig.size)

#plt.contourf(bath_orig)
#plt.colorbar()
#plt.show()

map= Basemap(projection='cyl',llcrnrlat=-90,urcrnrlat=90,\
            llcrnrlon=0,urcrnrlon=360)


#cs=map.contourf(lon1,lat,bath_orig,latlon=True)
cs=map.pcolor(lon1, lat, bath_orig, cmap="viridis", vmin=0, vmax=20, latlon=True)
cb=map.colorbar(cs,"bottom", size="5%", pad="10%")
plt.title('Original Bathymetry')
cb.set_label('Model Level')
map.drawparallels(np.arange(-90., 90., 30.), labels=[1,0,0,0], fontsize=5)
map.drawmeridians(np.arange(-180., 180., 30.), labels=[0,0,0,1], fontsize=5)
plt.savefig('bath_orig.png')




cs=map.pcolor(lon1, lat, bath_new, cmap="viridis", vmin=0, vmax=20, latlon=True)
cb=map.colorbar(cs,"bottom", size="5%", pad="10%")
plt.title('New Bathymetry')
cb.set_label('Model Level')
map.drawparallels(np.arange(-90., 90., 30.), labels=[1,0,0,0], fontsize=5)
map.drawmeridians(np.arange(-180., 180., 30.), labels=[0,0,0,1], fontsize=5)
plt.savefig('bath_new.png')



