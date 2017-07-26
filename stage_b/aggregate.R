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
init_path            <- commandArgs(trailingOnly = TRUE)[1]
execution_id         <- commandArgs(trailingOnly = TRUE)[2]
temp_data_path       <- commandArgs(trailingOnly = TRUE)[3]
helper_path          <- commandArgs(trailingOnly = TRUE)[4]
log_path             <- commandArgs(trailingOnly = TRUE)[5]
lib_path             <- commandArgs(trailingOnly = TRUE)[6]

# output buffer
#-------------------------------------------------#
sink(paste0(log_path, "/aggregate_", execution_id,".txt"), append=FALSE, split=FALSE)

# dependencies
#-------------------------------------------------#
source(paste0(init_path, "/R_init.R"))

# parameters / helpers
#-------------------------------------------------#

#----------------------------------------------------------------------------#
#                                    Code                                    #
#----------------------------------------------------------------------------#

# load the data table
sentiment_dt_raw <- readRDS(paste0(temp_data_path,"/",
	grep(".Rds", list.files(temp_data_path), value=T)[1]))

# print(str(sentiment_dt_raw))

# graph
#----------------------------------------------------------------------------#

# clean up data
#-------------------------------------------------#

## format dates & omit sample emails
sentiment_dt_raw[, date:=as.IDate(date, "%d_%m_%Y")]
sentiment_dt_raw <- sentiment_dt_raw[year(date)==2017]

## re-scale score (invert)
sentiment_dt_raw[, score:=1-score]

## aggregate
sentiment_dt_raw[, score_mean:=mean(score), by=c("date")]
sentiment_dt_raw[, score_mean:=mean(score), by=c("recipient")]
sentiment_dt_raw[, N:=.N, by=c("recipient")]

sentiment_dt_date      <- unique(copy(sentiment_dt_raw), by=c("date"))
sentiment_dt_recipient <- unique(copy(sentiment_dt_raw), by=c("recipient"))

## rescale
min <- min(sentiment_dt_date$score_mean, sentiment_dt_recipient$score_mean)
max <- max(sentiment_dt_date$score_mean,  sentiment_dt_recipient$score_mean)
new_min <- 0.46
new_max <- 0.73

sentiment_dt_date[, score_mean:=(score_mean-min)*((new_max-new_min)/(max-min)) + new_min]
sentiment_dt_recipient[, score_mean:=(score_mean-min)*((new_max-new_min)/(max-min)) + new_min]

# summary stats - date
#-------------------------------------------------#

email_sent <- as.character(nrow(sentiment_dt_raw))
daily_mean <- as.character(round(mean(sentiment_dt_date$score_mean),2))

date_min   <- as.character(min(sentiment_dt_date$date))
date_max   <- as.character(max(sentiment_dt_date$date))

daily_min      <- as.character(round(sentiment_dt_date[score_mean==min(score_mean)]$score_mean,2))
daily_min_date <- as.character(sentiment_dt_date[score_mean==min(score_mean)]$date)

daily_max      <- as.character(round(sentiment_dt_date[score_mean==max(score_mean)]$score_mean,2))
daily_max_date <- as.character(sentiment_dt_date[score_mean==max(score_mean)]$date)

# summary stats - recipient
#-------------------------------------------------#

# sort
setorder(sentiment_dt_recipient, -score_mean)

# collapse
sentiment_dt_recipient[, score_comb:=paste0(recipient, " (Pos. Score: ", 
	round(score_mean,2), " / Emails: ", N, ")"), by=1:nrow(sentiment_dt_recipient)]

# top 5
unique_recipient <- nrow(sentiment_dt_recipient)
top_5            <- head(sentiment_dt_recipient$score_comb)[1:min(floor(unique_recipient/2), 5)]
bottom_5         <- tail(sentiment_dt_recipient$score_comb)[min(floor(unique_recipient/2), 5):1]

# collapse
top_5       <- paste0(top_5, collapse="\n")
bottom_5    <- paste0(bottom_5, collapse="\n")

# plot
#-------------------------------------------------#

sentiment_plot <- ggplot(data=sentiment_dt_date) + 
	labs(
		x="Date",
		y="Daily Positivity (0-1)",
		title="How Am I Doing?", 
		subtitle=sprintf("Based on %s emails send over the period: %s to %s",
			email_sent, as.character(date_min), as.character(date_max))
	) + 
	geom_line(aes(x=date, y=score_mean)) +
	theme_basic() + 
	theme_legend_bottom()
 
# save
ggsave(paste0(temp_data_path, "/mean_plot_", execution_id, ".pdf"), sentiment_plot)

# report
#-------------------------------------------------#

# read report outline
report_text <- paste0(readLines(paste0(helper_path, "/email_text.txt")), collapse="\n")

report_text <- gsub("XX", "%s", report_text)
report_text <- sprintf(report_text, daily_mean, daily_max, 
	date_max, daily_min, date_min, top_5, bottom_5, date_min, date_max, 
	email_sent)

# save
write.table(report_text, paste0(temp_data_path, 
	"/report_", execution_id, ".txt"), row.names=FALSE, 
    col.names=FALSE, quote=FALSE)

sink()

#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#

