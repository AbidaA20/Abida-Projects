attach(iphone)

library(NLP)
library(tm)
library(SnowballC)
library(RColorBrewer)
library(SentimentAnalysis)
library(syuzhet)
library(tidyr)
library(dplyr)

docs <- Corpus(VectorSource(iphone$reviews))

docs<-tm_map(docs, removeNumbers)
docs<-tm_map(docs, removePunctuation)
docs<-tm_map(docs,stripWhitespace)
docs<-tm_map(docs, content_transformer(tolower))
docs<-tm_map(docs, removeWords,
             stopwords("english"))
dtm <- TermDocumentMatrix(docs)

matrix <- as.matrix(dtm)

sent <- analyzeSentiment(dtm, language = "english")
summary(sent)

sent2 <-get_nrc_sentiment(iphone$reviews)
summary(sent2)
