#!/usr/bin/env python
# encoding: utf-8
"""
@author: binshao
@file: PDP_main.py
@time: 2018/10/3 10:46 PM
"""

import numpy as np
import matplotlib.pyplot as plt
import csv
from scipy import signal
from mgen import generate_prbs
from sigexpand import sigexpand

mq = generate_prbs('prbs_9')
mq = np.array(mq)
N_sample = 2
Tc = 10e-9
dt = Tc/N_sample
gt = np.ones((1, N_sample))
st = sigexpand(2*mq[0:510]-1, N_sample)
# st:array([[]])
st = st[0]
# convolve array st and gt
s = signal.convolve(st, gt)
st = s[0:len(st)-1]

NN = 2048
# read .csv file
test = csv.reader(open('test.csv'), encoding='utf-8')
for row in test:
    print row
