# -*- coding: utf-8 -*-
"""
Created on Mon Jun 27 11:31:08 2016

@author: rmadhavan
"""

import pandas as pd
import prettytable as pt
train1 = pd.read_csv('C:/renjith/datascience/git/data/grupobimbo/train.csv', index_col = None)
train1.columns = ["week", "depot", "channel", "route", "client", "product", "sales_units", "sales", "returns_units", "returns", "demand"]
#pd.describe_option('display')
pd.set_option('display.width', None)
pd.reset_option('display.max_colwidth')
pd.options.display.width = 180
print(train1[0:10])




