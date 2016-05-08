library(ggplot2)
library(dplyr)
data = read.csv('spotify_clean.csv')

data$popularity <- as.numeric(data$popularity)
data$release <- as.numeric(data$release)
data$tracks <- as.numeric(data$tracks)
data$time <- as.numeric(data$time)

str(data)
summary(data)
dim(data)
names(data)
levels(data$genre)
levels(genre.sub$genre)

## mean popularity - 24.34
## median popularity - 22
##average tracks per album - 13.77
## 10 - 15 = 1st and 3rd quartile
##average time between albums - 3 years

metal_subset <- data[grep("metal", data$genre), ]
jazz_subset <- data[grep("jazz", data$genre), ]
country_subset <- data[grep("country", data$genre), ]
rock_subset <- data[grep("rock", data$genre), ]

genre.sub <- subset(data, genre %in%  
                      names(table(data$genre))
                    [table(data$genre) >= 500])


popular.sub <- subset(data, popularity >= 70)

#album release Years
ggplot(aes(x = release), data = data) +
  geom_histogram(binwidth = 1) + 
  xlim(1960,2016)  +
  ylim(0,1500) +
  ggtitle('Albums by release year') +
  xlab('Year') + 
  ylab('Count')

#album release Years subset
ggplot(aes(x = release), data = data) +
  geom_histogram(binwidth = 1) + 
  xlim(1990,2016)  +
  ylim(0,1500) +
  ggtitle('Albums by release year(90s-current') +
  xlab('Year') + 
  ylab('Count')

#tracks per album
ggplot(aes(x = tracks), data = data) +
  geom_histogram(binwidth = 1) + 
  xlim(7, 20)  +
  ggtitle('Tracks per album') +
  xlab('tracks') + 
  ylab('frequency')

#most popular genres
ggplot(aes(x = genre), data = genre.sub) +
  geom_histogram() + 
  ggtitle('Top Genre Occurance') +
  scale_y_continuous(breaks = seq(0,4000, 500), 
                     limits = c(0, 4000)) +  
  stat_bin(binwidth=1, geom="text", 
           aes(label=..count.., color = 'orange'), 
           hjust=1.05)  + 
  coord_flip() + 
  theme(legend.position = "none")

#time between albums
ggplot(aes(x = time), data = data) +
  geom_histogram(binwidth = 1) + 
  xlim(0,5)  +
  ggtitle('years between album releases') +
  xlab('Years') + 
  ylab('Count')

#album popularity via time between albums
ggplot(aes(x = time, 
           y = popularity), 
       data = data) +
  stat_summary(fun.y = mean, geom="line", size = 1.2) +
  stat_summary(fun.y = mean, geom = 'point',size = 4)+
  ggtitle('Time between albums effect on popularity') +
  xlab('Time Between albums') +
  ylab('Popularity')+
  scale_x_continuous(limits = c(0, 10),
                     breaks = seq(0, 10, 1))


#number of album in career via popularity
ggplot(aes(x = number, y = popularity), data = data) +
  stat_summary(fun.y = mean, geom="line", size = 1.2) +
  stat_summary(fun.y = mean, geom = 'point',size = 4)+
  xlim(1,6)  +
  ggtitle('Popularity by which album in career') +
  xlab('which album') + 
  ylab('popularity average')


#release date / popularity
ggplot(aes(x = release, y = popularity), data = data) +
  stat_summary(fun.y = mean, geom="line", size = 1.2) +
  xlim(1950, 2016)  +
  ggtitle('Popularity by year') +
  xlab('release year') + 
  ylab('popularity average')

#genre split pop by which album
ggplot(aes(x = number, y = popularity, color = genre), data = genre.sub) +
  stat_summary(fun.y = mean, geom="line", size = 1.2) +
  stat_summary(fun.y = mean, geom = 'point',size = 4)+
  xlim(1,6)  +
  ggtitle('Popularity by which album in career') +
  xlab('which album') + 
  ylab('popularity average')


#time spent on albums
ggplot(aes(x = number, y = time), data = genre.sub) +
  stat_summary(fun.y = mean, geom="line", size = 1.2) +
  stat_summary(fun.y = mean, geom = 'point',size = 4)+
  xlim(2,6)  + ylim(0,5) +
  ggtitle('Ave Time spent on album in career') +
  xlab('which album') + 
  ylab('Time between')


ggplot(aes(x = number, y = time, color = genre), data = genre.sub) +
  stat_summary(fun.y = mean, geom="line", size = 1.2) +
  stat_summary(fun.y = mean, geom = 'point',size = 4)+
  xlim(2,6)  + ylim(0,5) +
  ggtitle('Ave Time spent on album in career') +
  xlab('which album') + 
  ylab('Time between')


ggplot(aes(x = number, y = popularity), data = metal_subset) +
  stat_summary(fun.y = mean, geom="line", size = 1.2) +
  stat_summary(fun.y = mean, geom = 'point',size = 4)+
  xlim(2,6)  + ylim(0,5) +
  ggtitle('Ave Time spent on album in career(metal)') +
  xlab('which album') + 
  ylab('Time between')
