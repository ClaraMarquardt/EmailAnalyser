# How am I doing? _Email-Based Sentiment Analysis_

### Requirements
--------------------------------

[1] R (With command line integration)

[2] Terminal (Installed by Default on MacOSX) (* Assume that running bash (not e.g. zshrc))

[3] Gmail email account (* MVP - tool can be extended to work with other email clients)

[3] * php with imap support - provided as part of package (for MaxOSx)


### Execution
--------------------------------

#### OPTION A - Interactive Mode (Output -> Desktop)
````
# Execute
cd [local path]/email_sentiment              # navigate to the 'email_sentiment' directory
source code/machine_code/execution_master.sh # start the tool

# Note
* You may need to modify the security settings here (need to modify only once)
to allow the script to access your account: https://myaccount.google.com/lesssecureapps

````

#### OPTION B - Automatic Weekly Execution (Output -> Email)

````
# Set up the reoccurring job
cd [local path]/email_sentiment                           # navigate to the 'email_sentiment' directory
source code/machine_code/execution_master_cron_initial.sh # set-up the reoccurring job

# Note
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
