import csv


reader = csv.reader(open('spotify.csv', 'r'))
header = reader.next()

writer = csv.writer(open('spotify_clean.csv', 'wb'))
header.append('time')

writer.writerow(header)

dict = {}
final = []

for row in reader:

    #dict = {tdwp : [band name, album name, popularity, release, tracks, genre], [etc]}
    if row[0] in dict.keys():
        dict[row[0]].append([row[0], row[1], row[2], row[3][:4], row[4], row[5]])

    else:
        dict[row[0]] = [[row[0], row[1], row[2], row[3][:4], row[4], row[5]]]


for k,v in dict.iteritems():
    checker = {}
    number = -1

    for each in v:
        number += 1
        release = int(each[3])
        checker.update({release : number})

    d = checker.keys()
    first_date = min(d)
    first = checker[first_date]
    del checker[first_date]
    e = v[first]
    release_number = 1

    final.append([e[0], e[1], e[2], e[3], e[4], e[5], release_number, 0])

    while checker:
        release_number += 1
        d = checker.keys()
        second_date = min(d)
        second= checker[second_date]
        difference = second_date - first_date

        del checker[second_date]
        first_date = second_date

        e = v[second]

        final.append([e[0], e[1], e[2], e[3], e[4], e[5], release_number, difference])

for album in final:
    if album[6] > 30:
        continue

    writer.writerow(album)