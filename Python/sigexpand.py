#!/usr/bin/env python
# encoding: utf-8
"""
@author: binshao
@file: sigexpand.py
@time: 2018/9/27 12:38 AM
"""
import numpy as np


def sigexpand(d, m):
    n = len(d)
    out = np.zeros((m, n))
    out[0, :] = d
    out = out.reshape(1, m*n)
    return out
