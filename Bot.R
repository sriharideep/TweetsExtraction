library(twitteR)
library(RCurl) 
library(ROAuth)
consumerKey = "ckaLRocgW1gArwyR6McpUs2QK" 
consumerSecret = "B19pnpNb2zrFsWoVf7C7yijGCxBd986ZK3MG6lStE7V7RX0Cl5"
accessToken = "1367978534-1YyBU7ekD0yk4OIUlCNsnN51xYSf2w1AlGJhaUA"
accessSecret = "RBVIR71O1bcyJuGtnLDrCw6zy8FEi2Ds1SNHsFd7WHnP3"

consumerKey = "j8jDKxUif1XtrBBIhMXwCe3Kq"
consumerSecret = "BUnpZ6u9wPBCc3jHKgg0nwbhyTLeZHhOOXCgNwhDyAOfSTrQxx"
accessToken = "1367978534-2FjxPwuwJV2UsWYfK6wTDUGRC35kV88CU3db3Qa"
accessSecret = "H59aEDhBqlIlz2GlIYJAY1lFeqrTzpGIxa3v2n4RIo1As"
setup_twitter_oauth(consumer_key = consumerKey,consumer_secret = consumerSecret, 
                    
                    access_token = accessToken, access_secret = accessSecret)

# Set up the query
query <- "Trump OR DonaldTrump OR Trump2016 OR DonaldTrumpforPresient"
#query <-"Hillary2016 OR HillaryClinton"
query <- unlist(strsplit(query,","))
tweets = list()

# Loop through the keywords and store results

for(i in 1:length(query))
  {
  result <- searchTwitter(query[i],n=10000,retryOnRateLimit=100, lang="en")
  result <- strip_retweets(result, strip_manual = TRUE, strip_mt = TRUE)
  tweets <- c(tweets,result)
  tweets <- unique(tweets)
}

Hillary:
# Create a placeholder for the file
file<-NULL

# Check if tweets.csv exists
if (file.exists("tweetsHillaSept11.csv")){file<- read.csv("tweetsHillaSept11.csv")}

# Merge the data in the file with our new tweets
df <- do.call("rbind", lapply(tweets, as.data.frame))
df<-rbind(df,file)

# Remove duplicates
df <- df[!duplicated(df[c("id")]),]

# Save
write.csv(df,file="tweetsHillaSept11.csv",row.names=FALSE)

# Done!

TRUMP:
# Create a placeholder for the file
file<-NULL

# Check if tweets.csv exists
if (file.exists("tweetstrumpSept11.csv")){file<- read.csv("tweetstrumpSept11.csv")}

# Merge the data in the file with our new tweets
df <- do.call("rbind", lapply(tweets, as.data.frame))
df<-rbind(df,file)

# Remove duplicates
df <- df[!duplicated(df[c("id")]),]

# Save
write.csv(df,file="tweetstrumpSept11.csv",row.names=FALSE)

# Done!

library(rjson)
df <- data.frame(rowLabels=c("Birrarung Marr", "Bourke Street Mall (North)", "Bourke Street Mall (South)", "Flagstaff Station", "Flinders St Station Underpass", "Melbourne Central", "Princes Bridge", "Sandridge Bridge", "State Library", "Town Hall (West)"),
                 locationMax = c(8592, 3213, 3127, 138, 4472, 3923, 4595, 1758, 4252, 2926))
df_list <- lapply(split(df, 1:nrow(df)), function(x) mongo.bson.from.JSON(toJSON(x)))

mongo <- mongo.create()                                # connect to Mongo on localhost
if (mongo.is.connected(mongo) == TRUE) {
  icoll <- paste(db, "test", sep=".")
  mongo.insert.batch(mongo, icoll, df_list)          # insert into the MongoDB
  dbs <- mongo.get.database.collections(mongo, db)
  print(dbs)
  mongo.find.all(mongo, icoll)
}