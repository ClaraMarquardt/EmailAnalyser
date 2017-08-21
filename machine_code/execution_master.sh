#----------------------------------------------------------------------------#

# Purpose:     Master Execution Script 
# Author:      CM
# Date:        Jan 2017
# Language:    Shell (.sh)

#----------------------------------------------------------------------------#

# Settings
#----------------------------------------------------------------------------#
source code_base/machine_code/setting.sh

# Clear up output folder & log folder
#----------------------------------------------------------------------------#
find ${wd_path_output} -type d -maxdepth 1 \( -name "*output_*" \) -exec mv {} ${wd_path_output}/archived/ \;
find ${wd_path_log}/ -type f -maxdepth 1 \( -name "*txt*" -or -name "*Rout*" \) -exec mv {} ${wd_path_log}/archived/ \;

# User input
#----------------------------------------------------------------------------#
export mode=`$CD dropdown --title "Email Analyser" \
--text "Interactive mode or regular, scheduled execution?" \
--items "Interactive Mode" "Regular, scheduled execution" --button1 "Start" \
--button2 "Exit" --button3 "Reset Application"`

if [ "${mode:0:1}" = "2" ]; then

	printf "Exit"

	exit;

elif [ "${mode:0:1}" = "3" ]; then

	printf "Reset App"

	source code_base/machine_code/reset.sh

else

	export mode=${mode:2}

	echo $mode

fi

# Execute
#----------------------------------------------------------------------------#

if [ "$mode" = "0" ]; then

	printf "Starting: Interactive Mode"

	source code_base/machine_code/execution_master_interactive.sh

elif [ "$mode" = "1" ]; then

	printf "Starting: Regular/Scheduled Mode"

	source code_base/machine_code/execution_master_cron_initial.sh

fi

#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#