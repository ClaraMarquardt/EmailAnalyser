# How am I doing? _Email-Based Sentiment Analysis_

### Requirements
--------------------------------

[1] R (With command line integration)

[2] Terminal (Installed by Default on MacOSX)

[3] * php with imap support - provided as part of package


### Execution
--------------------------------

#### OPTION A - Interactive Mode (Output -> Desktop)
````
cd [local path]/email_sentiment              # navigate to the 'email_sentiment' directory
source code/machine_code/execution_master.sh # start the tool

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
