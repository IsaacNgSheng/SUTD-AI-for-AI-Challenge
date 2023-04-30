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

#check elbow method
set.seed(1)
wss <- rep(NA,20)
for(k in c(2:20)) {
  wss[k] = kmeans(fact, k, nstart=10)$tot.withinss
}
plot(wss,type="b", xlab="Number of clusters", ylab="Total within-cluster sum of squares")

#verify number of clusters to be formed
silhouette_score <- function(k){
  km <- kmeans(fact, centers = k, nstart=25)
  ss <- silhouette(km$cluster, dist(fact))
  mean(ss[, 3])
}
k <- 2:10
avg_sil <- sapply(k, silhouette_score)
#overall average sihouette_score
plot(k, type='b', avg_sil, xlab='Number of clusters', ylab='Average Silhouette Scores', frame=FALSE)
#optimal number of clusters for this data
fviz_nbclust(fact, kmeans, method='silhouette')

# #gap statistic (another method to determine number of clusters)
# colnames(fact) <- c("a", "b")
# title <- "Raw data"
# par(mfrow=c(1,2))
# for (i in 1:2) {
#   #
#   # Estimate optimal cluster count and perform K-means with it.
#   #
#   gap <- clusGap(fact, kmeans, K.max=10, B=500)
#   k <- maxSE(gap$Tab[, "gap"], gap$Tab[, "SE.sim"], method="Tibs2001SEmax")
#   fit <- kmeans(fact, k)
#   #
#   # Plot the results.
#   #
#   pch <- ifelse(fit$cluster==1,24,16); col <- ifelse(fit$cluster==1,"Red", "Black")
#   plot(fact, asp=1, main=title, pch=pch, col=col)
#   plot(gap, main=paste("Gap stats,", title))
#   abline(v=k, lty=3, lwd=2, col="Blue")
#   #
#   # Prepare for the next step.
#   #
#   fact <- apply(fact, 2, scale)
#   title <- "Standardized data"
# }

#Generating 3 clusters based on elbow method
km_obj = kmeans(fact,3)
km_obj
fviz_cluster(km_obj, fact)

#List the characteristics between the clusters
km_obj$centers
