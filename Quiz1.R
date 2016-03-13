## Requires package 'openNLPmodels.en' from the repository at
## <http://datacube.wu.ac.at>.
require("tm")
require(R.utils)
# Needed <- c("tm", "SnowballCC", "RColorBrewer", "ggplot2", "wordcloud", "biclust", "cluster", "igraph", "fpc")   
# install.packages(Needed, dependencies=TRUE)  
# install.packages("Rcampdf", repos = "http://datacube.wu.ac.at/", type = "source") 

#Question 1
#looking at the file system: blogs at 200.4 MB


######################################## Question 2

n <- countLines("en_US.blogs.txt")
n2 <- length(readLines("en_US.blogs.txt"))
n <- countlines("texts/en_us.blogs.txt")
#Answer: 899288

library(stringr)
str_count(string = docs[[3]], pattern = "\\n")
1#Faster Answer 2350148

############################## Question 3


#######THIS GAVE THE ANSWER, BUT IT'S NOT IN R!
# symb:texts sydphi$ awk '{ if (length($0) > max) {max = length($0); maxline = $0} } END { print maxline }'  en_US.blogs.txt |awk '{print length}'|sort -nr|head -1
# 40836
# symb:texts sydphi$ awk '{ if (length($0) > max) {max = length($0); maxline = $0} } END { print maxline }'  en_US.news.txt |awk '{print length}'|sort -nr|head -1 
# 11385
# symb:texts sydphi$ awk '{ if (length($0) > max) {max = length($0); maxline = $0} } END { print maxline }'  en_US.twitter.txt |awk '{print length}'|sort -nr|head -1
# 214
# symb:texts sydphi$ 



###################################### Question 4
## See: https://rstudio-pubs-static.s3.amazonaws.com/31867_8236987cf0a8444e962ccd2aec46d9c3.html

require(tm)
require(SnowballC)
docs <- Corpus(DirSource("texts/")) #This reads all files in a directory

docs <- tm_map(docs, removePunctuation)   # remove punctuation marks

docs <- tm_map(docs, tolower)  # chage everything to lower case for easier searching

# length(stopwords("english"))   
# stopwords("english")   
docs <- tm_map(docs, removeWords, stopwords("english"))   
# inspect(docs[3]) # Check to see if it worked.   

#Removing common word endings (e.g., “ing”, “es”, “s”)
#This is referred to as “stemming” documents. We stem the documents so that a word will be recognizable to the computer, despite whether or not it may have a variety of possible endings in the original text.

library(SnowballC)   
docs <- tm_map(docs, stemDocument)   

#Stripping unnecesary whitespace from your documents:
#The above preprocessing will leave the documents with a lot of “white space”. White space is the result of all the left over spaces that were not removed along with the words that were deleted. The white space can, and should, be removed.

docs <- tm_map(docs, stripWhitespace)   
# inspect(docs[3]) # Check to see if it worked.   

#Be sure to use the following script once you have completed preprocessing.
#This tells R to treat your preprocessed documents as text documents.
docs <- tm_map(docs, PlainTextDocument)   
#This is the end of the preprocessing stage.

dtm <- DocumentTermMatrix(docs)   
dtm   
inspect(dtm[1:5, 1:20])

#You’ll also need a transpose of this matrix. Create it using:
tdm <- TermDocumentMatrix(docs)

