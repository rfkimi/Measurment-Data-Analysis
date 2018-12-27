#!/usr/bin/env python
# encoding: utf-8

import numpy as np
import matplotlib.pyplot as plt
import csv
from mgen import mgen
from sigexpand import sigexpand

mq = mgen(529, 511, 511)
mq = np.array(mq)
N_sample = 2
Tc = 10e-9
dt = Tc/N_sample
gt = np.ones((1, N_sample))
gt = gt[0]
st = sigexpand(2*mq[0:511]-1, N_sample)
# st:array([[]])
st = st[0]
# convolve array st and gt
s = np.convolve(st, gt)
st = s[0:len(st)]

# FFT point
NN = 2048
# read .csv file
mes_data = csv.reader(open('F39HHA1-1T1R1.csv'))
data = []
for row in mes_data:
    data.append(row)
data = data[9:]
I, Q = [], []
for i in range(len(data)):
    if i % 2 == 0:
        I.append(float(data[i][0]))
    else:
        Q.append(float(data[i][0]))

hti = np.convolve(I, st[::-1])/(511*2)
htq = np.convolve(Q, st[::-1])/(511*2)
ht = np.sqrt(np.square(hti)+np.square(htq))
pdp_L = np.square(ht)
pdp = 10*np.log10(pdp_L)

# find max value and index in PDP
pdp_max = np.max(pdp)
pdp_max_index = np.argmax(pdp)
n = pdp_max_index % 1022
n = n + 1022

hti = hti[n-50::]
htq = htq[n-50::]
ht = ht[n-50::]
pdp = pdp[n-50::]
pdp_L = pdp_L[n-50::]

N = 2050
Lh = 1022*N
pdp_array = []
pdp_max_array = []
pdp_max_index_array = []
nse = []
threshold = []
for i in range(N):
    pdp_max_array.append(float(np.max(pdp[i*1022:i*1022+1022])))
    pdp_max_index_array.append(np.argmax(pdp[i*1022:i*1022+1022])+i*1022)
    pdp_array.append(pdp[i*1022:i*1022+1022])
    nse.append(np.mean(pdp_L[pdp_max_index_array[i]+500:pdp_max_index_array[i]+900]))
    threshold.append(10*np.log10(nse[i])+5)

plt.plot(pdp)
plt.xlim((0, 3000))
plt.show()
