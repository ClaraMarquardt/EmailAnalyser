#!/bin/bash

#----------------------------------------------------------------------------#

# Purpose:     User Settings
# Author:      CM
# Date:        July 2017
# Language:    Shell (.sh)

#----------------------------------------------------------------------------#

#----------------------------------------------------------------------------#
#                                    Settings                                #
#----------------------------------------------------------------------------#

## initialise
printf "###\n\n"

## obtain user settings
unset email_date
export email_date=`$CD inputbox --title "Email Analyser - Setup" --informative-text \
	"Enter the earliest email date (e.g. 03-July-2017)" --button1 "  OK  " ‑‑no‑cancel`
export email_date=${email_date:2}

unset email_address
export email_address=`$CD inputbox --title "Email Analyser - Setup" --informative-text \
	"Enter your email username (e.g. test@gmail.com):" --button1 "  OK  " ‑‑no‑cancel`
export email_address=${email_address:2}

unset email_pwd
export email_pwd=`$CD inputbox --title "Email Analyser - Setup" --informative-text \
	"Enter your email password:" --button1 "  OK  " ‑‑no‑cancel`
export email_pwd=${email_pwd:2}

unset keep_log
export keep_log=`$CD inputbox --title "Email Analyser - Setup" --informative-text \
	"Keep log files (Yes/No)?" --button1 "  OK  " ‑‑no‑cancel`
export keep_log=${keep_log:2}

printf "\n###\n"

#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#



