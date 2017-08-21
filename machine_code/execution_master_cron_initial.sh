#----------------------------------------------------------------------------#

# Purpose:     Master Execution Script - Setup Cron Job
# Author:      CM
# Date:        July 2017
# Language:    Shell (.sh)

#----------------------------------------------------------------------------#

# Settings
#----------------------------------------------------------------------------#
printf "\n# Settings\n\n"
source code_base/machine_code/user_setting_cron_initial.sh 

#----------------------------------------------------------------------------#
#                         Step-by-Step Tool Execution                        #
#----------------------------------------------------------------------------#

#----------------------------------------------------------------------------#
#----------------------------------------------------------------------------#
# Execution Commmand #1
#----------------------------------------------------------------------------#
#----------------------------------------------------------------------------#

# Intialise Cron Job
#----------------------------------------------------------------------------#
printf "\n# Initialising Cron Job\n\n"

# delete any old jobs
# sudo crontab -u root -l | grep -v '/execution_master_cron.sh'  | sudo crontab -u root -
crontab -l | grep -v '/execution_master_cron.sh'  | crontab -

# execute
# echo -e "$(sudo crontab -u root -l)\n00 12 * * ${weekday} cd ${wd_path_helper_cron} && ${wd_path_code}/machine_code/execution_master_cron.sh" | sudo crontab -u root -
echo -e "$(crontab -l)\n00 12 * * ${weekday} cd ${wd_path_helper_cron} && ${wd_path_code}/machine_code/execution_master_cron.sh" | crontab -

# output 
printf "\n# Cron Job Succesfully Initialised\n"

# Status
#----------------------------------------------------------------------------#
$CD bubble --title "Email Analyser" \
--text "Successfully Initialised the Application" ‑‑no‑timeout \
--background-top "F8F8F8" --background-bottom "F8F8F8" --border-color "F8F8F8" \
--icon-file "${wd_path_helper}/icon/icon_temp.png"


#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#

