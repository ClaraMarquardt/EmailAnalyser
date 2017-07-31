### **How am I doing?** (_An Email-Based Sentiment Analysis Tool_)

#### # OVERVIEW

##### **## Execution Modes**  
The tool can be executed in two modes:  

[1] _**On Demand**_ - The tool prompts you for a start date (e.g. yesterday or 2 weeks ago) and your email account details. All emails sent after the start date will be analysed and a report will be stored in the 'output folder' upon completion (Note: Depending on how many emails are to be analysed this may take some time). 

[2] _**Regular Schedule**_ - The tool will prompt you once for a time interval over which emails are to be analysed (e.g. 7 days or 14 days) , the weekday on which the job is to be exceuted, and your email account details and your email account details. Every week at noon on theh selected weekday all emails over the specified time interval (e.g. the past 7 days or te past 14 days) will be analysed (in the abckground) and an email will be sent you account with the report upon completion. 

##### **## Output**  
The tool generates (a) a report providing you with an overview of your 'positivity score' by date and email recipient, (b) a visualisation of 'positivity score' over the analayis time interval and (c) (Only in  "On Demand") a text file wth the the individual analysed emails and their score 

##### **## Notes**  

 - _Privacy & Security_: All email analys is done locally, i.e. no email data leaves the machine on which the tool is executed. The account details are used to download the emails (IMAP) onto the local machine where the analysis is performed. Uupon conclusion of the analysos al lemails are  deleted. In "Regular Schedule" mode the account details need to be stored for access by the tool - the credential sare stored in a text filw ith root ces s.
 
 - _Scoring Algorithm_: The sentiment analysis algois based ona dat aset of Enlish speaking twets. Suport for other langueas is thus not ensured. EMojis are exclued  jos 

 - _Regular Schedule Execution Constriants_: Onlu when turned on  / wil not repate dif rutned of & conencted to intert

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
Download the most up-to date version from: https://drive.google.com/open?id=0B8_7JE9uq-iDZkNpbmtSZEZnQ28

# [2] Execute the set-up script 
cd [local path]/email_sentiment 
source code/machine_code/set_up_wrapper.sh  && source code/machine_code/set_up.sh > log/set_up.txt 2>&1 # Ensure that no spaces are appendedn to the end lif the line

## Notes:
* You will need to be connected to the internet during the set-up process
* When asked whether to complete a homebrew reset ("Complete Homebrew Reset (Yes/No)") - enter 'No' unless you encounter problems in the set-up process in which case it may help to rerun the set-up script with a homebrew reset (enter 'Yes')
* When asked for a password - enter the root password (required to install php)
* Depending on whether or not e.g. the command line tools/Xcode are isntalled installation may take up to 30 minutes

# [3] Ensure that your email account supports an IMAP connection from an external PHP client
Visit: https://myaccount.google.com/lesssecureapps

````

##### **## Execution - 'On Demand'**  

````
# [1] Execute the tool
cd [local path]/email_sentiment 
source code/machine_code/execution_master.sh 

## Notes:
* You will be asked a number of questions:
** 'Enter earliest email date (e.g. 03-July-2017):' - Enter the earliest date from which emails are to be analysed (date must be entered in the suggested format)
** 'Enter email username (e.g. test@gmail.com):' / 'Enter email password' - Enter your gmail username and password 
** 'Keep log files (Yes/No):' - Enter 'No' unless you wish to keep the log files generated durig the execution (this may be useful if the tool crashes)
````

##### **## Execution - 'Regular Schedule'**  

````
# [1] Initialise the rregualr exection to teht ool
cd [local path]/email_sentiment 
source code/machine_code/execution_master_cron_initial.sh

## Notes:
* You will be asked a number of questions:
** 'Enter weekday on which job is to be run (e.g. Sunday -> 0):'  - 
**'Enter interval (days from date of report) over which to parse emails (e.g. 7): ' - 
** 'Enter email username (e.g. test@gmail.com):' / 'Enter email password' - Enter your gmail username and password 

````
