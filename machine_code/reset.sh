#----------------------------------------------------------------------------#

# Purpose:     Master Execution Script - Reset Application
# Author:      CM
# Date:        Jan 2017
# Language:    Shell (.sh)

#----------------------------------------------------------------------------#

# Settings
#----------------------------------------------------------------------------#
source code_base/machine_code/setting.sh

# Reset Application
#----------------------------------------------------------------------------#

# clear all nuisance files
find $wd_path \( -name "*.DS*" \)  -exec rm {} \;

# clear all data
cd ${data_path_raw_outbox}
rm email*txt

cd ${data_path_temp}
rm *txt
rm *csv
rm *Rds

# clear all logs
find ${wd_path_log}/ -type f \( -name "*.txt" -or -name "*Rout" \)  -exec rm {} \;

# clear all output
find ${wd_path_output} -type d -maxdepth 2 \( -name "*output_*" \) -exec rm -rf {} \;

# Status
#----------------------------------------------------------------------------#
$CD bubble --title "Email Analyser" \
--text "Successfully Reset the Application" ‑‑no‑timeout \
--background-top "F8F8F8" --background-bottom "F8F8F8" --border-color "F8F8F8" \
--icon-file "${wd_path_helper}/icon/icon_temp.png"

#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#
