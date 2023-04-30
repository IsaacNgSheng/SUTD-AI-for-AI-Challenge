# load required packages
library(dplyr)
library(tidyr)
library(car) # for linearHypothesis()
library(ggplot2) # optional. we expect you to know base graphics, but allow ggplot if you find it easier
library(psych) # for pairs.panels()
library(factoextra) # for fviz_cluster()
library(wooldridge)
library(caret)
library(NbClust)
library(cluster)
library(clustertend)
library(fpc)
library(mclust)


#Load Data
data <- read.csv(file = 'C:/Users/isaac/OneDrive/Documents/Work/Projects/Segmentation/data.csv')
data

#change income to ordinal
incOrd <- function(i) {
  if (i == "Less than $500"){
    i = 1
  } else if (i == "$500 to $999"){
    i = 2
  } else if (i == "$1000 to $1500"){
    i = 3
  } else {
    i = 4
  } 
  return(i)
}

#convert income to integer to be converted to ordinal
data[,3] <- sapply(data[,3], incOrd)
data

#dropna for responses with more than 1 missing value
data <- data %>% drop_na()
data

#Change to ordered factors (or ordinals)
q <- data[3:13, 1]

data[,q] <- lapply(data[,q], factor, ordered=TRUE)
data[,q] <- lapply(data[,q], as.numeric)
sapply(data, class)
head(data)
fact <- data[3:13]


#hierarchal clustering
fact <- scale(fact)
head(fact)

#find agglomerative coefficient
#define linkage methods
m <- c( "average", "single", "complete", "ward")
names(m) <- c( "average", "single", "complete", "ward")

#function to compute agglomerative coefficient
ac <- function(x) {
  agnes(fact, method = x)$ac
}

#calculate agglomerative coefficient for each clustering linkage method
sapply(m, ac)

#Use Ward's Minimum variance
clust <- agnes(fact, method = "ward")

#produce dendrogram
dev.off()
pltree(clust, cex = 0.6, hang = -1, main = "Dendrogram") 

#gap stat
#calculate gap statistic for each number of clusters (up to 10 clusters)
gap_stat <- clusGap(fact, FUN = hcut, nstart = 25, K.max = 10, B = 50)

#produce plot of clusters vs. gap statistic
fviz_gap_stat(gap_stat)

#cluster labels
#compute distance matrix
gower_dist <- daisy(fact,
                    metric = "gower",
                    type = list(logratio = 3))

#perform hierarchical clustering using Ward's method
final_clust <- hclust(gower_dist, method = "ward.D2" )

#cut the dendrogram into 10 clusters
groups <- cutree(final_clust, k=10)

#find number of observations in each cluster
table(groups)

#append cluster labels to original data
final_data <- cbind(data, cluster = groups)

#display first six rows of final data
head(final_data)

#find mean values for each cluster
aggregate(final_data, by=list(cluster=final_data$cluster), mean)
