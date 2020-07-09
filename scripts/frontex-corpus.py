#!/usr/bin/env python
# coding: utf-8

'''Récupération des textes des communiqués de presse de l'agence Frontex'''

import requests
from bs4 import BeautifulSoup
import pandas as pd

### Métadonnées des communiqués de presse ###

press = pd.read_csv("metadata.csv", sep = ",")
output = pd.DataFrame()

### Le script parcoure tous les liens présents dans les métadonnées ###

for link in press['id']:

	### Récupération du texte ###

	URL = "https://frontex.europa.eu/media-centre/news-release/" + str(link)
	page = requests.get(URL)
	soup = BeautifulSoup(page.content, 'lxml')

	### Écriture des résultats dans un fichier texte ###

	content = soup.select_one("div.text-content").text ## Stratégie alternative : # content = soup.select_one("div.text-content").contents #res = ''.join(map(str, content))
	path = link + ".txt"
	with open(path, 'w') as file:
		file.write(content)
