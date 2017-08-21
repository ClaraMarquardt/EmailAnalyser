#----------------------------------------------------------------------------#

# Purpose:     Master Execution Script - Train model
# Author:      CM
# Date:        July 2017
# Language:    Shell (.sh)

#----------------------------------------------------------------------------#

# Settings
#----------------------------------------------------------------------------#
printf "\n# Initialising\n\n"
source code_base/machine_code/setting.sh   ## master settings

#----------------------------------------------------------------------------#
#                         Step-by-Step Tool Execution                        #
#----------------------------------------------------------------------------#

# Train model
#----------------------------------------------------------------------------#
printf "\n# Train Model\n"

# Execute
#----------------------------------------------------------------------------#
cd ${wd_path_code}/model_train

R CMD BATCH --no-save "--args ${init_path} ${execution_id} ${data_path_train} \
${wd_path_model} ${wd_path_log} ${lib_path}" model_train.R ${wd_path_log}/model_train_${execution_id}.Rout


# Clear 
#----------------------------------------------------------------------------#
printf "\n# Clearing Data\n"

## delete log files
cd ${wd_path_log}
rm *${execution_id}*

cd ..

#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#

