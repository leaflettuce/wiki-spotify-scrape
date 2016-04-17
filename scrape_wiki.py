import re
import urllib2
from json import loads
import unicodedata
import csv


def clean_title(title):
    cleaned_name = title.lower().replace('_',' ').replace('list', '').replace('musicians', '')\
                        .replace('bands', '').replace('artists', '').replace('performers', '')\
                        .replace(' of', '').replace('%26', ' & ').replace('_and_', '').replace('  ', '')

    if ' and' in cleaned_name:
        index = cleaned_name.index(' and')
        final_cleaned_name = cleaned_name[:index]
        return final_cleaned_name
    else:
        return cleaned_name


final = {}

url = 'https://en.wikipedia.org/w/api.php?'

reader = csv.reader(open('list_of_list.csv', 'r'))
numb = 0

for title in reader:

    numb += 1
    query = ('action=query&titles='+title[0]+'&prop=revisions&rvprop=content&format=json')

    response = urllib2.urlopen(url + query)

    if 'json' not in response.info().getheader('Content-Type'):
        continue

    data = loads(response.read())

    list = []
    for section in data['query']['pages']:
        number = section
        break

    if numb in [2, 1, 459, 470, 179, 471, 468, 459]:
        continue
    if 'revisions' not in data['query']['pages'][number]:
        continue

    for section in data['query']['pages'][number]['revisions']:
        for item in section:
                list.append(section[item])

    page = unicodedata.normalize('NFKD', list[0]).encode('ascii','ignore')

    artists = re.findall(r'\[\[(.*?)\s?[\]?|\(?]', page)

    print clean_title(title[0]), numb
    final[clean_title(title[0])] = artists

writer = csv.writer(open('artist_names.csv', 'wb'))

check_list = ['List', 'Category', 'United States', 'Press', 'United Kingdom', 'j-pop', 'Australia',
                  'Serbia', 'Germany', 'Canada', 'Japan', '#', 'Switzerland', 'Ireland',
                  'South Africa', 'France', ':', 'Argentina', 'Various Artists', 'Motion Picture', 'musicians',
                  'bands']

for k,v in final.iteritems():
    for band in v:
        if any(check in band for check in check_list):
            continue
        else:
            writer.writerow([band, k])
