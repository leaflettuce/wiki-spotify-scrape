import spotipy
import csv
import unicodedata

reader = csv.reader(open('artist_names.csv', 'r'))

writer = csv.writer(open('artist_ids.csv', 'wb'))

sp = spotipy.Spotify()

check = []
numb = 0

for row in reader:
    numb += 1
    print row[1], numb
    name = row[0]
    genre = row[1]

    try:
        results = sp.search(q='artist:' + name, type='artist')
        items = results['artists']['items']

    except Exception:
        pass

    if len(items) > 0:
        artist = items[0]
        name = unicodedata.normalize('NFKD', artist['name']).encode('ascii','ignore')

        if name in check:
            continue

        check.append(name)
        writer.writerow([name, artist['id'], genre])