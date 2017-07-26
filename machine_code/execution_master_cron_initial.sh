#----------------------------------------------------------------------------#

# Purpose:     Master Execution Script - Setup Cron job
# Author:      CM
# Date:        July 2017
# Language:    Shell (.sh)

#----------------------------------------------------------------------------#

# Settings
#----------------------------------------------------------------------------#
printf "\n# Initialising\n\n"
source code/machine_code/setting.sh 

printf "\n# Settings\n\n"
source code/machine_code/user_setting_cron_initial.sh 

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
sudo crontab -u root -l | grep -v '/execution_master_cron.sh'  | sudo crontab -u root -

# execute
echo -e "$(sudo crontab -u root -l)\n00 12 * * ${weekday} cd ${wd_path_helper_cron} && ${wd_path_code}/machine_code/execution_master_cron.sh" | sudo crontab -u root -

# output 
printf "\n# Cron Job Succesfully Initialised\n"


#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#

