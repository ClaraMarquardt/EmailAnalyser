#!/bin/bash

#----------------------------------------------------------------------------#

# Purpose:     Master Execution Script
# Author:      CM
# Date:        July 2017
# Language:    Shell (.sh)

#----------------------------------------------------------------------------#

# Settings
#----------------------------------------------------------------------------#
## read in saved settings
printf "\n# Settings\n\n"

chmod a+rwx cron_user_setting
while read -r line
do
    eval $line
done < cron_user_setting
chmod a-rwx cron_user_setting && chmod o+rwx cron_user_setting 
cd ${wd_path}

printf "\n# Initialising\n\n"
source code/machine_code/setting.sh 

## update date
export email_date=$(date -v -${length}d +"%d-%B-%Y") 

#----------------------------------------------------------------------------#
#                         Step-by-Step Tool Execution                        #
#----------------------------------------------------------------------------#

#----------------------------------------------------------------------------#
#----------------------------------------------------------------------------#
# Execution Commmand #1
#----------------------------------------------------------------------------#
#----------------------------------------------------------------------------#

# Stage-a: Obtain emails
#----------------------------------------------------------------------------#
printf "\n# Obtaining Emails\n"

# execute
#---------------------------------------------------#
cd ${wd_path_code}/stage_a
echo "$(which php)"
${php_custom_path} -c ${php_custom_path_ini} -f "email_extract.php"

# Stage-b (i): Process emails
#----------------------------------------------------------------------------#
printf "\n# Classifying Emails\n"

# execute
#---------------------------------------------------#
cd ${wd_path_code}/stage_b

## classify
${R_path} CMD BATCH --no-save "--args ${init_path} ${execution_id} ${data_path_train} \
${data_path_raw_outbox} ${data_path_temp} ${wd_path_log} ${wd_path_model} ${lib_path}" classify.R \
${wd_path_log}/classify_${execution_id}.Rout

## delete output file
[ -e .RData ] && rm .RData

# Stage-b (ii): Aggregate output
#----------------------------------------------------------------------------#
printf "\n# Generating Report\n"

# execute
#---------------------------------------------------#
cd ${wd_path_code}/stage_b

## aggregate
${R_path} CMD BATCH --no-save "--args ${init_path} ${execution_id} ${data_path_temp} \
${wd_path_helper_email} ${wd_path_log} ${lib_path} ${email_address}" aggregate.R ${wd_path_log}/aggregate_${execution_id}.Rout

## delete output file
[ -e .RData ] && rm .RData

# Stage-c: Send email
#----------------------------------------------------------------------------#
printf "\n# Sending Email\n"

# execute
#---------------------------------------------------#
cd ${wd_path_code}/stage_c

## obtain file names
email_report_file=$(ls ${data_path_temp}/*report_${execution_id}*)
export email_report=`cat ${email_report_file}`
export email_plot=$(ls ${data_path_temp}/*mean_plot_${execution_id}*)

## aggregate
${php_custom_path} -c ${php_custom_path_ini} -f  "send_email.php"

# Stage-d: Clear 
#----------------------------------------------------------------------------#
printf "\n# Clearing Data\n"

## delete all emails
cd ${data_path_raw_outbox}
rm email*txt

## move output to location & delete all data
cd ${data_path_temp}
rm *${execution_id}*

## delete log files
cd ${wd_path_log}
rm *${execution_id}*

# Stage-d: Output
#----------------------------------------------------------------------------#
printf "\n# Completed\n"
cd ${wd_path}

#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#

