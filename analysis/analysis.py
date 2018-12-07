#!/usr/bin/env python
# coding: utf-8

# ## 分析資料
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
# https://zhuanlan.zhihu.com/p/34568684 - 使用Python可視化數據

# ### Prepare

# In[ ]:


# import pandas
import pandas as pd
from datetime import datetime
from dateutil import parser
import numpy as np

# 禁用Anaconda警告
import warnings
warnings.simplefilter('ignore')


# In[ ]:


# 解決Python 3 Matplotlib與Seaborn視覺化套件中文顯示問題  
# https://medium.com/@aitmr1234567890/%E8%A7%A3%E6%B1%BApython-3-matplotlib%E8%88%87seaborn%E8%A6%96%E8%A6%BA%E5%8C%96%E5%A5%97%E4%BB%B6%E4%B8%AD%E6%96%87%E9%A1%AF%E7%A4%BA%E5%95%8F%E9%A1%8C-f7b3773a889b  
# 
# Google 中文字形  
# https://www.google.com/get/noto/#serif-hant  


# In[ ]:


# 圖形相關
from matplotlib.font_manager import FontProperties
myfont = FontProperties(fname=r'NotoSerifCJKtc-Black.otf')

import matplotlib.pyplot as plt
import seaborn as sns
sns.set(font=myfont.get_family())
sns.set_style("whitegrid",{"font.sans-serif":['Microsoft JhengHei']})


# In[ ]:


project = pd.read_csv('re_predictors15.csv')
project.head(2)


# In[ ]:


df = project


# In[ ]:


# figure size
# 單圖
asX = 10
asY = 9
# 多圖
# 12
msX = 42
msY = 28
# 24
hsX = 63
hsY = 28
# varCol only Vars
varCol = list(set(project.columns) - set(['ZONEID', 'TIMESTAMP', 'DATE', 'MONTH', 'HOUR','POWER','SEASON']))
# varApow
varApow = list(set(project.columns) - set(['ZONEID', 'TIMESTAMP', 'DATE', 'MONTH', 'HOUR','SEASON']))


# ### 散點圖 (Scatter)

# #### x: HOUR, y: Var。

# In[ ]:


# 繪製 Scatter, x: HOUR, y: Var。

VARs = varApow
for var in VARs:
    #每 HOUR 的 VAR
    fig = plt.figure(figsize=(asX, asY))
    ax = fig.add_subplot(111)
    #ax.set_title('',fontproperties=myfont)
    ax.set_xlabel("HOUR",fontproperties=myfont)
    ax.set_ylabel(var,fontproperties=myfont)
    ax.scatter(project['HOUR'],project[var],c = 'r',marker = '.')
    plt.savefig('../picture/xHour yVar/'+var+'.png')


# In[ ]:


# 繪製 Scatter, x: HOUR, y: Var。 each Month

VARs = varApow
for var in VARs:
    fig = plt.figure(figsize=(msX, msY))
    for i in range(1, 13):
        df = project[project['MONTH']== i]
        ax = fig.add_subplot(3, 4, i)
        ax.set_title('MONTH = ' + str(i), fontproperties=myfont)
        ax.set_xlabel("HOUR",fontproperties=myfont)
        ax.set_ylabel(var,fontproperties=myfont)
        ax.scatter(df["HOUR"],df[var],c = 'r',marker = '.')
    plt.savefig('../picture/xHour yVar/eMonth/'+var+'.png')


# In[ ]:


# 繪製 Scatter, x: HOUR, y: Var。 each Season

VARs = varApow
df = project
for var in VARs:
    fig = plt.figure(figsize=(asX*2, asY*2))
    for i in range(0, 4):
        df = project[project['SEASON']== i]
        ax = fig.add_subplot(2, 2, i+1)
        ax.set_title('SEASON = ' + str(i), fontproperties=myfont)
        ax.set_xlabel("HOUR",fontproperties=myfont)
        ax.set_ylabel(var,fontproperties=myfont)
        ax.scatter(df["HOUR"],df[var],c = 'r',marker = '.')
    plt.savefig('../picture/xHour yVar/eSeason/'+var+'.png')


# ####  x: Var, y: power。

# In[ ]:


# 繪製 Scatter, x: Var, y: power。

VARs = varCol
for var in VARs:
    #每 HOUR 的 VAR
    fig = plt.figure(figsize=(asX, asY))
    ax = fig.add_subplot(111)
    #ax.set_title('Scatter Plot',fontproperties=myfont)
    ax.set_xlabel(var,fontproperties=myfont)
    ax.set_ylabel("POWER",fontproperties=myfont)
    ax.scatter(project[var],project["POWER"],c = 'r',marker = '.')
    plt.savefig('../picture/xVar yPower/'+var+'.png')


