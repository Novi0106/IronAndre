#!/usr/bin/env python
# coding: utf-8
# %%
def billboard_scraper():
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
        
    billboard100 = pd.DataFrame({"song":song, "artist":artist})
    
    return billboard100


# %%
def basic_recommendation_engine(billboard):
    song = input("What is the name of your song?")
    
    #get the billboard record - if available
    check = billboard[billboard['song'].str.lower().str.replace(" ","").str.contains(song)]
    #get the index of the song in the entry
    index = check.index.tolist()
    
    #run the recommendation
    if len(check) != 0:
        answer = input("Do you mean " + billboard.song[index].values[0] + " by " + billboard.artist[index].values[0] + "?")
        
        #make a song suggestion
        if answer.lower() == 'yes':
            suggestion = billboard.sample().index.tolist()
            print("Nice! This is a hot song! You might also like " + billboard['song'][suggestion].item() + " by " + billboard['artist'][suggestion].item())
        else:
            return clustering(), song


# %%


def clustering():

    import pandas as pd
    import warnings
    warnings.filterwarnings("ignore")
    from sklearn.cluster import KMeans
    from sklearn.preprocessing import StandardScaler

    tracks = pd.read_csv('tracks.csv')

    # load and scale the dataframe with all track details
    numeric = tracks.select_dtypes(exclude = 'object')
    scaler = StandardScaler().fit(numeric)
    scaled = scaler.fit_transform(numeric)
    numeric_scaled = pd.DataFrame(scaled)

    # construct the K means prediction model and reference df
    kmeans = KMeans(n_clusters = 8, random_state=40).fit(numeric_scaled)
    clusters = kmeans.predict(numeric_scaled)
    track_cluster = pd.DataFrame(tracks)
    track_cluster['cluster'] = clusters
    
    return kmeans, track_cluster


# %%
def spotify_recommendation(kmeans, track_cluster, sp, song):
    import pandas as pd
    from IPython.display import IFrame
    # compare user input
    
    
    song_id = sp.search(q = song, type = 'track', limit=1)['tracks']['items'][0]['uri']
    
    features = pd.DataFrame(sp.audio_features(song_id)).drop(columns = ['type','id','uri','track_href','analysis_url', 'time_signature'])
    prediction = kmeans.predict(features)[0]
    suggestion = track_cluster[track_cluster.cluster == prediction].sample(1)
    suggestion = suggestion['name'].values[0]
    artist = sp.search(q = suggestion, type = 'track', limit=1)['tracks']['items'][0]['artists'][0]['name']
    
    track_id = sp.search(q = suggestion, type = 'track', limit=1)['tracks']['items'][0]['id']
    
    message = print(" How about trying out " + str(suggestion) + " by " + str(artist) + "?")
    display(IFrame(src=f"https://open.spotify.com/embed/track/{track_id}",
                             width="320",
                             height="80",
                             frameborder="0",
                             allowtransparency="true",
                             allow="encrypted-media",))


# %%
def GNOD_recommender(client_id, client_secret):
    import spotipy
    from spotipy.oauth2 import SpotifyClientCredentials
    
    sp = spotipy.Spotify(auth_manager=SpotifyClientCredentials(client_id=client_id, client_secret=client_secret))
    billboard = billboard_scraper()
    
    song = input("What is the name of your song? Answer: ").lower().replace(" ", '')

    #get the billboard record - if available
    check = billboard[billboard['song'].str.lower().str.replace(" ","").str.contains(song)]

    #get the index of the song in the entry
    index = check.index.tolist()

    # check if the check has returned a value or not (is the song hot or not?)
    if len(check) == 0:
        song_check = sp.search(q = song, type = 'track', limit=1)['tracks']['items'][0]['name']
        artist_check = sp.search(q = song, type = 'track', limit=1)['tracks']['items'][0]['artists'][0]['name']

        answer = input("Do you mean " + song_check  + " by " + artist_check + "? Answer: ")
        
        if answer.lower() == 'yes':
            kmeans,track_cluster  = clustering()
        
            spotify_recommendation(kmeans, track_cluster, sp, song)
        else:
            print("Hmm looks like there are multiple songs with that title, please try with a different song by the same artist!")
        
    else:
        answer = input("Do you mean " + billboard.song[index].values[0] + " by " + billboard.artist[index].values[0] + "?")
    # provide a suggestion in case the song is the list    
        if answer.lower() == 'yes':
            suggestion = billboard.sample().index.tolist()
            print("Nice! This is a hot song! You might also like " + billboard['song'][suggestion].item() + " by " + billboard['artist'][suggestion].item())
        else:
            print("Well, not so hot after all. We were thinking about different tracks.")

