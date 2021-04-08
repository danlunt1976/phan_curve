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

os.system('cp 000_0_1deg_02o.nc 000_0_1deg_02o_new.nc')

# Read original data 
nc1 = NetCDFFile('000_0_1deg_02o.nc', 'r')
print(nc1)
lat = nc1.variables['lat'][:]
lon1 = nc1.variables['lon1'][:]
bath_orig = nc1.variables['depthmask_xancil'][:]
nc1.close()


# Modify data 
bath_new=copy.deepcopy(bath_orig)
bath_new[:,:]=15.0


# Write new data 
nc2 = NetCDFFile('000_0_1deg_02o_new.nc', 'r+')
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
cb=map.colorbar(cs,"bottom", size="5%", pad="2%")
plt.title('Original Bathymetry')
cb.set_label('Model Level')
plt.savefig('bath_orig.png')



cs=map.pcolor(lon1, lat, bath_new, cmap="viridis", vmin=0, vmax=20, latlon=True)
cb=map.colorbar(cs,"bottom", size="5%", pad="2%")
plt.title('New Bathymetry')
cb.set_label('Model Level')
plt.savefig('bath_new.png')



