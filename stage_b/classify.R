#----------------------------------------------------------------------------#

# Purpose:     Master Execution Script
# Author:      CM
# Date:        Jan 2017
# Language:    R (.R)

#----------------------------------------------------------------------------#


#----------------------------------------------------------------------------#
#                               Control Section                              #
#----------------------------------------------------------------------------#

# command line arguments
#-------------------------------------------------#
init_path                <- commandArgs(trailingOnly = TRUE)[1]
execution_id             <- commandArgs(trailingOnly = TRUE)[2]
train_data_path          <- commandArgs(trailingOnly = TRUE)[3]
email_data_path_outbox   <- commandArgs(trailingOnly = TRUE)[4]
temp_data_path           <- commandArgs(trailingOnly = TRUE)[5]
log_path                 <- commandArgs(trailingOnly = TRUE)[6]
model_path               <- commandArgs(trailingOnly = TRUE)[7]

# output buffer
#-------------------------------------------------#
sink(paste0(log_path, "/classify_", execution_id,".txt"), append=FALSE, split=FALSE)

# set-up
#-------------------------------------------------#
print(Sys.time())
current_date <- gsub("/", "_", as.character(format(Sys.time(), "%d/%m/%Y")))
start_time   <- Sys.time()

# dependencies
#-------------------------------------------------#
source(paste0(init_path, "/R_init.R"))

# parameters / helpers
#-------------------------------------------------#


#----------------------------------------------------------------------------#
#                                    Code                                    #
#----------------------------------------------------------------------------#

### load the model
#-----------------------------
model           <- readRDS(paste0(model_path, "/glmnet_classifier.Rds"))
model_comp      <- readRDS(paste0(model_path, "/glmnet_classifier_model_comp.Rds"))

tfidf           <- model_comp$tfidf 
vectorizer      <- model_comp$vectorizer 
dtm_train_tfidf <- model_comp$dtm_train_tfidf
prep_fun        <- model_comp$prep_fun
tok_fun         <- model_comp$tok_fun 
tweets_test     <- model_comp$tweets_test

### loop over email
#-----------------------------
sentiment_score <- c()
email_date      <- c()
email_id        <- c() 

email_list_raw  <- list.files(email_data_path_outbox)

for (i in 1:length(email_list_raw)) {

	cat(sprintf("Email %d out of %d\n", i, length(email_list_raw)))
    email <- email_list_raw[i]

	# initialise
	test_temp         <- copy(tweets_test)
	tfidf_temp        <- copy(tfidf)

	# obtain the date 
	date_temp   <- gsub("(.*)(__)(.*)(\\.txt)", "\\3", email)

	# read in the email
	email_text  <- readLines(paste0(email_data_path_outbox,"/",email))

	# omit headers/forwarded emails & clear up
	if (!(email_text[1] %like% "^<")) {
	
		email_text <- email_text[!email_text %like% "^>"]
		email_text <- email_text[!email_text %like% "^On.*wrote:$"]
		email_text <- email_text[!email_text ==""]
		email_text <- paste0(email_text, collapse=" ")

		# clear up
		email_text        <- gsub("<[^<>]*>","",email_text)
    	email_text        <- gsub("&lt|&quot","",email_text)
    	email_text        <- gsub("\\{.*\\}","",email_text)

    	print(email_text)

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
	}

	# clear up 
	gc()

}
 

### save score
#-----------------------------
sentiment_dt <- data.table(id=email_id, date=email_date, score=sentiment_score)
sentiment_dt <- unique(sentiment_dt, by=c("date", "score"))

saveRDS(sentiment_dt, paste0(temp_data_path, "/score_table_", 
	execution_id, ".Rds"))

sink()

#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#

