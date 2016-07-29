
library(dplyr)
library(tidyr)

setwd("/Volumes/Half_Dome/datasets/grupo-bimbo/")
load("clients.Rdata")
clients %>% separate(client_name, into = c("name1", "name2", "name3", "name4", "name5", "name6"), sep = " ", extra = "warn", fill="left")
head(clients)

# Try creating list of common words in the Client name vector
library(tm)

# There are duplicates of the client names
uni <- unique(clients$client)
uni_clnt <- distinct(clients, client, .keep_all = TRUE)
doc <- paste(uni_clnt$client_name, sep = " ", collapse = " ")

filename <- file("client_doc.txt")
writeLines(doc, filename)
close(filename)



corp <- Corpus(DirSource("/Volumes/Half_Dome/datasets/grupo-bimbo/client"))
inspect(corp)

# Clean up text
corp <- tm_map(corp, removePunctuation)
corp <- tm_map(corp, removeNumbers)
# change to all lower case (probably already all lowercase, but just to be safe)
corp <- tm_map(corp, tolower)
# remove common words
stopwords("spanish")

?removeWords
corp <- tm_map(corp, removeWords, stopwords("spanish"))
corp <- tm_map(corp, removeWords, c("identificado", "abarrotes", "miscelanea", "san", "tienda"))

corp <- tm_map(corp, PlainTextDocument)

dtm <- DocumentTermMatrix(corp)
dtm
inspect(dtm)


freq <- colSums(as.matrix(dtm))
freq
length(freq)
ord <- order(freq, decreasing = TRUE)
ord
name100 <- freq[head(ord, 100)]
str(name100)
freq[tail(ord)]
head(table(freq), 20)
plot(table(freq))

library(stringr)
?colSums
sapply(client$client_name, str_detect(x, as.character(topname)))

topnames <- names(name100)

clients$client_name <- sapply(clients$client_name, tolower)

clients %>% mutate(test = str_detect(client_name, topnames[3]))

str_detect(clients$client_name, topnames[1]) 


as.character(clients$client_name[2])

clients2 <- clients
colnames(clients2) <- c("client", "client_name", topnames)
