#!/usr/bin/env python
# encoding: utf-8

import numpy as np

def mgen(g, state, N):
    gen = list(bin(g)[2::])
    gen = chartoint(gen)
    gen = np.array(gen)
    M = len(gen)
    cur_state = list(bin(state)[2::])
    cur_state = chartoint(cur_state)
    cur_state = np.array(cur_state)
    
    out = []
    for _ in range(N):
        out.append(cur_state[M-2])
        sum_gen = sum(gen[1::]*cur_state)
        a = sum_gen % 2
        cur_state = np.append(a, cur_state[0:M-2])
    return out
    
        
def chartoint(l):
    out = []
    for i in range(len(l)):
        out.append(int(l[i]))
    return out