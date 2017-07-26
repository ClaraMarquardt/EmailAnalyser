#!/bin/bash

#----------------------------------------------------------------------------#

# Purpose:     User Settings - Cron Job
# Author:      CM
# Date:        July 2017
# Language:    Shell (.sh)

#----------------------------------------------------------------------------#

#----------------------------------------------------------------------------#
#                                    Settings                                #
#----------------------------------------------------------------------------#

## initialise
# read -e -p "" 
printf "###\n\n"

## obtain user settings
unset weekday
read -p 'Enter weekday on which job is to be run (e.g. Sunday -> 0): ' weekday
export weekday=${weekday}

unset length
read -p 'Enter interval (days from date of report) over which to parse emails (e.g. 7): ' length
export length=${length}

unset email_address
read -p 'Enter email username (e.g. test@gmail.com):' email_address
export email_address=${email_address}

unset email_pwd
read -s -p 'Enter email password:' email_pwd
export email_pwd=${email_pwd}
printf "\n"

printf "\n###\n"

## store wd
export wd_path=$(pwd)

## save user settings 
[ -e ${wd_path_helper_cron}/cron_user_setting ] && chmod +rwx ${wd_path_helper_cron}/cron_user_setting \
	&& rm ${wd_path_helper_cron}/cron_user_setting

for var in weekday length email_address email_pwd wd_path
do
    echo "$var="'"'"$(eval echo '$'"$var")"'"'
done >> ${wd_path_helper_cron}/cron_user_setting

## set to root access
chmod a-rwx ${wd_path_helper_cron}/cron_user_setting
chmod o+rwx ${wd_path_helper_cron}/cron_user_setting

#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#



