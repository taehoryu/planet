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
max_data=90000
j=0
every_nthfile=3
#print 'Listing all profile/dat files'
profilefilelist = sorted(glob.glob('plt*'), key=lambda name: int(name[3:-4]))
#raw_input('Press ENTER to continue...')
#print profilefilelist
old_time=0
time_difference=1500.0
old_time=-time_difference



for i in profilefilelist:
  #  if np.mod(j,every_nthfile)==0:
  ds=load(i)
  time=float(ds.current_time)
  filename_time=str(int(time))
  if time>=old_time+time_difference:
    old_time=time
    print('Adding lines at t='+filename_time+'s')
    location1=ds.find_max('Temp')
    location2=ds.find_min('Temp')

    kappa=0.18*1e-9
    SB_constant=5.6704*1e-5


    ad=ds.all_data()
    my_ray = ds.ortho_ray(0,(0,0))
    srt=np.argsort(my_ray['x'])
    x_coord=np.array(my_ray['x'][srt])/1.e5
    temp=np.array(my_ray['Temp'][srt])
    ent=np.array(my_ray['entropy'][srt])
    cs=np.array(my_ray['soundspeed'][srt])/1.e5


    newarray=np.array(my_ray['x'])/1.e5

    plt.semilogy(x_coord,cs,label='t='+filename_time+'s')
    plt.legend()
    plt.ylabel(r'$c_{s}$ [km/s]')
    plt.xlabel(r'$y\/[\mathrm{km}]$')
    #  plt.xscale('linear')
    plt.yscale('linear')
    plt.savefig("x_cs.png")


  j=j+1
