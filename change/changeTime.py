
# coding: utf-8

# In[3]:


# import pandas
import pandas as pd
from datetime import datetime, timedelta
from dateutil import parser
import dateutil


# In[88]:
def change(num):
	read_f = pd.read_csv("C:/Users/acer/Desktop/project/project/Solar/Task "+str(num)+"/predictors"+str(num)+".csv")
	read_f.head()


	# In[101]:


	TIMESTAMP = read_f['TIMESTAMP']


	# In[90]:


	read_f['TIMESTAMP'] = pd.to_datetime(read_f['TIMESTAMP'])
	read_f['TIMESTAMP'] = (read_f['TIMESTAMP'] + timedelta(hours=8))


	# In[91]:


	read_f['DATE'] = read_f['TIMESTAMP'].dt.date
	read_f['DATE']


	# In[92]:


	read_f['HOUR'] = read_f['TIMESTAMP'].dt.hour
	read_f['HOUR']


	# In[103]:
	read_f['MONTH'] = read_f['TIMESTAMP'].dt.month
	read_f['MONTH']


	read_f['SEASON'] = read_f['MONTH']
	sLst = ['Spring', 'Summer', 'Autumn', 'Winter']
	pre = 9	
	for i in range(4):
		read_f['SEASON'].replace([pre, pre %12+1, (pre+1)%12+1], sLst[i], inplace=True)
		pre = (pre + 2) % 12 + 1
	for i in range(4):		
		read_f['SEASON'].replace(sLst[i], i, inplace=True)
	read_f['TIMESTAMP'] = TIMESTAMP
	output = pd.DataFrame(read_f,columns=['ZONEID','TIMESTAMP','DATE','MONTH', 'HOUR','SEASON','VAR78','VAR79','VAR134','VAR157','VAR164','VAR165','VAR166','VAR167','VAR169','VAR175','VAR178','VAR228','POWER'])
	output


	# In[98]:


	output.to_csv("ok/re_predictors"+str(num)+".csv", index = False)
	print("OK!", num)
	return
for i in range(1,16):
	change(i)
print("Sucess!")
