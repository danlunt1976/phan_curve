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


nc = NetCDFFile('000_0_1deg_02o.nc', 'r')

print(nc)

lat = nc.variables['lat'][:]
lon = nc.variables['lon1'][:]
bath_orig = nc.variables['depthmask_xancil'][:]

nc.close()

print(lon.shape)
print(lat.shape)
print(bath_orig.shape)
print(bath_orig.size)

plt.contourf(bath_orig)
plt.colorbar()
plt.show()

#map = Basemap(projection='cyl',llcrnrlat=-90,urcrnrlat=90,\
#            llcrnrlon=-180,urcrnrlon=180)

#map= Basemap()

#map.drawmapboundary(fill_color='aqua')
#map.fillcontinents(color='coral',lake_color='aqua')

#map.contourf(lat,lon,bath_orig)
#cb = map.colorbar(temp,"bottom", size="5%", pad="2%")
#plt.title('Original Bathymetry')
#cb.set_label('Model Level')

#plt.savefig('bath_orig.png')





