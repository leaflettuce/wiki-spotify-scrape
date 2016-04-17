import spotipy
import csv
import collections
import unicodedata

def convert(data):
    if isinstance(data, basestring):
        return unicodedata.normalize('NFKD', data).encode('ascii','ignore')
    elif isinstance(data, collections.Mapping):
        return dict(map(convert, data.iteritems()))
    elif isinstance(data, collections.Iterable):
        return type(data)(map(convert, data))
    else:
        return data



##pull artist album list
numb = 0
reader = csv.reader(open('artist_ids.csv', 'r'))

writer = csv.writer(open('spotify.csv', 'wb'))
writer.writerow(['artist', 'album', 'popularity', 'release', 'tracks', 'genre', 'number'])

for row in reader:
    numb += 1
    print row[0], numb
    print_dic = []
    url = 'spotify:artist:' + row[1]
    genre = row[2]

    sp = spotipy.Spotify()
    results = sp.artist_albums(url, album_type='album')

    albums = results['items']
    album_num = len(albums)
   # if len(albums) > 12:
     #   continue

    while results['next']:
        results = sp.next(results)
        albums.extend(results['items'])

    ##get album id's
    album_list = []
    for album in albums:
        album_list.append(album['id'])

    for album_id in album_list:
        album_info = convert(sp.album('spotify:album:'+album_id))

        album_name = album_info['name']
        if '(' in album_name:
            album_name = album_name.split(' (')[0]

        if print_dic:
            check = 0
            for each in print_dic:

                if album_name.lower() == each[1].lower():
                    check = 1
                    if each[2] >= album_info['popularity']:
                        break
                    else:
                        print_dic.remove(each)
                        print_dic.append([album_info['artists'][0]['name'], album_name, album_info['popularity'],
                         album_info['release_date'], album_info['tracks']['total'], genre, album_num])
                        album_num -= 1

            if check == 1:
                continue
            else:
                print_dic.append([album_info['artists'][0]['name'], album_name, album_info['popularity'],
                         album_info['release_date'], album_info['tracks']['total'], genre, album_num])
                album_num -= 1
        else:
            print_dic.append([album_info['artists'][0]['name'], album_name, album_info['popularity'],
                         album_info['release_date'], album_info['tracks']['total'], genre, album_num])
            album_num -= 1

    if len(print_dic) <= 3 or len(print_dic) >= 15:
        continue

    for item in print_dic:

        if item[4] <= 7:
            continue

        writer.writerow(item)
