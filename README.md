### **How am I doing?** (_An Email-Based Sentiment Analysis Tool_)

_Current Version: V0.7 (August 18th 2017)_

- Application Repository: hhttps://drive.google.com/open?id=0B8_7JE9uq-iDZkNpbmtSZEZnQ28
- Application Code Repository: https://github.com/ClaraMarquardt/EmailAnalyser

#### # OVERVIEW

##### **## Execution Modes**  
The application can be executed in two modes:  

[1] _**On Demand**_ - The application prompts you for a start date (e.g. yesterday or 2 weeks ago) and your email account details. All emails sent on/after the start date will be analyzed and the analysis results will be stored in the 'output folder' upon completion (Note: Depending on how many emails are to be analyzed this may take some time). 

[2] _**Regular Schedule**_ - The application prompts you once for a time interval over which emails are to be analyzed (e.g. 7 days or 14 days), the weekday on which the job is to be executed, and your email account details. Every week at noon on the selected weekday all emails sent over the specified time interval (e.g. over the past 7 days or the past 14 days) will be analyzed (in the background) and an email will be sent to you with the analysis results upon completion. 

##### **## Output**  
The application generates (a) a report providing you with an overview of your 'positivity score' by date and email recipient, (b) a visualization of your 'positivity score' over the analysis time interval and (c) (_only in 'On Demand' mode_) a text file with the individual emails that were analyzed and their score (Sample output is available here: XXX)

##### **## Notes**  

 - _Privacy & Security_: All email analysis is performed locally, i.e. no emails leave the machine on which the application is executed. The email account details are used to download the emails to the local machine (through an IMAP connection) where they are analyzed. Upon completion of the analysis all emails are  deleted. In 'Regular Schedule' mode the account credentials need to be stored (so as to allow the application to run without user input) - the credentials are stored (in the application directory) in a text file which is root-password protected. (_Note: Encryption is temporarly disabled in V0.7_)
 
 - _Scoring Algorithm_: The sentiment analysis algorithm was trained on 1.3 million English-language tweets from which emojis had been removed -> (i) The score assigned to non-English emails will not be meaningful and (ii) sentiment conveyed through emojis will not be captured. 

 - _Regular Schedule Execution Constraints_: 'Regular Schedule' mode execution (using Cron) requires that the computer is turned on and connected to the Internet at the time of job execution. Should the computer be turned off the job will be next executed the following week.  

- *Backend structure*: The application is structured around a number of bash scripts 
which are wrapped into a MacOSX application (.app) using Platypus and cocoaDialogue. Each bash script calls upon scripts written in e.g. R and php. The codebase and supporting files can be accessed by 
right clicking the application icon and selecting "Show Package Contents". 

#### # SET-UP & EXECUTION

##### **## Requirements & Dependencies**  

````
The application is designed to run on MacOSx (testing has been performed on MaxOSx Sierra and El Capitan)

# Key - _Installed as part of the set-up process_
* R & Set of R Packages 
* php with imap support 
* Base Dependencies: Homebrew, Xcode (command line applications), gcc, gawk, wget

# Other
* Gmail-based email account. The account needs to be 
configured to support to allow external applications to connect through imap (see: 
https://myaccount.google.com/lesssecureapps) 
* Supporting dependencies - pre-installed on MacOSX: Bash


````

##### **## Set-up**  

````
# [1] Download the application & Unzip to a selected path ('local path')
Download the most up-to date version of the application from the application repository (_see above_)

## Notes:
* It is recommended that the path to the application directory does not contain any spaces

# [2] Execute the set-up script (terminal)
[1] Ensure that the machine is connected to the Internet

[2] Launch the installer
cd [local path]/EmailAnalyser
source documentation_setup/installer/set_up_wrapper.sh && \
source documentation_setup/installer/set_up.sh > documentation_setup/installer/set_up.txt 2>&1 

# [3] Confirm that the application was successful 
Launch the EmailAnalyser.app and confirm that the application starts without any error messages

## Notes:
* When asked whether to complete a Homebrew reset - enter 'No' unless you encounter problems during 
set-up in which case it may help to re-run the set-up script with a Homebrew reset (enter 'Yes')
* When asked for a password - enter the root password (required to install php)
* Depending on whether or not e.g. Xcode (command line applications), are already installed installation may 
take up to 30 minutes


````

##### **## Execution - 'On Demand'**  

````
# [1] Launch the application
Launch the application - select "Interactive Mode"

## Notes:
* You will be asked a number of questions:
** 'Enter the earliest email date (e.g. 03-July-2017):' - Enter the earliest date from which emails are to be 
analyzed (date must be entered in the suggested format)
** 'Enter email username (e.g. test@gmail.com):' / 'Enter email password' - Enter your gmail username and password 
** 'Keep log files (Yes/No):' - Enter 'No' unless you wish to keep the log files generated 
during execution (e.g. for the purposes of debugging)
````

##### **## Execution - 'Regular Schedule'**  

````
# [1] Initialize the regular execution of the application
Launch the application - select "Regular Mode"

## Notes:
* You will be asked a number of questions:
** 'Enter weekday on which job is to be run (e.g. Sunday -> 0):'  - Enter the weekday (number) on which the 
application is to be executed
** 'Enter interval (days from date of execution) over which to parse emails (e.g. 7): ' - Enter the number of days 
over which emails are to be parsed
** 'Enter email username (e.g. test@gmail.com):' / 'Enter email password' - Enter your gmail username and password 
* When asked for a password - enter the root password (required to install the Cron job)
````

##### **## Execution - 'On Demand'**  

````
# [1] Launch the application
Launch the application - select "Regular, scheduled execution"

## Notes:
* You will be asked a number of questions:
** 'Enter the earliest email date (e.g. 03-July-2017):' - Enter the earliest date from which emails are to be 
analyzed (date must be entered in the suggested format)
** 'Enter email username (e.g. test@gmail.com):' / 'Enter email password' - Enter your gmail username and password 
** 'Keep log files (Yes/No):' - Enter 'No' unless you wish to keep the log files generated 
during execution (e.g. for the purposes of debugging)
````

##### **## Troubleshooting **  

````
# Reset the application
Launch the application - select "Reset Application"



````



