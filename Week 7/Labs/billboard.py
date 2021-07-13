#!/usr/bin/env python
# coding: utf-8

# In[7]:


def music_scraper():
    #import libraries
    import requests
    from bs4 import BeautifulSoup
    import pandas as pd
    from tqdm.notebook import tqdm
    
    #set parameters 
    url = "https://www.billboard.com/charts/hot-100"
    response = requests.get(url)
    response.status_code
    
    #create soup
    soup = BeautifulSoup(response.content, 'html.parser')
    
    #populate lists with parsed content
    song = []
    artist = []
    rank = []

    len_charts = len(soup.select('span.chart-element__information__song'))
    
    for i in tqdm(range(len_charts)):
        song.append(soup.select("span.chart-element__information__song")[i].text)
        artist.append(soup.select("span.chart-element__information__artist")[i].text)
        rank.append(soup.select("span.chart-element__rank__number")[i].text)
        
    billboard100 = pd.DataFrame({"song":song, "artist":artist, "rank":rank})
    
    return billboard100

