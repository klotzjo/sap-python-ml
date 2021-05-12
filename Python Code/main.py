# -*- coding: utf-8 -*-
"""
This program trains the model that is later called through the BTP.
This program has to be runed at least once sucessfully before uploading the app to the BTP.
Please change the ML model according to your data and analyse. 
"""

###########################################################################################################################################################################
'''Library and Module Imports'''
###########################################################################################################################################################################

###External###


import pandas as pd
import numpy as np
import pickle
from sklearn.ensemble import RandomForestRegressor




###########################################################################################################################################################################
'''Global Parameters and Settings'''
###########################################################################################################################################################################

###Path###

# Please change to the datatype your dataset is saved as
GLOBAL_SET_PATH_DATA='../data/data.xlsx'

GLOBAL_SET_PATH_SAVED_MODEL='/app'



########################################
'''ML Parameters'''
########################################

# If you use sepcific Parameters you can insert them here

###########################################################################################################################################################################
'''Function to get data '''
###########################################################################################################################################################################


def get_costumer_data():
    

    df_origin_data=pd.read_excel(GLOBAL_SET_PATH_DATA,index_col=0)
    
    return df_origin_data



###########################################################################################################################################################################
'''Functions for data processing'''
###########################################################################################################################################################################


# handling missing costumer data
# here are examples for what to include if you want to handle mussing data
# this step is optional and is dependent on your data set
""" def handle_missing_costumer_data(data):
    
    data_cleansed=data.copy()
    
    if whole column is empty drop it
     for col in data.columns:
         if len(data[col].values)==len(data[data[col].isna()==True]) and not col=='y':
            data_cleansed=data_cleansed.drop(col,1)
      
    
    
    for col in data_cleansed.columns:
        #if none, set mean
        if 'Value' in col:
            data_cleansed[col]=data_cleansed[col].fillna(value=data_cleansed[col].mean())
       
        
    return data_cleansed   
 """

   
   
###########################################################################################################################################################################
'''Main Program'''
###########################################################################################################################################################################


#main process orchestrating function called from if __name__ == '__main__':
def main():
   
    
    ####################################################################################################################################################
    '''Get data'''
    ####################################################################################################################################################
    
    
    df_data=get_costumer_data()
    
    
   # This step  is used only if there is an handling for missing data is uncluded
    """ df_data=handle_missing_costumer_data(df_origin_data)  """
    
   
     
    ####################################################################################################################################################
    '''In,- Output Split'''
    ####################################################################################################################################################

    # Please insert here the name of your y-value and the features you want to use (x)
    y=df_data['y'].values
    X=df_data.drop('y',1).values
    
    
   
    ####################################################################################################################################################
    '''RF Model'''
    ####################################################################################################################################################
    
    # here you can choose the model you want to use
    # as an example here an unspecific RandomForestRegressor is used
    model=RandomForestRegressor(n_estimators=100,criterion='mae')
    model.fit(X,y)


    ####################################################################################################################################################
    '''Saving model as pickle File'''
    ####################################################################################################################################################
    
    pkl_filename = "app/pickle_model.pkl"
    with open(pkl_filename, 'wb') as file:
        pickle.dump(model, file)

   
 
if __name__ == '__main__':
    main()
    