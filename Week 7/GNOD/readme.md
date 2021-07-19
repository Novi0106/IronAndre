## GNOD Music Recommender

## Table of contents
- [Final GNOD Recommender](https://github.com/Novi0106/IronAndre/blob/main/Week%207/GNOD/GNOD%20Final.ipynb)
- [Complete Material Used](https://github.com/Novi0106/IronAndre/tree/main/Week%207/GNOD/Archive)

## Background
The purpose of this project is to use the Spotipy API to compose a baisc music recommendation tool.

## Method
We will scrape both the Billboard100 as well as a playlist on Spotify to collect the necessary
data, which we will then use to generate clusters.

For the creation of the clusters we will use unsupervised machine learning, more precisely a K-Means model
that we run on basis of the audio-features we get per song from Spotipy

Finally, these clusters are used to predict the music taste via user input on a track-by-track basis.

## Data specifics
For the clustering we used a Hip Hop Playlist, which consisted of 176 songs. Subsequently, the scraping was done
by getting all artists from that playlist, searching for their album discography, scraping each track from each
album, and finally fetching audio features for each song. The final population used for K-Means was roughly
10,500 songs exclusively from the Hip Hop genre. In order to make the recommender applicable for other genres
we would simply repeat the scraping process.
