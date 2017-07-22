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
# read -e -p "" 
printf "###\n\n"

## obtain user settings
unset email_date
read -p 'Enter earliest email date (e.g. 03-July-2017):' email_date
export email_date=${email_date}

unset email_address
read -p 'Enter email username (e.g. test@gmail.com):' email_address
export email_address=${email_address}

unset email_pwd
read -s -p 'Enter email password:' email_pwd
export email_pwd=${email_pwd}
printf "\n"

printf "\n###\n"

#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#



