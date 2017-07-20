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
helper_path                <- "~/Google_Drive/Jobs/indep_project/email_sentiment/helper/email/email_text.txt"

# dependencies
#-------------------------------------------------#
source(paste0(init_path, "/R_init.R"))

# parameters / helpers
#-------------------------------------------------#


#----------------------------------------------------------------------------#
#                                    Code                                    #
#----------------------------------------------------------------------------#

# load the data table
sentiment_dt <- readRDS(paste0(temp_data_path,
	grep(".Rds", list.files(temp_data_path), value=T)[1]))

# print(str(sentiment_dt))

# graph
#----------------------------------------------------------------------------#

# adjust
sentiment_dt[, date:=as.IDate(date, "%d_%m_%Y")]
sentiment_dt <- sentiment_dt[year(date)==2017]

sentiment_dt[, score:=1-score]

print(summary(sentiment_dt$score))

date_min <- min(sentiment_dt$date)
date_max <- max(sentiment_dt$date)

# summary stats
email_sent <- nrow(sentiment_dt)

# aggregate
sentiment_dt[, score_mean:=mean(score), by=c("date")]
sentiment_dt[, score_var:=var(score), by=c("date")]
sentiment_dt <- unique(sentiment_dt, by=c("date"))

print(summary(sentiment_dt$score_mean))

min <- min(sentiment_dt$score_mean)
max <- max(sentiment_dt$score_mean)
new_min <- 0.46
new_max <- 0.73

sentiment_dt[, score_mean:=(score_mean-min)*((new_max-new_min)/(max-min)) + new_min]

print(summary(sentiment_dt$score_mean))

daily_min <-sentiment_dt[score_mean==min(score_mean)] 
daily_max <-sentiment_dt[score_mean==max(score_mean)] 
daily_mean <-mean(sentiment_dt$score_mean)

print(daily_min$date)
print(daily_max$date)
print(daily_mean)

# plot
sentiment_plot <- ggplot(data=sentiment_dt) + 
	labs(
		x="Date",
		y="Daily Positivity (0-1)",
		title="How Are You Doing?", 
		subtitle=sprintf("Based on %d emails send over the period: %s to %s",
			email_sent, as.character(date_min), as.character(date_max))
	) + 
	geom_line(aes(x=date, y=score_mean)) +
	theme_basic() + 
	theme_legend_bottom()
 
sentiment_var_plot <- ggplot(data=sentiment_dt) + 
	labs(
		x="Date",
		y="Daily Sentiment Variability",
		title="Sentiment Variability", 
		subtitle=sprintf("Based on %d emails send over the period: %s to %s",
			email_sent, as.character(date_min), as.character(date_max))
	) + 
	geom_line(aes(x=date, y=score_var)) +
	theme_basic() + 
	theme_legend_bottom()

# save
ggsave(paste0(temp_data_path, "mean_plot_", execution_id, ".pdf"), sentiment_plot)
ggsave(paste0(temp_data_path, "var_plot_", execution_id, ".pdf"), sentiment_var_plot)

# report
#----------------------------------------------------------------------------#

# data
mean_score     <- round(mean(sentiment_dt$score_mean),2)
min_score      <- min(sentiment_dt$score_mean)
min_score_date <- sentiment_dt[score_mean==min_score]$date
max_score      <- max(sentiment_dt$score_mean)
max_score_date <- sentiment_dt[score_mean==max_score]$date

#read text
report_text <- paste0(readLines(helper_path), collapse="\n")

report_text <- gsub("XX", "%s", report_text)
report_text <- sprintf(report_text, mean_score, max_score, 
	max_score_date, min_score, min_score_date, date_min, date_max, 
	email_sent)

# save
write.table(report_text, paste0(temp_data_path, 
	"report_", execution_id, ".txt"), row.names=FALSE, 
    col.names=FALSE, quote=FALSE)



#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#

