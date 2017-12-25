# -*- coding: utf-8 -*-
"""
Created on Sun Dec 17 01:17:10 2017

@author: Patrick
"""

import time
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import scipy as sp

from os import listdir
from os.path import isfile, join
from os import chdir
from os import getcwd


path = "C:\\Users\\Patrick\\Desktop\\Thesis In\VaR"
chdir(path)
print(getcwd())

listdir(path)[:]

listdir(path)[:8]

df_list = []
for i in listdir(path)[0:8]:
    df = pd.read_csv(i)
    df_list.append(df)
    
df_list[0]["Adj Close"]
