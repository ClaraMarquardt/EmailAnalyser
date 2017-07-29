#----------------------------------------------------------------------------#

# Purpose:     Master Execution Script
# Author:      CM
# Date:        July 2017
# Language:    Shell (.sh)

#----------------------------------------------------------------------------#

# Settings
#----------------------------------------------------------------------------#
printf "\n# Initialising\n\n"
source code/machine_code/setting.sh 

printf "\n# Settings\n\n"
source code/machine_code/user_setting.sh 

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
${php_custom_path} -c ${php_custom_path_ini} -f "email_extract.php"

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
${wd_path_helper_email} ${wd_path_log} ${email_address}" aggregate.R ${wd_path_log}/aggregate_${execution_id}.Rout

## delete output file
[ -e .RData ] && rm .RData

# Stage-b (iii): Clear 
#----------------------------------------------------------------------------#
printf "\n# Clearing Data\n"

## delete all emails
cd ${data_path_raw_outbox}
rm email*txt

## create output folder
mkdir ${wd_path_output}/output_${current_date}_${execution_id}

## move output to location & delete all data
cd ${data_path_temp}
mv *mean_plot_${execution_id}* ${wd_path_output}/output_${current_date}_${execution_id}/how_am_I_doing_plot_${current_date}.pdf
mv *report_${execution_id}* ${wd_path_output}/output_${current_date}_${execution_id}/how_am_I_doing_report_${current_date}.txt
rm *${execution_id}*

## delete log files
cd ${wd_path_log}
cp classify_${execution_id}*txt ${wd_path_output}/output_${current_date}_${execution_id}/how_am_I_doing_log_${current_date}.txt
if [ "${keep_log}" == "No" ]; then
	cd ${wd_path_log}
	rm *${execution_id}*
else 
	printf "\n# Log files kept - See ${wd_path_log}\n"
fi


# Stage-d: Output
#----------------------------------------------------------------------------#
printf "\n# Completed - See the report & graph at ${wd_path_output}/output_${current_date}_${execution_id}/\n"
cd ${wd_path}

#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#

