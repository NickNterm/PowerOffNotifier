import requests
from bs4 import BeautifulSoup
import pandas as pd
import psycopg2
import json
from collections import OrderedDict

from soupsieve import select

# establishing the connection with the database
conn = psycopg2.connect(
    database="PowerOffNotifier", user='postgres', password='admin', host='127.0.0.1', port='5432'
)

# url of the site i want to get the option names/values
getOptionUrl = "https://siteapps.deddie.gr/Outages2Public"

# url of the site i want to get the table data
postUrl = "https://siteapps.deddie.gr/Outages2Public/?Length=4"

# read the html of the page
page = requests.get(getOptionUrl)
html = page.text
soup = BeautifulSoup(html, "lxml")

# reads the lists for deparments and values from the html
option = soup.findAll("option")
nomoi = []
values = []
for nomos in option:
    values.append(nomos.attrs.get("value"))
    nomoi.append(nomos.contents[0])
del nomoi[0]
del values[0]
del nomoi[len(nomoi)-1]
del values[len(values)-1]

# for loop so that i get every table for each deparment in the greece
for i in range(len(values)):
    # passing the necessary variables
    page = requests.post(postUrl, json={
        "PrefectureID": values[i],
        "MunicipalityID": "",
        "X-Requested-With": "XMLHttpRequest",
    })

    # html response
    html = page.text
    # read the table
    tables = pd.read_html(html)  # Returns list of all tables on page
    # for loop to read each record on the table
    for soupa_row in tables[0].iterrows():
        # the row data
        row = soupa_row[1].values
        # create a cursor to select if the record is duplicated
        cursorS = conn.cursor()
        select_current = """ SELECT start_date, end_date, department, municipality, description, note_number, type FROM deddhe WHERE start_date LIKE '""" + str(row[0])+"""' AND end_date LIKE '""" + str(row[1])+"""' AND department LIKE '""" + str(
            nomoi[i])+"""' AND municipality LIKE '""" + str(row[2])+"""' AND description LIKE '""" + str(row[3]).replace("\'", "\"")+"""' AND note_number LIKE '""" + str(row[4])+"""' AND type LIKE '""" + str(row[5])+"""' ;"""
        cursorS.execute(select_current)
        selected = cursorS.fetchall()
        cursorS.close()
        # if the record isn't duplicate add it to the database
        if len(selected) == 0:
            print("NOT DUPLICATE")
            postgres_insert_query = """ INSERT INTO deddhe (start_date, end_date, department, municipality, description, note_number, type) VALUES (%s,%s,%s,%s,%s,%s,%s)"""

            record_to_insert = (row[0], row[1], nomoi[i],
                                row[2], str(row[3]).replace("\'", "\""), str(row[4]), row[5])
            cursorI = conn.cursor()
            cursorI.execute(postgres_insert_query, record_to_insert)
            conn.commit()
            cursorI.close()
