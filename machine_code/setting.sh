#----------------------------------------------------------------------------#

# Purpose:     Master Settings
# Author:      CM
# Date:        Jan 2017
# Language:    Shell (.sh)

#----------------------------------------------------------------------------#

#----------------------------------------------------------------------------#
#                                    Settings                                #
#----------------------------------------------------------------------------#


# initialise  [* DEFAULT]
#-------------------------------------------------#
export execution_id=`date +%s`
echo $execution_id

export current_date=$(date +"%m_%d_%Y")
echo $current_date

# directory settings
#-------------------------------------------------#

# directories [CUSTOMISE]
export wd_path="/Users/claramarquardt/Google_Drive/Jobs/indep_project/email_sentiment/"

# directories [* DEFAULT SETTINGS]
export wd_path_data=$wd_path"/data"
export wd_path_code=$wd_path"/code_base"
export wd_path_model=$wd_path"/model"
export wd_path_helper=$wd_path"/helper"

# subdirectories [* DEFAULT SETTINGS]

## data paths
export data_path_raw=$wd_path_data"/email_data"
export data_path_temp=$wd_path_data"/temp_data"
export data_path_archived=$wd_path_data"/archived_data/email_data"
export data_path_train=$wd_path_data"/train_data"

## code paths
export init_path=$wd_path_code"/helper_code"

# email settings [DEFAULT]
#-------------------------------------------------#

export email_address=`cat helper/email/email_username.txt`
export email_pwd=`cat helper/email/email_password.txt`
export email_sender=`cat helper/email/email_sender.txt`
export email_text=`cat helper/email/email_text.txt`

#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#
