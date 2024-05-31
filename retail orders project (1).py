#!/usr/bin/env python
# coding: utf-8

# In[1]:


#import libraries
import  pandas as pd


# In[2]:


#read data from the file n handle null values
df =pd.read_csv("orders.CSV",  na_values=['Not Available', 'unknown'])
#df.head(2)
#df["Ship Mode"].unique()


# In[8]:


#rename columns names...lower case and replace space with underscare
#df.rename(columns={'Order Id':'order_id','City':'city'})
#df.columns.str.lower()
#df.columns=df.columns.str.lower()
#df.columns=df.columns.str.replace(' ','_')
df.head(2)


# In[11]:


#derive  new columns discount, sale price and profit
#df['discount']=df['list_price']*df['discount_percent']*.01
#df['sale_price']=df['list_price']-df['discount']
#df['profit']=df['sale_price']-df['cost_price']
df.head(240)


# In[18]:


#convert order date from object data type to dateti
df['order_date']=pd.to_datetime(df['order_date'])
df.info()


# In[1]:


#drop cost price,list price and discount% columns
#df.drop(columns=['list_price','cost_price','discount_percent'],inplace=True)


# In[42]:


#load the data into sql server using replace optionSS
import sqlalchemy as sal
engine=sal.create_engine('mssql://DESKTOP-0V0GSE1/demo?driver=ODBC+Driver+17+for+SQL+Server')
conn=engine.connect()


# In[44]:


#load the data into sql server using append option
df.to_sql('df_orders',con=conn, index=False, if_exists='append')


# In[40]:


df.columns


# In[34]:


df.head()


# In[37]:


df.head()


# In[ ]:


import pandas as pd
mydata= pd.read_excel("d:/")

