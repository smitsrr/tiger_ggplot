library(ggplot2)
library(shiny)

    # set your working directory
setwd("C:/Users/smits/Documents/GitHub/delivery_method/wonder_data_extracts")

    # use the TIGER dataset from the census to draw the state outlines
    # http://www2.census.gov/geo/tiger/GENZ2016/shp/cb_2016_us_state_5m.zip
    # download and unzip the folder - it produces many files - don't worry about it. 
    # just leave them all there. Make sure your pointed to the directory where you saved them
US.states <- readOGR(dsn=".",layer="cb_2016_us_state_5m")
    #excludes Alaska, american samoa (60), commonwealth of the northern mariana islands (69), 
    # guam (66). need to exclude the virgin islands
exclude_states<- c("02", "15", "78", "60", "66", "69", "72")
US.states<- US.states[!US.states$GEOID %in% exclude_states,]
us_states<- fortify(US.states)

    # GET THE COUNTY DATA
    #https://www2.census.gov/geo/tiger/GENZ2016/shp/cb_2016_us_county_5m.zip
    # download and unzip the folder - it produces many files - don't worry about it. 
    # just leave them all there. Make sure your pointed to the directory where you saved them
us.counties <- readOGR(dsn=".",layer="cb_2016_us_county_5m")
us.counties<- us.counties[!us.counties$STATEFP %in% exclude_states,]
us_counties<-fortify(us.counties)

p<-ggplot()+
  geom_polygon(data = us_counties, aes(x=long,y=lat, group = group), color = "black", fill = "white")+
  geom_polygon(data = us_states, aes(x=long, y=lat, group = group), color = "red", fill = NA)
p + theme_void() ## show the map without a graph-looking background

    # If you want to shade the counties/states by a variable, you'll
    # just join your data to the shape data frames and then set fill = variable_of_interest