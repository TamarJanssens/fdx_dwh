# library imports
# %%
import pandas as pd
import os
from src import project_structure
projectRoot = project_structure.get_root(__file__)
print(projectRoot)
print(f'current workind dir: {os.getcwd()} \n-----------')
pd.set_option('display.max_rows',None)


def to_camel_case(stringparam):
    # Remove leading/trailing whitespace and split the word

    words = stringparam.strip().split(' ')

    # Capitalize each word except the first one
    capitalized_words = [words[0].lower()] + [w.capitalize() for w in words[1:]]

    # Join the capitalized words without spaces
    camel_case_word = ''.join(capitalized_words)
    return camel_case_word

def remove_characters(mystr, schar_string,replace_by=''):
    newstring = mystr
    for char in schar_string:
        newstring = newstring.replace(char,replace_by)
    return newstring

def dataframe_overview(df):
    return pd.DataFrame({
        'Column': df.columns,
        'Dtype': df.dtypes,
        'Nunique': df.nunique()
    }).set_index('Column')
    
# %%

sales = pd.read_csv('../data/Amazon Sale Report.csv', low_memory=False)
sales = sales.drop('Unnamed: 22',axis=1)
dtypes = {
    'Order ID': 'str',
    'Date': 'datetime64[ns]',
    'Status': 'category',
    'Fulfilment': 'category',
    'Sales Channel ': 'category',
    'ship-service-level': 'category',
    'Style': 'category',
    'SKU': 'category',
    'Category': 'category',
    'Size': 'category',
    'ASIN': 'category',
    'Courier Status': 'category',
    'currency': 'category',
    'ship-city': 'category',
    'ship-state': 'category',
    'ship-country': 'category',
    'promotion-ids': 'category',
    'fulfilled-by': 'category',
    'Qty': 'int32',
    'Amount': 'float64',
    'ship-postal-code': 'object',
    'B2B': 'bool'
}
sales = sales.astype(dtypes)

# map camelcase function to list
renames=[to_camel_case(remove_characters(x,"-:",replace_by=" ")) for x in sales.columns.tolist()]
# create a dictionary to rename column names
colNames = dict(zip(sales.columns.tolist(),renames))
# rename columns in df
sales = sales.rename(columns = colNames)

# compute n_unique values over df to identify categorical data
df_overview = dataframe_overview(sales).reset_index()

# set category only if n unique values <= 100
df_overview['new_type'] = df_overview.apply(lambda x: 'object' if x['Dtype']=='category' and x['Nunique']>100 else x['Dtype'], axis =1)
# %%
# implement category type overwrites
sales = sales.astype(dict(zip(df_overview['Column'],df_overview['new_type']))) 
# %%
sales.to_csv('../data/python_output/sales_cleaned.csv')
# %%
