### **How am I doing?** (_An Email-Based Sentiment Analysis Tool_)

#### # OVERVIEW

##### **## Execution Modes**  
The tool can be executed in two modes:  

[1] _**On Demand**_ - The tool prompts you for a start date (e.g. yesterday or 2 weeks ago) and your email account details. All emails sent on/after the start date will be analyzed and a report will be stored in the 'output folder' upon completion (Note: Depending on how many emails are to be analyzed this may take some time). 

[2] _**Regular Schedule**_ - The tool prompts you once for a time interval over which emails are to be analyzed (e.g. 7 days or 14 days), the weekday on which the job is to be executed, and your email account details. Every week at noon on the selected weekday all emails sent over the specified time interval (e.g. over the past 7 days or the past 14 days) will be analyzed (in the background) and an email will be sent you with the report upon completion. 

##### **## Output**  
The tool generates (a) a report providing you with an overview of your 'positivity score' by date and email recipient, (b) a visualization of your 'positivity score' over the analysis time interval and (c) (_only in 'On Demand' mode_) a text file with the the individual emails that were analyzed and their score 

##### **## Notes**  

 - _Privacy & Security_: All email analysis is done locally, i.e. no emails leave the machine on which the tool is executed. The email account details are used to download the emails to the local machine (through an IMAP connection) where the analysis is performed. Upon completion of the analysis all emails are  deleted. In 'Regular Schedule' mode the account details need to be stored (so as to allow the tool to run without user input) - the credential are stored (in the tool directory) in a text file which is root-password protected. 
 
 - _Scoring Algorithm_: The sentiment analysis algorithm was trained on 1.3 million English-language tweets from which emojis had been removed -> The score assigned to non-English emails will not be meaningful & sentiment conveyed through emojis will not be captured. 

 - _Regular Schedule Execution Constraints_: 'Regular Schedule' mode execution requires that the computer is turned on and connected to the Internet at the time of job execution. Should the computer be turned off the job will be next executed the following week.  

#### # SET-UP & EXECUTION

##### **## Requirements & Dependencies**  

````
The tool is designed to run on MacOSx

# Key
* R & Set of R Packages (Installed as part of set-up process)
* PHP with imap support (Installed as part of set-up process)
* _Base Dependencies_: Homebrew, Xcode (command line tools), gcc  (Installed as part of set-up process)

# Other
* Gmail-based email account 
* Terminal (Installed by Default / Tool is designed to be executed using bash (rather than e.g. zshrc))
````

##### **## Set-up**  

````
# [1] Download the tool & Unzip to a selected path ('local path')
Download the most up-to date version of the tool: https://drive.google.com/open?id=0B8_7JE9uq-iDZkNpbmtSZEZnQ28

# [2] Execute the set-up script (! Ensure that no spaces are appended to the end of the command)
cd [local path]/email_sentiment 
source code/machine_code/set_up_wrapper.sh  && source code/machine_code/set_up.sh > log/set_up.txt 2>&1 

## Notes:
* You will need to be connected to the Internet during the set-up process
* When asked whether to complete a Homebrew reset - enter 'No' 
unless you encounter problems during set-up  in which case it may 
help to rerun the set-up script with a Homebrew reset (enter 'Yes')
* When asked for a password - enter the root password (required to install php)
* Depending on whether or not e.g. Xcode (command line tools), are already 
installed installation may take up to 30 minutes

# [3] Ensure that your email account supports an imap connection from an external PHP client
Visit: https://myaccount.google.com/lesssecureapps

````

##### **## Execution - 'On Demand'**  

````
# [1] Execute the tool
cd [local path]/email_sentiment 
source code/machine_code/execution_master.sh 

## Notes:
* You will be asked a number of questions:
** 'Enter the earliest email date (e.g. 03-July-2017):' - Enter the earliest date from which 
emails are to be analyzed (date must be entered in the suggested format)
** 'Enter email username (e.g. test@gmail.com):' / 'Enter email password' - Enter your gmail username and password 
** 'Keep log files (Yes/No):' - Enter 'No' unless you wish to keep the log files generated 
during execution (e.g. for the purposes of debugging)
````

##### **## Execution - 'Regular Schedule'**  

````
# [1] Initialize the regular execution of the tool
cd [local path]/email_sentiment 
source code/machine_code/execution_master_cron_initial.sh

## Notes:
* You will be asked a number of questions:
** 'Enter weekday on which job is to be run (e.g. Sunday -> 0):'  - Enter the weekday (number) 
on which the tool is to be executed
** 'Enter interval (days from date of execution) over which to parse emails (e.g. 7): ' - Enter 
the number of days over which emails are to be parsed
** 'Enter email username (e.g. test@gmail.com):' / 'Enter email password' - Enter your gmail username and password 

````



