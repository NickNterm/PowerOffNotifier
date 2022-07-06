import requests
from bs4 import BeautifulSoup
import pandas as pd
import psycopg2
import json
from collections import OrderedDict

from soupsieve import select
# establishing the connection
conn = psycopg2.connect(
    database="PowerOffNotifier", user='postgres', password='admin', host='127.0.0.1', port='5432'
)

URL = "https://siteapps.deddie.gr/Outages2Public"
postUrl = "https://siteapps.deddie.gr/Outages2Public/?Length=4"
page = requests.get(URL)
html = page.text
soup = BeautifulSoup(html, "lxml")


def html_to_json(content, indent=None):
    soup = BeautifulSoup(content, "html.parser")
    rows = soup.find_all("tr")

    headers = {}
    thead = soup.find("thead")
    if thead:
        thead = thead.find_all("th")
        for i in range(len(thead)):
            headers[i] = thead[i].text.strip().lower()
    data = []
    for row in rows:
        cells = row.find_all("td")
        if thead:
            items = {}
            for index in headers:
                items[headers[index]] = cells[index].text
        else:
            items = []
            for index in cells:
                items.append(index.text.strip())
        data.append(items)
    return json.dumps(data, indent=indent)


# h lista me nomoi
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

for i in range(len(values)):
    page = requests.post(postUrl, json={
        "PrefectureID": values[i],
        "MunicipalityID": "",
        "X-Requested-With": "XMLHttpRequest",
    })
    # html response
    html = page.text

    # read the table
    tables = pd.read_html(html)  # Returns list of all tables on page
    for soupa_row in tables[0].iterrows():
        row = soupa_row[1].values
        cursorS = conn.cursor()
        select_current = """ SELECT start_date, end_date, department, municipality, description, note_number, type FROM deddhe WHERE start_date LIKE '""" + str(row[0])+"""' AND end_date LIKE '""" + str(row[1])+"""' AND department LIKE '""" + str(
            nomoi[i])+"""' AND municipality LIKE '""" + str(row[2])+"""' AND description LIKE '""" + str(row[3])+"""' AND type LIKE '""" + str(row[5])+"""' ;"""
        cursorS.execute(select_current)
        selected = cursorS.fetchall()
        # print(select_current)
        # print(len(selected))
        if len(selected) == 0:
            print("NOT DUPLICATE")
            postgres_insert_query = """ INSERT INTO deddhe (start_date, end_date, department, municipality, description, note_number, type) VALUES (%s,%s,%s,%s,%s,%s,%s)"""

            record_to_insert = (row[0], row[1], nomoi[i],
                                row[2], str(row[3]).replace("\'", "\""), str(row[4]).replace("\'", "\""), row[5])

            print(postgres_insert_query, record_to_insert)
            cursorI = conn.cursor()
            cursorI.execute(postgres_insert_query, record_to_insert)
            conn.commit()
            cursorI.close()
        # else:
            #print("DUPLICATE FOUND")
        cursorS.close()