# In[ ]:


# 繪製 Scatter, x: Var, y: power。 HOUR = 4~17

VARs = varCol
df = project[project['HOUR'] >= 4]
df = df[df['HOUR'] <= 17]
for var in VARs:
    #每 HOUR 的 VAR
    fig = plt.figure(figsize=(asX, asY))
    ax = fig.add_subplot(111)
    ax.set_title('HOUR 4~17',fontproperties=myfont)
    ax.set_xlabel(var,fontproperties=myfont)
    ax.set_ylabel("POWER",fontproperties=myfont)
    ax.scatter(df[var],df["POWER"],c = 'r',marker = '.')
    plt.savefig('../picture/xVar yPower/4-17/'+var+'.png')


# In[ ]:


# 繪製 Scatter, x: Var, y: power。 each Hour

VARs = varCol
df = project
for var in VARs:
    #每 HOUR 的 VAR
    fig = plt.figure(figsize=(hsX, hsY))
    for i in range(0, 24):
        df = project[project['HOUR']== i]
        ax = fig.add_subplot(4, 6, i+1)
        ax.set_title('HOUR = ' + str(i), fontproperties=myfont)
        ax.set_xlabel(var,fontproperties=myfont)
        ax.set_ylabel("POWER",fontproperties=myfont)
        ax.scatter(df[var],df["POWER"],c = 'r',marker = '.')
    plt.savefig('../picture/xVar yPower/eHour/'+var+'.png')


# In[ ]:


# 繪製 Scatter, x: Var, y: power。 each Month

VARs = varCol
df = project
for var in VARs:
    #每 Month 的 VAR
    fig = plt.figure(figsize=(msX, msY))
    for i in range(1, 13):
        df = project[project['MONTH']== i]
        ax = fig.add_subplot(3, 4, i)
        ax.set_title('MONTH = ' + str(i), fontproperties=myfont)
        ax.set_xlabel(var,fontproperties=myfont)
        ax.set_ylabel("POWER",fontproperties=myfont)
        ax.scatter(df[var],df["POWER"],c = 'r',marker = '.')
    plt.savefig('../picture/xVar yPower/eMonth/'+var+'.png')


# In[ ]:


# 繪製 Scatter, x: Var, y: power。 each Season

VARs = varCol
df = project
for var in VARs:
    #每 Month 的 VAR
    fig = plt.figure(figsize=(asX*2, asY*2))
    for i in range(0, 4):
        df = project[project['SEASON']== i]
        ax = fig.add_subplot(2, 2, i+1)
        ax.set_title('SEASON = ' + str(i), fontproperties=myfont)
        ax.set_xlabel(var,fontproperties=myfont)
        ax.set_ylabel("POWER",fontproperties=myfont)
        ax.scatter(df[var],df["POWER"],c = 'r',marker = '.')
    plt.savefig('../picture/xVar yPower/eSeason/'+var+'.png')


# #### x: Month, y: Var。

# In[ ]:


# 繪製 Scatter, x: Month, y: Var。

VARs = varCol
for var in VARs:
    #每 HOUR 的 VAR
    fig = plt.figure(figsize=(5, 4))
    ax = fig.add_subplot(111)
    ax.set_title('',fontproperties=myfont)
    ax.set_xlabel('MONTH',fontproperties=myfont)
    ax.set_ylabel(var,fontproperties=myfont)
    ax.scatter(df['MONTH'],df[var],c = 'r',marker = '.')
    plt.savefig('../picture/xMonth yVar/'+var+'.png')


# In[ ]:


# 繪製 Scatter, x: Month, y: Var。 ZONEID = [1, 2, 3]

VARs = varCol
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


# #### x: Var1, y: Var2。

# In[ ]:


# 繪製 Scatter, x: Var1, y: Var2。 

VARs = varCol
df = project
for var1 in VARs:
    for var2 in VARs:
        if var1 != var2:
            fig = plt.figure(figsize=(asX, asY))
            ax = fig.add_subplot(1, 1, 1)
            ax.set_title('x: ' + var1 + ' y: ' + var2, fontproperties=myfont)
            ax.set_xlabel(var1, fontproperties=myfont)
            ax.set_ylabel(var2, fontproperties=myfont)
            ax.scatter(df[var1],df[var2],c = 'r',marker = '.')
            plt.savefig('../picture/xVar1 xVar2/' + var1 + '/' + var2 +'.png')


# In[ ]:


# 繪製 Scatter, x: Var1, y: Var2。 大圖

