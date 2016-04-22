import re
import urllib2
from json import loads
import unicodedata
import csv


url = 'https://en.wikipedia.org/w/api.php?'
query = ('action=query&titles=Lists_of_musicians&prop=revisions&rvprop=content&format=json')

list = []
response = urllib2.urlopen(url + query)
data = loads(response.read())


for section in data['query']['pages']:
        number = section
        break

for section in data['query']['pages'][number]['revisions']:
    for item in section:
            list.append(section[item])

page = unicodedata.normalize('NFKD', list[0]).encode('ascii','ignore')

artists = re.findall(r'\[\[(.*?)\s?[\]?|\(?]', page)

writer = csv.writer(open('list_of_list.csv', 'wb'))

for item in artists:
    item = item.replace(' ', '_')
    writer.writerow([item])

