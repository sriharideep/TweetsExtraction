library(twitteR)
library(RCurl) 
library(ROAuth)
consumerKey = "Your Consumer Key" 
consumerSecret = "Your Consumer Sceret Key"
accessToken = "Your Access Token "
accessSecret = "Your Access Secret Token"
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