VARs = varCol
df = project
for var1 in VARs:
    fig = plt.figure(figsize=(msX, msY))
    i = 1
    for var2 in VARs:
        if var1 != var2:
            ax = fig.add_subplot(3, 4, i)
            ax.set_title('x: ' + var1 + ' y: ' + var2, fontproperties=myfont)
            ax.set_xlabel(var1, fontproperties=myfont)
            ax.set_ylabel(var2, fontproperties=myfont)
            ax.scatter(df[var1],df[var2],c = 'r',marker = '.')
            i += 1
    plt.savefig('../picture/xVar1 xVar2/' + var1 +'.png')


# ### 箱型圖 (Box plot)

# In[ ]:


# 繪製 Box, x = Var。

VARs = varApow
df = project
for var in VARs:
    _,ax = plt.subplots(figsize=(asX, asY))
    ax.set_title(var)
    sns_hist = sns.boxplot(data=df[var], ax=ax)
    fig = sns_hist.get_figure()
    fig.savefig('../picture/boxPlot/'+var+'.png')


# In[ ]:


# 繪製 Box, x = Var。 each Month

VARs = varApow
df = project

for var in VARs:
    fig, axes = plt.subplots(figsize=(asX, asY))
    ax = axes
    sns.boxplot(x='MONTH', y=var, data=df, ax=ax) 
    ax.set_xlabel('MONTH') 
    ax.set_ylabel(var) 
    fig.savefig('../picture/boxPlot/eMonth' + '/' +var+'.png')


# In[ ]:


# 繪製 Box, x = Var。 each Hour

VARs = varApow
df = project

for var in VARs:
    fig, axes = plt.subplots(figsize=(asX, asY))
    ax = axes
    sns.boxplot(x='HOUR', y=var, data=df, ax=ax) 
    ax.set_xlabel("HOUR") 
    ax.set_ylabel(var) 
    fig.savefig('../picture/boxPlot/eHour' + '/' +var+'.png')


# In[ ]:


# 繪製 Box, x = Var。 each Season

VARs = varApow
df = project

for var in VARs:
    fig, axes = plt.subplots(figsize=(asX, asY))
    ax = axes
    sns.boxplot(x='SEASON', y=var, data=df, ax=ax) 
    ax.set_xlabel('SEASON') 
    ax.set_ylabel(var) 
    fig.savefig('../picture/boxPlot/eSeason' + '/' +var+'.png')


# ### 核密度估计（kernel density estimation，KDE）。

# In[ ]:


# 核密度图（Kernel Density Plots）
VARs = varApow
project[varApow].plot(kind='density', subplots=True, 
                  layout=(3, 5), sharex=False, figsize=(asX*5, asY*3));


# In[ ]:


# 繪製 KDE。
VARs = varApow
df = project
for var in VARs:
    _,ax = plt.subplots(figsize=(asX, asY))
    sns_hist = sns.distplot(df[var]);
    fig = sns_hist.get_figure()
    fig.savefig('../picture/KDE/'+var+'.png')


# In[ ]:


# 繪製 KDE。 each Month
VARs = varApow
df = project
for var in VARs:
    fig = plt.figure(figsize=(msX, msY))
    for i in range(1, 13):
        df = project[project['MONTH']== i]
        ax = fig.add_subplot(3, 4, i)
        sns_hist = sns.distplot(df[var])
        ax.figure = sns_hist.get_figure()
        ax.set_title('MONTH = ' + str(i), fontproperties=myfont)
    fig.savefig('../picture/KDE/eMonth/'+var+'.png')


# In[ ]:


# 繪製 KDE。 each Hour
VARs = varCol
df = project
for var in VARs:
    print(var)
    fig = plt.figure(figsize=(hsX, hsY))
    for i in range(0, 24):
        df = project[project['HOUR']== i]
        ax = fig.add_subplot(4, 6, i+1)
        sns_hist = sns.distplot(df[var])
        ax.figure = sns_hist.get_figure()
        ax.set_title('HOUR = ' + str(i), fontproperties=myfont)
    fig.savefig('../picture/KDE/eHour/'+var+'.png')


# In[ ]:


# 繪製 KDE。 each Season
VARs = varApow
df = project
for var in VARs:
    fig = plt.figure(figsize=(asX*2, asY*2))
    for i in range(4):
        df = project[project['SEASON']== i]
        ax = fig.add_subplot(2, 2, i+1)
        sns_hist = sns.distplot(df[var])
        ax.figure = sns_hist.get_figure()
        ax.set_title('SEASON = ' + str(i), fontproperties=myfont)
    fig.savefig('../picture/KDE/eSeason/'+var+'.png')


# ### Describe

# In[ ]:


VARs = project.columns[6:]
print(project[VARs].describe())


# ### Try
