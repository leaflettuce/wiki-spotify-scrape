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

#Book release Years
ggplot(aes(x = release), data = data) +
  geom_histogram(binwidth = 1) + 
  xlim(1960,2016)  +
  ylim(0,1500) +
  ggtitle('Albums by release year') +
  xlab('Year') + 
  ylab('Count')

#Book release Years subset
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

#album release number via time between
ggplot(aes(x = number, y = time), data = data) +
  geom_point(aes(size = count(time)))  + 
  xlim(0,6)  +
  ylim(0, 4) +
  ggtitle('time between related to which album release') +
  xlab('which album in bands career') + 
  ylab('time between (years)')
