#----------------------------------------------------------------------------#

# Purpose:     Master Settings
# Author:      CM
# Date:        Jan 2017
# Language:    Shell (.sh)

#----------------------------------------------------------------------------#

#----------------------------------------------------------------------------#
#                                  Settings                                  #
#----------------------------------------------------------------------------#

# initialise  [* DEFAULT]
#-------------------------------------------------#
export execution_id=`date +%s`
echo $execution_id

export current_date=$(date +"%m_%d_%Y")
echo $current_date

export wd_path=$(pwd)
echo $wd_path

echo $PATH

# directory settings
#-------------------------------------------------#

# directories [* DEFAULT SETTINGS]
export wd_path_data=$wd_path"/data"
export wd_path_code=$wd_path"/code_base"
export wd_path_model=$wd_path"/model"
export wd_path_helper=$wd_path"/helper"
export wd_path_helper_email=$wd_path"/helper/email"
export wd_path_helper_cron=$wd_path"/helper/user_setting/cron"
export wd_path_log=$wd_path"/log"

# external paths
export wd_path_output=$(cd $wd_path/../../../output; pwd)

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
export email_text=$(cat ${wd_path_helper_email}/email_text.txt)

# Cocoa Dialogue [DEFAULT]
#-------------------------------------------------#
export CD="$wd_path/code_base/helper_code/CocoaDialog.app/Contents/MacOS/CocoaDialog"

# php settings [DEFAULT]
#-------------------------------------------------#
export php_custom_path="/usr/local/php5/bin/php"
# export php_custom_path_ini=$(${php_custom_path} -r "echo php_ini_loaded_file();")
export PHP_ini="/usr/local/php5/lib/php.ini"

printf "\n###\n"

#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#
