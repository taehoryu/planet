#!/usr/bin/env python
# -*- coding: utf-8 -*-

import yt
from yt.mods import *
import glob
import matplotlib
import os
import matplotlib
from matplotlib import pyplot as plt
from matplotlib.ticker import FormatStrFormatter
import numpy as np
np.set_printoptions(threshold=np.inf)

delta_i=10000
i=0
max_data=1000000
every_nthfile=15
j=0
profilefilelist = sorted(glob.glob('plt*'), key=lambda name: int(name[3:-4]))
number_cell=2000
old_time=0
time_difference=500.0
old_time=-time_difference
for i in profilefilelist:
  #if np.mod(j,every_nthfile)==0:
  
  ds=load(i)
  time=float(ds.current_time)
  filename_time=str(int(time))
  if time>=old_time+time_difference:
    old_time=time
    print('Adding lines at t='+filename_time+'s')

    location1=ds.find_max('pressure')
    location2=ds.find_min('pressure')

    kappa=0.18*1e-9
    SB_constant=5.6704*1e-5


    ad=ds.all_data()
    my_ray = ds.ortho_ray(0,(0,0))
    srt=np.argsort(my_ray['x'])
    condition=srt!=0
    condition1=srt!=number_cell
    srt_ext=np.extract(condition&condition1,srt)

    x_coord=np.array(my_ray['x'][srt])/1.e5
    temp=np.array(my_ray['Temp'][srt])
    ent=np.array(my_ray['entropy'][srt])
    dens=np.array(my_ray['density'][srt])
    pressure=np.array(my_ray['pressure'][srt])
    if j==0 :
      temp0=np.array(my_ray['Temp'][srt])
      ent0=np.array(my_ray['entropy'][srt])
      pressure0=np.array(my_ray['pressure'][srt])
      density0=np.array(my_ray['density'][srt])


    diff_P=abs(pressure0-pressure)/pressure0



    newarray=np.array(my_ray['x'])/1.e5


#  plt.ylim(10,10000)
#  plt.xlim(5000,20000)

#plt.clf()
    plt.semilogy(pressure0,diff_P,label='t='+filename_time+'s')
    plt.legend()

    plt.ylabel(r'$|\Delta P/P|$')
    plt.xlabel(r'$P$')
#  plt.arrow(0.2*10**8,8000,-0.1*10**8,2000,head_width=0.5e3, head_length=3e6)
  #plt.xaxis.set_major_formatter(FormatStrFormatter('10^{%T}'))#
    plt.xscale('log')
#  plt.yscale('linear')
    plt.savefig("x_P_diff_1000.png")




  j=j+1

