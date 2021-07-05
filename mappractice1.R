library(leaflet)
library(tidyverse)
library(ggplot2)
library(ggmap)
library(leaflet.extras)
library(maps)
library(mapdata)
library(mapproj)
library(htmltools)
library(sf)
library(rgdal)

#Map of USA
s <- map_data('state')
ggplot(s, aes(x = long, y = lat, group = group, fill = region)) + 
  geom_polygon(fill = 'White', color = 'black') + 
  coord_map('polyconic') +
  guides(fill = F)

#read in any data file
mydata <- read.csv(file.choose(), header = T)

#old method, is not working..might use later
mapanddata <- inner_join(s, mydata, by = character())

#map with data so far
m <- ggplot() + 
  geom_polygon(data=s, aes(x=long, y=lat, group=group), fill="lightgrey", color="black") +  
  geom_point(data=mydata, aes(x=Longitude, y=Latitude), color="red", size= 2)+
  coord_equal(ratio=1)+
  coord_map('polyconic')+
  labs(title="Location of Nuclear Plants by Capacity Factor", subtitle = "Value summed between reactors")+
  guides(fill = F)+
  theme_void()
  
currentmap <- m + 
  geom_point(data = mydata, aes(x=Longitude, y=Latitude, size = CF),
  color = "gold", alpha = .5) + scale_size(name="Capacity Factor")+
  theme_void()
