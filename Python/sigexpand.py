#!/usr/bin/env python
# encoding: utf-8

import numpy as np


def sigexpand(d, m):
    n = len(d)
    out = np.zeros((m, n))
    out[0, :] = d
    out = out.reshape(1, m*n, order='F')
    return out
