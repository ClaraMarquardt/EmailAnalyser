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
sentiment_dt <- readRDS(paste0(temp_data_path,"/",
	grep(".Rds", list.files(temp_data_path), value=T)[1]))

# print(str(sentiment_dt))

# graph
#----------------------------------------------------------------------------#

# clean up data
#-------------------------------------------------#

## format dates & omit sample emails
sentiment_dt[, date:=as.IDate(date, "%d_%m_%Y")]
sentiment_dt <- sentiment_dt[year(date)==2017]

## re-scale score (invert)
sentiment_dt[, score:=1-score]

## aggregate
sentiment_dt[, score_mean:=mean(score), by=c("date")]
sentiment_dt[, score_var:=var(score), by=c("date")]
sentiment_dt <- unique(sentiment_dt, by=c("date"))

## rescale
min <- min(sentiment_dt$score_mean)
max <- max(sentiment_dt$score_mean)
new_min <- 0.46
new_max <- 0.73

sentiment_dt[, score_mean:=(score_mean-min)*((new_max-new_min)/(max-min)) + new_min]

# summary stats
#-------------------------------------------------#

email_sent <- nrow(sentiment_dt)
daily_mean <- round(mean(sentiment_dt$score_mean),2)

date_min   <- as.character(min(sentiment_dt$date))
date_max   <- as.character(max(sentiment_dt$date))

daily_min      <- round(sentiment_dt[score_mean==min(score_mean)]$score_mean,2)
daily_min_date <- as.character(sentiment_dt[score_mean==min(score_mean)]$date)

daily_max      <- round(sentiment_dt[score_mean==max(score_mean)]$score_mean,2)
daily_max_date <- as.character(sentiment_dt[score_mean==max(score_mean)]$date)

# plot
#-------------------------------------------------#

sentiment_plot <- ggplot(data=sentiment_dt) + 
	labs(
		x="Date",
		y="Daily Positivity (0-1)",
		title="How Am I Doing?", 
		subtitle=sprintf("Based on %d emails send over the period: %s to %s",
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
	date_max, daily_min, date_min, date_min, date_max, 
	email_sent)

# save
write.table(report_text, paste0(temp_data_path, 
	"/report_", execution_id, ".txt"), row.names=FALSE, 
    col.names=FALSE, quote=FALSE)

sink()

#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#

