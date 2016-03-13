
# Used: https://rstudio-pubs-static.s3.amazonaws.com/31867_8236987cf0a8444e962ccd2aec46d9c3.html

# Load the required packets
# 
# Needed <- c("tm", "SnowballCC", "RColorBrewer", "ggplot2", "wordcloud"
#             , "biclust", "cluster", "igraph", "fpc")   
# install.packages("Rcampdf", repos = "http://datacube.wu.ac.at/", type = "source")  

require(tm)
require(SnowballC)
require(RColorBrewer)
require(ggplot2)
require(wordcloud)
require(biclust)
require(cluster)
require(igraph)
require(fpc)
require(Rcampf)

cname <- file.path("texts")   

library(tm)   
docs <- Corpus(DirSource(cname))   #Docs is a list

docs <- tm_map(docs, removePunctuation)   #Because computers can't "read"

docs <- tm_map(docs, removeNumbers)  

docs <- tm_map(docs, tolower)

docs <- tm_map(docs, removeWords, stopwords("english"))

docs <- tm_map(docs, removeWords, c("department", "email")) #remove words of my choosing

for (j in seq(docs))
{
        docs[[j]] <- gsub("the raven", "TR", docs[[j]])  #combine and replace words for shortcuts
 
}

library(SnowballC)   
docs <- tm_map(docs, stemDocument)   #Stem words so that only root is used

docs <- tm_map(docs, stripWhitespace)  #Get rid of the whitespace

# To Finish
# Be sure to use the following script once you have completed preprocessing.
# This tells R to treat your preprocessed documents as text documents.

docs <- tm_map(docs, PlainTextDocument)   

dtm <- DocumentTermMatrix(docs)   
dtm   

tdm <- TermDocumentMatrix(docs)   #transpose doc matrix

freq <- colSums(as.matrix(dtm))   
length(freq)   
ord <- order(freq)  

dtms <- removeSparseTerms(dtm, 0.1) # This makes a matrix that is 10% empty space, maximum.   
inspect(dtms)  

freq[head(ord)] #lowest used terms
freq[tail(ord)] #highest used terms

head(table(freq), 20)   
tail(table(freq), 20)   

freq <- colSums(as.matrix(dtms))   
freq   

freq <- sort(colSums(as.matrix(dtm)), decreasing=TRUE)   
head(freq, 14)   

wf <- data.frame(word=names(freq), freq=freq)   
head(wf)  

library(ggplot2)   
p <- ggplot(subset(wf, freq>3), aes(word, freq))     
p <- p + geom_bar(stat="identity")   
p <- p + theme(axis.text.x=element_text(angle=45, hjust=1))   
p   

library(wordcloud)   
set.seed(142)   
wordcloud(names(freq), freq, min.freq=3) 

wordcloud(names(freq), freq, min.freq=3, scale=c(5, .1), colors=brewer.pal(6, "Dark2"))   

dark2 <- brewer.pal(6, "Dark2")   
wordcloud(names(freq), freq, max.words=100, rot.per=0.2, colors=dark2)   

dtmss <- removeSparseTerms(dtm, 0.15) # This makes a matrix that is only 15% empty space, maximum.   
inspect(dtmss)   

#First calculate distance between words & then cluster them according to similarity.

library(cluster)   
d <- dist(t(dtmss), method="euclidian")   
fit <- hclust(d=d, method="ward")   
fit   

plot(fit, hang=-2)  


plot.new()
plot(fit, hang=-1)
groups <- cutree(fit, k=5)   # "k=" defines the number of clusters you are using   
rect.hclust(fit, k=5, border="red") # draw dendogram with red borders around the 5 clusters  
