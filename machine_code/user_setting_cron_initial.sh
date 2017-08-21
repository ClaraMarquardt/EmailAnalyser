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
export weekday=`$CD inputbox --title "Email Analyser - Setup" --informative-text \
	"Enter the weekday on which job is to be run (e.g. Sunday -> 0):" --button1 "  OK  " ‑‑no‑cancel`
export weekday=${weekday:2}

unset length
export length=`$CD inputbox --title "Email Analyser - Setup" --informative-text \
	"Enter the interval (days from date of execution) over which to parse emails (e.g. 7):" --button1 "  OK  " ‑‑no‑cancel`
export length=${length:2}

unset email_address
export email_address=`$CD inputbox --title "Email Analyser - Setup" --informative-text \
	"Enter the email username (e.g. test@gmail.com):" --button1 "  OK  " ‑‑no‑cancel`
export email_address=${email_address:2}

unset email_pwd
export email_pwd=`$CD inputbox --title "Email Analyser - Setup" --informative-text \
	"Enter the email password:" --button1 "  OK  " ‑‑no‑cancel`
export email_pwd=${email_pwd:2}

printf "\n###\n"

## store wd
export wd_path=$(pwd)
export R_path=$(which R)

## save user settings 
# [ -e ${wd_path_helper_cron}/cron_user_setting ] && chmod +rwx ${wd_path_helper_cron}/cron_user_setting \
# 	&& rm ${wd_path_helper_cron}/cron_user_setting
[ -e ${wd_path_helper_cron}/cron_user_setting ] && rm ${wd_path_helper_cron}/cron_user_setting

for var in weekday length email_address email_pwd wd_path R_path
do
    echo "export $var="'"'"$(eval echo '$'"$var")"'"'
done >> ${wd_path_helper_cron}/cron_user_setting

## set to root access
# chmod a-rwx ${wd_path_helper_cron}/cron_user_setting
# chmod o+rwx ${wd_path_helper_cron}/cron_user_setting

#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#



