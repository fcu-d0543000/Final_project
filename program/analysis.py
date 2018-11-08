
# coding: utf-8

# ### 分析資料
# 
# 78 雲液態水含量的垂直積分  單位（kg m ** - 2）
# 79 雲冰水含量的垂直積分  單位（kg m ** - 2）
# 134 表面壓力  單位：Pa
# 157 相對濕度  單位（％）
# 164 總雲量  單位：（0-1）
# 165 10米U風部件  單位（m s ** - 1）
# 166 米V風分量  單位（m s ** - 1）
# 167 2米溫度  單位：K
# 169 表面太陽輻射  單位：J m-2
# 175 表面熱輻射下降  單位：J m-2
# 178 大氣頂部的淨太陽輻射  單位：J m-2
# 228 總降水量  單位：m 
# 
# https://zhuanlan.zhihu.com/p/34568684 - 使用Python可视化数据

# In[1]:


#import pandas
import pandas as pd
from datetime import datetime
from dateutil import parser
import numpy as np

# 禁用Anaconda警告
import warnings
warnings.simplefilter('ignore')


# 解決Python 3 Matplotlib與Seaborn視覺化套件中文顯示問題  
# https://medium.com/@aitmr1234567890/%E8%A7%A3%E6%B1%BApython-3-matplotlib%E8%88%87seaborn%E8%A6%96%E8%A6%BA%E5%8C%96%E5%A5%97%E4%BB%B6%E4%B8%AD%E6%96%87%E9%A1%AF%E7%A4%BA%E5%95%8F%E9%A1%8C-f7b3773a889b  
# 
# Google 中文字形  
# https://www.google.com/get/noto/#serif-hant  

# In[37]:


# 圖形相關
from matplotlib.font_manager import FontProperties
myfont = FontProperties(fname=r'NotoSerifCJKtc-Black.otf')

import matplotlib.pyplot as plt
import seaborn as sns
sns.set(font=myfont.get_family())
sns.set_style("whitegrid",{"font.sans-serif":['Microsoft JhengHei']})

# In[3]:


project = pd.read_csv('re_predictors15.csv')
project.head(2)

#多一個 Month Col
project['MONTH'] = pd.to_datetime(project['TIMESTAMP']).dt.month
#丟棄 index col
project.drop(['Unnamed: 0'],axis=1,inplace=True)

df = project

# 繪製 Scatter, x: HOUR, y: Var。
"""
VARs = list(set(project.columns) - set(['ZONEID', 'TIMESTAMP', 'DATE', 'MONTH', 'HOUR']))
for var in VARs:
    #每 HOUR 的 VAR
    fig = plt.figure(figsize=(5, 4))
    ax = fig.add_subplot(111)
    #ax.set_title('',fontproperties=myfont)
    ax.set_xlabel("HOUR",fontproperties=myfont)
    ax.set_ylabel(var,fontproperties=myfont)
    ax.scatter(project['HOUR'],project[var],c = 'r',marker = '.')
    plt.savefig('../picture/xHour yVar/'+var+'.png')
"""

# 繪製 Scatter, x: HOUR, y: Var。  HOUR = 4~17
"""
VARs = list(set(project.columns) - set(['ZONEID', 'TIMESTAMP', 'DATE', 'MONTH', 'HOUR']))
df = project[project['HOUR'] >= 4]
df = df[df['HOUR'] <= 17]
for var in VARs:
    #每 HOUR 的 VAR
    fig = plt.figure(figsize=(5, 4))
    ax = fig.add_subplot(111)
    ax.set_title('HOUR 4~17',fontproperties=myfont)
    ax.set_xlabel("HOUR",fontproperties=myfont)
    ax.set_ylabel(var,fontproperties=myfont)
    ax.scatter(df['HOUR'],df[var],c = 'r',marker = '.')
    plt.savefig('../picture/xHour yVar/4-17/'+var+'.png')
"""

