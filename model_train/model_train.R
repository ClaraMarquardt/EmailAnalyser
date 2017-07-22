#----------------------------------------------------------------------------#

# Purpose:     Model Construction
# Author:      CM
# Date:        July 2017
# Language:    R (.R)

#----------------------------------------------------------------------------#


#----------------------------------------------------------------------------#
#                               Control Section                              #
#----------------------------------------------------------------------------#

# set-up
#-------------------------------------------------#
print(Sys.time())
current_date <- as.character(format(Sys.time(), "%d/%m/%Y")) 
start_time <- Sys.time()

# set.seed
set.seed(1)

# command line arguments
#-------------------------------------------------#
init_path                <- commandArgs(trailingOnly = TRUE)[1]
execution_id             <- commandArgs(trailingOnly = TRUE)[2]
train_data_path          <- commandArgs(trailingOnly = TRUE)[3]
model_path               <- commandArgs(trailingOnly = TRUE)[4]
log_path                 <- commandArgs(trailingOnly = TRUE)[5]

# output buffer
#-------------------------------------------------#
sink(paste0(log_path, "/model_train_", execution_id,".txt"), 
	append=FALSE, split=FALSE)

# dependencies
#-------------------------------------------------#
source(paste0(init_path, "/R_init_dev.R"))

# parameters / helpers
#-------------------------------------------------#

#----------------------------------------------------------------------------#
#                                    Code                                    #
#----------------------------------------------------------------------------#

# train the model
#----------------------------------------------------------------------------#

### helper functions ######
conv_fun <- function(x) iconv(x, "latin1", "ASCII", "")
prep_fun <- tolower
tok_fun  <- word_tokenizer

##### loading classified tweets ######
# 0 - the polarity of the tweet (0 = negative, 4 = positive)
# 1 - the id of the tweet
# 2 - the date of the tweet
# 3 - the query. If there is no query, then this value is NO_QUERY.
# 4 - the user that tweeted
# 5 - the text of the tweet
 
tweets_classified <- read_csv(paste0(train_data_path, 
 '/classified_tweet_data/training.1600000.processed.noemoticon.csv'),
 col_names = c('sentiment', 'id', 'date', 'query', 'user', 'text')) %>%
 # converting some symbols
 dmap_at('text', conv_fun) %>%
 # replacing class values
 mutate(sentiment = ifelse(sentiment == 0, 0, 1))
 
# tweets with NA ids -> replace with dummies
tweets_classified_na <- tweets_classified %>%
 filter(is.na(id) == TRUE) %>%
 mutate(id = c(1:n()))
tweets_classified <- tweets_classified %>%
 filter(!is.na(id)) %>%
 rbind(., tweets_classified_na)
 
# data splitting - train/test
trainIndex <- createDataPartition(tweets_classified$sentiment, p = 0.8, 
 list = FALSE, times = 1)

tweets_train <- tweets_classified[trainIndex, ]
tweets_test  <- tweets_classified[-trainIndex, ]
 

##### Vectorization #####
it_train <- itoken(tweets_train$text, 
 preprocessor = prep_fun, 
 tokenizer = tok_fun,
 ids = tweets_train$id,
 progressbar = TRUE)
it_test <- itoken(tweets_test$text, 
 preprocessor = prep_fun, 
 tokenizer = tok_fun,
 ids = tweets_test$id,
 progressbar = TRUE)
 
# creating vocabulary and document-term matrix
vocab      <- create_vocabulary(it_train)
vectorizer <- vocab_vectorizer(vocab)
dtm_train  <- create_dtm(it_train, vectorizer)
dtm_test   <- create_dtm(it_test, vectorizer)

# define tf-idf model
tfidf <- TfIdf$new()

# fit the model 
dtm_train_tfidf <- fit_transform(dtm_train, tfidf)
dtm_test_tfidf  <- fit_transform(dtm_test, tfidf)
 
# train the model
train_time <- Sys.time()

glmnet_classifier <- cv.glmnet(x = dtm_train_tfidf,
 y = tweets_train[['sentiment']], 
 family = 'binomial', 
 alpha = 1,
 type.measure = "auc",
 nfolds = 5,
 thresh = 1e-3,
 maxit = 1e3)

print(difftime(Sys.time(), train_time, units = 'mins'))

# assess the model
#----------------------------------------------------------------------------#
cv_auc_max <- max(glmnet_classifier$cvm)

preds      <- predict(glmnet_classifier, dtm_test_tfidf, type = 'response')[ ,1]
oos_auc    <- auc(as.numeric(tweets_test$sentiment), preds)

## tuning plot
pdf(paste0(model_path, "/glmnet_classifier_tuning.pdf"))
plot(glmnet_classifier)
dev.off()

## tuning plot
cat("\n###\n\n")
cat(paste0("AUC (CV (in-sample)): ", round(cv_auc_max, 4), " / ", 
	"AUC (OS): ", round(oos_auc, 4), " / "))
cat("\n\n###\n")


# save the model
#----------------------------------------------------------------------------#

# save the model for future using
saveRDS(glmnet_classifier, paste0(model_path, "/glmnet_classifier.Rds"))

# save the model components
model_comp                 <- list()
model_comp$tfidf           <- tfidf
model_comp$vectorizer      <- vectorizer
model_comp$dtm_train_tfidf <- dtm_train_tfidf
model_comp$prep_fun        <- prep_fun
model_comp$tok_fun         <- tok_fun
model_comp$tweets_test     <- tweets_test[1,]

saveRDS(model_comp, paste0(model_path, "/glmnet_classifier_model_comp.Rds"))

#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#

