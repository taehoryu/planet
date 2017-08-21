#!/usr/bin/env python
# -*- coding: utf-8 -*-

import yt
from yt.mods import *
import glob
import matplotlib
import os
#matplotlib.use('Agg')
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
time_difference=500.0
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
    dens=np.array(my_ray['density'][srt])
  
    my_ray = ds.ortho_ray(0,(0,0))
    plt.semilogy(x_coord,dens,label='t='+filename_time+'s')
    plt.legend()
    plt.ylabel(r'$\rho\/[\mathrm{g}/\mathrm{cm}^{3}]$')
    plt.xlabel(r'$y\/[\mathrm{km}]$')
  #plt.xaxis.set_major_formatter(FormatStrFormatter('10^{%T}'))
  #  plt.xscale('linear')
  #  plt.yscale('linear')
    plt.savefig("x_den.png")

  j=j+1

print("density plot made")
plt.close()
j=0
old_time=-time_difference



for i in profilefilelist:
  #  if np.mod(j,every_nthfile)==0:
  ds=load(i)
  time=float(ds.current_time)
  filename_time=str(int(time))
  if time>=old_time+time_difference:
    old_time=time
    print('Adding lines at t='+filename_time+'s')


    kappa=0.18*1e-9
    SB_constant=5.6704*1e-5
  
  
    my_ray = ds.ortho_ray(0,(0,0))
    srt=np.argsort(my_ray['x'])
    x_coord=np.array(my_ray['x'][srt])/1.e5
    temp=np.array(my_ray['Temp'][srt])
    ent=np.array(my_ray['entropy'][srt])
    dens=np.array(my_ray['density'][srt])
    press=np.array(my_ray['pressure'][srt])/1.e6
    my_ray = ds.ortho_ray(0,(0,0))


    if i==0 :
      temp0=np.array(my_ray['Temp'][srt])
      ent0=np.array(my_ray['entropy'][srt])
      pressure0=np.array(my_ray['pressure'][srt])
      density0=np.array(my_ray['density'][srt])
      location1=np.amin(pressure0)/1e10
      location2=np.amax(pressure0)

#plt.clf()
    plt.plot(x_coord,press,label='t='+filename_time+'s')
    plt.legend()

    plt.ylabel(r'$P\/[\mathrm{bar}=10^{6}\mathrm{dyne}/\mathrm{cm}^2$]')
    plt.xlabel(r'$y\/[\mathrm{km}]$')
  #plt.ylim(location1,location2)
  #plt.xaxis.set_major_formatter(FormatStrFormatter('10^{%T}'))
  #  plt.xscale('linear')
    plt.yscale('log')
  
    plt.savefig("x_P.png")
  
  
  j=j+1

j=0
print("P plot made")
plt.close()
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
  
  
  
    newarray=np.array(my_ray['x'])/1.e5
  
    plt.semilogy(x_coord,temp,label='t='+filename_time+'s')
    plt.legend()
    plt.ylabel(r'$T$ [K]')
    plt.xlabel(r'$y\/[\mathrm{km}]$')
  #plt.legend(loc=3)
  #plt.yscale('linear')
    plt.savefig("x_T.png")
  
  
  
  #print my_ray["density"]
  #print my_ray["pressure"]
  #plt.semilogy(np.array(my_ray['pressure']), np.array(my_ray['density']))
  #plt.ylabel('rho [g/cm^{3}]')
  #plt.xlabel('P [dyne/cm^2=10^-6 bar]')
  #plt.xscale('log')
  #plt.yscale('log')
  #plt.savefig("den_P.png")
  
  j=j+1

print("T plot made")
