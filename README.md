# How am I doing? _Email-Based Sentiment Analysis_

### Overview
--------------------------------

* Two modes

[1] Interactive Mode - You will be prompted to enter a date from which to start pulling emails, your email address and your email password everytime you run the tool (e.g. analyse all emails over the past 4 weeks (this will take some time)). At completion the plot, report and log file with the individual emails will be stored in your home directory (~/)

[2] Batch Mode - You will .....


* Overall
- All analysis is done locally - emails are pulled from the server and all analysis is done locally. All emails (and log files) are (unless in interactive mode) deleted upon complettion
- In interactive mode no data is stored vs. in batch mode - username/password is stored in a root access only text file to allow the job scheduler to perform the job at regular intervals

### Requirements
--------------------------------
R reinsalled
oerall run time
lkeep log files
[0] MACOSX
intnet
[1] Terminal (Installed by Default on MacOSX) (* Assume that running bash (not e.g. zshrc))
may need to click yes, etc. will take longer if no xcode instlaled
[2] Gmail email account (* MVP - tool can be extended to work with other email clients)
* You may need to modify the security settings here (need to modify only once)
to allow the script to access your account: https://myaccount.google.com/lesssecureapps

[3] Provided as part of package (if not already installed): R & numbe rof R packages

[4] Provided as part of package: php with imap support - provided as part of package (for MaxOSx)
baseline dependcines & sub (e..g xcode, homrbew...)
### Installation
--------------------------------
````

# Obtain folder
Unzip directory to path, e.g. Desktop

# Install
cd [local path]/email_sentiment              # navigate to the 'email_sentiment' directory
source code/machine_code/execution_master.sh # start the setup script 



````

### Execution
--------------------------------

#### OPTION A - Interactive Mode (Output -> Desktop)
````
# Execute
cd [local path]/email_sentiment              # navigate to the 'email_sentiment' directory
source code/machine_code/set_up.sh > log/set_up.txt 2>&1 # start the tool

# Note
* You may initially be prompted for a password ("Password: ") - 
enter the root password (this is required to set up the regular execution of the script)


````

#### OPTION B - Automatic Weekly Execution (Output -> Email)

````
# Set up the reoccurring job
cd [local path]/email_sentiment                           # navigate to the 'email_sentiment' directory
source code/machine_code/execution_master_cron_initial.sh # set-up the reoccurring job

# User settings
You will be asked a number of questions: 


# Note
* You may initially be prompted for a password ("Password: ") - 
enter the root password (this is required to set up the regular execution of the script)
* Your email username and password will be stored in a **_root access-only_**
 text file located in the _email_sentiment_ directory
* Job will execute at noon on the selected weekday 
* Job will only execute if the computer is turned on 

````

### Additional Notes
--------------------------------

#### Potential Problems

* PHP problems - Centos (rather than MacOSX)

````
## Install PHP
sudo yum install php php-mysql

## Install the imap integration
sudo yum install php-imap.x86_64

````
