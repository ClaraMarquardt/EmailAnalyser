#----------------------------------------------------------------------------#

# Purpose:     Master Execution Script
# Author:      CM
# Date:        July 2017
# Language:    Shell (.sh)

#----------------------------------------------------------------------------#

# Settings
#----------------------------------------------------------------------------#
printf "\n# Settings\n\n"
source code/machine_code/user_setting.sh 

printf "\n# Initialising\n\n"
source code/machine_code/setting.sh 

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
php -f email_extract.php

# Stage-b (i): Process emails
#----------------------------------------------------------------------------#
printf "\n# Classifying Emails\n"

# execute
#---------------------------------------------------#
cd ${wd_path_code}/stage_b

## classify
R CMD BATCH --no-save "--args ${init_path} ${execution_id} ${data_path_train} \
${data_path_raw_outbox} ${data_path_temp} ${wd_path_log} ${wd_path_model}" classify.R \
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
R CMD BATCH --no-save "--args ${init_path} ${execution_id} ${data_path_temp} \
${wd_path_helper_email} ${wd_path_log}" aggregate.R ${wd_path_log}/aggregate_${execution_id}.Rout

## delete output file
[ -e .RData ] && rm .RData

# Stage-b (iii): Clear 
#----------------------------------------------------------------------------#
printf "\n# Clearing Data\n"

## delete all emails
cd ${data_path_raw_outbox}
rm email*txt

## move output to location & delete all data
cd ${data_path_temp}
mv *mean_plot_${execution_id}* ~/Desktop/how_am_I_doing_plot_${current_date}.pdf
mv *report_${execution_id}* ~/Desktop/how_am_I_doing_report_${current_date}.txt
rm *${execution_id}*


## delete log files
cd ${wd_path_log}
rm *${execution_id}*

# Stage-d: Output
#----------------------------------------------------------------------------#
printf "\n# Completed - See the report & graph at ~/Desktop/\n"
cd ..

#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#

