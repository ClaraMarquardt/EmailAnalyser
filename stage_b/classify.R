#----------------------------------------------------------------------------#

# Purpose:     Master Execution Script
# Author:      CM
# Date:        Jan 2017
# Language:    R (.R)

#----------------------------------------------------------------------------#


#----------------------------------------------------------------------------#
#                               Control Section                              #
#----------------------------------------------------------------------------#

# set-up
#-------------------------------------------------#
print(Sys.time())
current_date <- gsub("/", "_", as.character(format(Sys.time(), "%d/%m/%Y")))
start_time   <- Sys.time()

# command line arguments
#-------------------------------------------------#
# init_path                <- commandArgs(trailingOnly = TRUE)[1]
# execution_id             <- commandArgs(trailingOnly = TRUE)[5]
# train_data_path          <- commandArgs(trailingOnly = TRUE)[5]
# email_data_path          <- commandArgs(trailingOnly = TRUE)[5]

init_path                  <- "/Users/claramarquardt/Google_Drive/Jobs/indep_project/email_sentiment/code/helper_code/"
execution_id               <- paste0(current_date, paste0(sample(letters,10), collapse=""))
train_data_path            <- "~/Google_Drive/Jobs/indep_project/email_sentiment/data/train_data/"
email_data_path_outbox     <- "~/Google_Drive/Jobs/indep_project/email_sentiment/data/email_data/outbox/"
email_data_path_inbox      <- "~/Google_Drive/Jobs/indep_project/email_sentiment/data/email_data/inbox/"
temp_data_path             <- "~/Google_Drive/Jobs/indep_project/email_sentiment/data/temp_data/"


# dependencies
#-------------------------------------------------#
source(paste0(init_path, "/R_init.R"))

# parameters / helpers
#-------------------------------------------------#


#----------------------------------------------------------------------------#
#                                    Code                                    #
#----------------------------------------------------------------------------#

# train the model
#----------------------------------------------------------------------------#

### load the model
#-----------------------------
model <- readRDS("~/Google_Drive/Jobs/indep_project/email_sentiment/model/glmnet_classifier.Rds")

### prepare & prepare model
#-----------------------------
# function for converting some symbols
conv_fun <- function(x) iconv(x, "latin1", "ASCII", "")

tweets_classified <- read_csv(paste0(train_data_path, 
 'classified_tweet_data/training.1600000.processed.noemoticon.csv'),
 col_names = c('sentiment', 'id', 'date', 'query', 'user', 'text')) %>%
 # converting some symbols
 dmap_at('text', conv_fun) %>%
 # replacing class values
 mutate(sentiment = ifelse(sentiment == 0, 0, 1))

# there are some tweets with NA ids that we replace with dummies
tweets_classified_na <- tweets_classified %>%
 filter(is.na(id) == TRUE) %>%
 mutate(id = c(1:n()))
tweets_classified <- tweets_classified %>%
 filter(!is.na(id)) %>%
 rbind(., tweets_classified_na)
 
# data splitting on train and test
set.seed(2340)
trainIndex <- createDataPartition(tweets_classified$sentiment, p = 0.8, 
 list = FALSE, 
 times = 1)
tweets_train <- tweets_classified[trainIndex, ]
tweets_test <- tweets_classified[-trainIndex, ][1,]

##### Vectorization #####
# define preprocessing function and tokenization function
prep_fun <- tolower
tok_fun <- word_tokenizer
 
it_train <- itoken(tweets_train$text, 
 preprocessor = prep_fun, 
 tokenizer = tok_fun,
 ids = tweets_train$id,
 progressbar = TRUE)
 
# creating vocabulary and document-term matrix
vocab <- create_vocabulary(it_train)
vectorizer <- vocab_vectorizer(vocab)

dtm_train <- create_dtm(it_train, vectorizer)

# define tf-idf model
tfidf <- TfIdf$new()
dtm_train_tfidf <- fit_transform(dtm_train, tfidf)

### loop over email
#-----------------------------
sentiment_score <- c()
email_date      <- c()
email_id     <- c()

for (email in list.files(email_data_path_outbox)) {

	# initialise
	test_temp         <- copy(tweets_test)
	tfidf_temp        <- copy(tfidf)

	# obtain the date 
	date_temp <- gsub("(.*)(__)(.*)(\\.txt)", "\\3", email)

	# read in the email
	email_text        <- paste0(readLines(paste0(email_data_path_outbox,email)), collapse=" ")
	email_text        <- gsub("<[^<>]*>","",email_text)
    email_text        <- gsub("&lt|&quot","",email_text)
    email_text        <- gsub("\\{.*\\}","",email_text)
    email_text        <- gsub("On.*2017.*at.*PM.*&gt.*wrote","",email_text)

    if (nchar(email_text)>0) {
		
		# store as text
		test_temp$text[1] <- email_text
	
		# process
		it_test <- itoken(test_temp$text, 
 			preprocessor = prep_fun, 
			tokenizer = tok_fun,
 			ids = test_temp$id,
 			progressbar = FALSE)
 		
 		dtm_test       <- create_dtm(it_test, vectorizer)
		dtm_test_tfidf <- fit_transform(dtm_test, tfidf_temp)
	
		# print identified terms
		print(dtm_test_tfidf[1,][which(dtm_test_tfidf[1,]!=0)])
	
		# classify
		pred_temp <- predict(model, dtm_test_tfidf, type = 'response')[ ,1]
	
		# print score
		cat(paste0("\n", pred_temp, "\n"))
	
		# store 
		sentiment_score <- c(sentiment_score, pred_temp)
		email_date      <- c(email_date, date_temp)
		email_id        <- c(email_id,email)
	
	}

	# clear up 
	gc()

}
 

### save score
#-----------------------------
sentiment_dt <- data.table(id=email_id, date=email_date, score=sentiment_score)
sentiment_dt <- unique(sentiment_dt, by=c("date", "score"))

saveRDS(sentiment_dt, paste0(temp_data_path, "score_table_", 
	execution_id, ".Rds"))

### archive emails
#-----------------------------

#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#

