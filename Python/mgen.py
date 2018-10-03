#!/usr/bin/env python
# encoding: utf-8
"""
@author: binshao
@file: mgen.py
@time: 2018/9/27 12:39 AM
"""

# 伪随机序列
# pseudo_random_state表示从界面上获取的状态值，分别对应着7,9,15,16,20,21,23和用户自定义
# init_value表示初始值，用字符串保存；expression为本原表达式的幂，用列表保存
# 字典用伪随机状态作为键，包含初始值和本原表达式的幂的列表作为值，进行一一对应


def generate_prbs(pseudo_random_state, init_value=None, expression=None):
    if pseudo_random_state == 'user_define':
        pseudo_random_sequence = real_calculate_prbs(init_value, expression)
    else:
        pseudo_random_dict = {'prbs_7': ['1111101', [7, 3]],
                              'prbs_9': ['111110101', [9, 4]],
                              'prbs_15': ['111110101101110', [15, 1]],
                              'prbs_16': ['1111101011011100', [16, 12, 3, 1]],
                              'prbs_20': ['11111010110111001011', [20, 3]],
                              'prbs_21': ['111110101101110010111', [21, 2]],
                              'prbs_23': ['11111010110111001011101', [23, 5]]}
        pseudo_random_sequence = real_calculate_prbs(pseudo_random_dict[pseudo_random_state][0],
                                                     pseudo_random_dict[pseudo_random_state][1])
    return pseudo_random_sequence


def real_calculate_prbs(value, expression):

    value_list = [int(i) for i in list(value)]
    pseudo_random_length = (2 << (len(value) - 1))-1
    sequence = []
    for i in xrange(pseudo_random_length):
        mod_two_add = sum([value_list[t-1] for t in expression])
        xor = mod_two_add % 2
        value_list.insert(0, xor)

        sequence.append(value_list[-1])
        del value_list[-1]
    return sequence
