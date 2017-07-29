#----------------------------------------------------------------------------#

# Purpose:     Master Settings
# Author:      CM
# Date:        July 2017
# Language:    Shell (.sh)

#----------------------------------------------------------------------------#

#----------------------------------------------------------------------------#
#                                    Settings                                #
#----------------------------------------------------------------------------#

## initialise
printf "###\n\n"

# initialise  [* DEFAULT]
#-------------------------------------------------#

## settings
export wd_path=$(pwd)

export execution_id=`date +%s`
echo $execution_id

export current_date=$(date +"%m_%d_%Y")
echo $current_date

# directory settings
#-------------------------------------------------#

# directories [* DEFAULT SETTINGS]
export wd_path_data=$wd_path"/data"
export wd_path_code=$wd_path"/code"
export wd_path_model=$wd_path"/model"
export wd_path_helper_email=$wd_path"/helper/email"
export wd_path_helper_cron=$wd_path"/helper/cron"
export wd_path_log=$wd_path"/log"
export wd_path_output=$wd_path"/output"

# subdirectories [* DEFAULT SETTINGS]

## data paths
export data_path_raw_inbox=$wd_path_data"/email_data/inbox"
export data_path_raw_outbox=$wd_path_data"/email_data/outbox"
export data_path_temp=$wd_path_data"/temp_data"
export data_path_archived=$wd_path_data"/archived_data/email_data"
export data_path_train=$wd_path_data"/train_data"

## code paths
export init_path=$wd_path_code"/helper_code"

# email settings [DEFAULT]
#-------------------------------------------------#

## default settings
export email_text=$(cat ${wd_path_helper_email}/email_text.txt)

# php settings [DEFAULT]
#-------------------------------------------------#
export php_custom_path="/usr/local/php5/bin/php"
export php_custom_path_ini=$(${php_custom_path} -r "echo php_ini_loaded_file();")

printf "\n###\n"

#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#
