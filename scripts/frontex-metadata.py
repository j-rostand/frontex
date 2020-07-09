#!/usr/bin/env python
# coding: utf-8

'''Récupération des métadonnées de l'ensemble des communiqués de presse de l'agence Frontex'''

import requests
from bs4 import BeautifulSoup
import pandas as pd
import csv

export = pd.DataFrame()

### Le script parcoure les 89 pages de communiqués de presse (28 juin 2020) ### 

for num in range(1, 89):

    ### Récupération du contenu de chaque page ###

    URL = "https://frontex.europa.eu/media-centre/news-release/?p=" + str(num)
    page = requests.get(URL)
    soup = BeautifulSoup(page.content, 'lxml')
    content = soup.select_one("#content")

    ### Le script parcoure tous les articles de la page ###

    articles = content.find_all('article')
    
    output = {} 

    for article in range(0, len(articles)):

        ### Récupération des métadonnées de chaque article de la page ###

        res = {}

        link = articles[article].find("h3").contents[0].get('href')
        res['id'] = link[27:] 
        res['title'] = articles[article].find("h3").contents[0].text
        res['date'] = articles[article].find("span", class_="date").text
        
        output[str(article)] = res

    ### Collection des métadonnées de tous articles de chaque page ###

    headers = ['id', 'title', 'date']
    export = export.append(pd.DataFrame.from_dict(output, orient='index', columns=headers))

### Écriture dans un csv conformes aux normes de TXM ###

export = export.sort_values(by=['id'])
export.to_csv("metadata.csv", index=False, sep=",", quoting=csv.QUOTE_ALL, encoding='utf-8')
