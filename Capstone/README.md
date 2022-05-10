This folder contains all of my work for the DS3002 Capstone Project. In this readme I will explain how to navigate through the project/explain each file.


'create_datawarehouse.sql' and 'product_inserts.sql' are the two SQL files in which I create the product and date dimensions and populate the corresponding tables. 'sales_rep_data.csv' is the csv file in which I create the data for the fictional sales represenatatives at the company. This is the data that was uploaded to my MongoDB database.

'HaydenFrenchCapstone.ipynb' is the main Jupyter Notebook file where I import data from the API, my MySQL database, and my MongoDB database and export the dimension tables as .json files.

'date.json', 'products.json', 'sales_reps.json', and 'transactions.json' are the aforementioned json files. These files will need to be uplaoded to Databricks.

'Capstone.dbc', 'Capstone.sql', and 'Capstone.html' are all just different formats of my Databricks Notebook. The Notebook explains how to upload the json files to the Databricks FileStore. One uploaded the json files are cleaned and joined to create a fact table, which is then exported as a .csv file.

'export.csv' is the aforementioned csv file which is a fact table representing sales for my fictional company. 'export.csv' is the raw export, but the file 'visualizations.xlsx' included the same data along with some vizualizations and further analysis in an Excel Spreadsheet. All of the visualizations can also be viewed as pngs in the folder 'visualization_pngs'.
