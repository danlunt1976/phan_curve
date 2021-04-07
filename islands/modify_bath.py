"""
Need to do: 
module add anaconda/2.7-5.0.1
python modify_bath.py


"""

import netCDF4
from netCDF4 import Dataset

import numpy as np

AllVars = Dataset("000_0_1deg_02o.nc", "r")

bath_orig=AllVars["depthmask_xancil"][:, :]



print(bath_orig)