# 繪製 Scatter, x: Var, y: power。
"""
VARs = list(set(project.columns) - set(['ZONEID', 'TIMESTAMP', 'DATE', 'MONTH', 'HOUR','POWER']))
for var in VARs:
    #每 HOUR 的 VAR
    fig = plt.figure(figsize=(5, 4))
    ax = fig.add_subplot(111)
    #ax.set_title('Scatter Plot',fontproperties=myfont)
    ax.set_xlabel(var,fontproperties=myfont)
    ax.set_ylabel("POWER",fontproperties=myfont)
    ax.scatter(project[var],project["POWER"],c = 'r',marker = '.')
    plt.savefig('../picture/xVar yPower/'+var+'.png')
"""

# 繪製 Scatter, x: Var, y: power。 HOUR = 4~17
"""
VARs = list(set(project.columns) - set(['ZONEID', 'TIMESTAMP', 'DATE', 'MONTH', 'HOUR','POWER']))
df = project[project['HOUR'] >= 4]
df = df[df['HOUR'] <= 17]
for var in VARs:
    #每 HOUR 的 VAR
    fig = plt.figure(figsize=(5, 4))
    ax = fig.add_subplot(111)
    ax.set_title('HOUR 4~17',fontproperties=myfont)
    ax.set_xlabel(var,fontproperties=myfont)
    ax.set_ylabel("POWER",fontproperties=myfont)
    ax.scatter(df[var],df["POWER"],c = 'r',marker = '.')
    plt.savefig('../picture/xVar yPower/4-17/'+var+'.png')
"""

# 繪製 Scatter, x: Month, y: Var。
"""
VARs = list(set(project.columns) - set(['ZONEID', 'TIMESTAMP', 'DATE', 'MONTH', 'HOUR']))
for var in VARs:
    #每 HOUR 的 VAR
    fig = plt.figure(figsize=(5, 4))
    ax = fig.add_subplot(111)
    ax.set_title('',fontproperties=myfont)
    ax.set_xlabel('MONTH',fontproperties=myfont)
    ax.set_ylabel(var,fontproperties=myfont)
    ax.scatter(df['MONTH'],df[var],c = 'r',marker = '.')
    plt.savefig('../picture/xMonth yVar/'+var+'.png')
"""

# 繪製 Scatter, x: Month, y: Var。 Stamp = [1, 2, 3]
"""
VARs = list(set(project.columns) - set(['ZONEID', 'TIMESTAMP', 'DATE', 'MONTH', 'HOUR']))
for i in range(1, 4):
    df = project[project['ZONEID'] == i]
    for var in VARs:
        #每 HOUR 的 VAR
        fig = plt.figure(figsize=(5, 4))
        ax = fig.add_subplot(111)
        ax.set_title('ZONEID '+str(i), fontproperties=myfont)
        ax.set_xlabel('MONTH', fontproperties=myfont)
        ax.set_ylabel(var, fontproperties=myfont)
        ax.scatter(df['MONTH'], df[var], c = 'r', marker = '.')
        plt.savefig('../picture/xMonth yVar/ZONEID'+str(i)+'/'+var+'.png')
"""

# 繪製 Box, x = Var
"""
VARs = list(set(project.columns) - set(['ZONEID', 'TIMESTAMP', 'DATE', 'MONTH', 'HOUR']))
for var in VARs:
    _,ax = plt.subplots(figsize=(5, 4))
    ax.set_title(var)
    sns_hist = sns.boxplot(data=df[var], ax=ax)
    fig = sns_hist.get_figure()
    fig.savefig('../picture/boxPlot/'+var+'.png')
"""

# describe
"""
VARs = list(set(project.columns) - set(['ZONEID', 'TIMESTAMP', 'DATE', 'MONTH', 'HOUR']))
print(df[VARs[:4]].describe())
print(df[VARs[4:8]].describe())
print(df[VARs[8:]].describe())
"""



print('Finished.')