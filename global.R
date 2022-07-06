require(shiny) #warning for any modifications, a lot of things in here are hardcoded
require(shinydashboard)  #if using new data/databases, please check lines 25, 31, 38, 42, and 59
require(shinyjs) #more errors might arise in the server.R file as well, please check it for other line numbers of interest
require(leaflet)
require(ggvis)
library(plyr)
require(dplyr)
library(RColorBrewer)
require(raster)
require(gstat)
require(rgdal)
require(Cairo)
library(sp)
library(htmltools)
# library(shinyauthr)
# dataframe that holds usernames, passwords and other user data
# user_base <- tibble::tibble(
#   user = c("user1", "user2"),
#   password = c("pass1", "pass2"),
#   permissions = c("reviewer", "standard"),
#   name = c("reviewer", "User Two")
# )

#this is input of data files
readfile <- read.csv("data/SORGHUM_CLIMATES.csv",row.names = NULL)

#still unknown what the purpose of this is
readfile2 <- read.csv("data/datadescriptionc.csv",row.names = NULL)

#actual table that is used for plotting (I believe)
FULL.val <-read.csv("data/SORGHUM_CLIMATES.csv")

class(FULL.val)  
na.omit(FULL.val)

#reads in the category labels for each of the categories used in the input of the data files above
#MUST MATCH FULL.val csv FILE IN ORDER EXACTLY, ANY DEVIATION WILL RESULT IN ERROR
vlc <- read.delim("data/variable_label_categorybDirectSorg.txt", header = FALSE, sep = "\t")

colnames(FULL.val) <- vlc[,2]
cats <- read.delim("data/categoriesb.txt", header = FALSE, sep = "\t")
vars <- vector("list",dim(cats)[1])#hardcoded from lines 42 to 52
names(vars) <- cats$V1
n = dim(vlc)[1]
for(i in 1:n) {
	c <- vlc[i,3]
	l <- vlc[i,2]
	if (is.null(vars[[c]])) {
		vars[c] <- c(l)
	}
	else {
		vars[[c]] <- c(vars[[c]], l)
	}
}

# a data.frame
#IF MODIFYING FILES FROM EARLIER, YOU MUST CHANGE THE VALUES USED FOR FULL.val HERE. IT IS HARDCODED
#HARD CODED vvvvvvvv
FULL <- SpatialPointsDataFrame(FULL.val[,c("Longitude (degrees)", "Latitude (degrees)")], FULL.val[,1:307])#this was changed for Sorg
#HARD CODED ^^^^^^^^
#########


descriptiondataset <-read.csv("data/datadescriptionc.csv")

#defined datasets for use in the server.R file
datasets <- list(
  'FULL'=  FULL,
	'cats'= vars,
  'descriptiondataset'
  
)

baselayers <- list(
  'FULL'='Esri.WorldImagery'
)

