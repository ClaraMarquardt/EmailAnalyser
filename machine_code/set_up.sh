#!/bin/bash

# WD
wd_path=$(pwd)

# DateTime
current_date=$(date +"%m_%d_%Y / %H:%M")

# define log function
status_file=${wd_path}/log/config_status.txt
echo ${status_file}

echolog()
(
echo $1
echo $1 >> ${status_file}
)

# Initialisation
# ----------------
echolog "#---------------------#"
echolog "### DATE: $current_date ###"
echolog "#---------------------#"

echolog "### INITIAL CONFIGURATION ###"

# path
echolog "# WD: $(pwd)"
echolog "# PATH: $PATH"

# key dependencues
echolog "# PHP: $(which php)"
echolog "# PHP Version: $(php --version)"
echolog "# Xcode: $(xcode-select --print-path)"
echolog "# Homebrew: $(which brew)"
echolog "# Homebrew Version: $(brew --version)"
echolog "# R: $(which R)"
echolog "# R Version: $(R --version)"

echolog "### END INITIAL CONFIGURATION ###"

# PHP
# ----------------

# Install PHP

printf "\n# Installing PHP with imap support"
printf "\n# ----------------------\n"

sudo curl -s https://php-osx.liip.ch/install.sh | bash -s 7.1

# Check if PHP is correctly configured
export php_custom_path="/usr/local/php5/bin/php"
export php_custom_path_ini=$(${php_custom_path} -r "echo php_ini_loaded_file();")

echolog "# PHP: $php_custom_path"
echolog "# PHP .ini: $php_custom_path_ini"
${php_custom_path} -c ${php_custom_path_ini} -r "echo phpinfo();" 

printf "\n# SUCCESS - PHP successfully installed & configured"
printf "\n# ----------------------\n"

# R 
# ----------------

## Homebrew
printf "\n# Installing & Updating Homebrew (+ Command Line Tools)"
printf "\n# ----------------------\n"

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"</dev/null

## Confirm that the Command Line Tools are correctly confgured
echolog "# Homebrew Version: $(brew --version)"
echolog "# Xcode: $(xcode-select --print-path)"

## Homebrew reset
printf "brew_reset: $brew_reset\n"

if [ "$brew_reset" == "Yes" ]; then

	printf "Homebrew Rest\n"

	# initial status
	brew list
	brew doctor 

	# remove all packages installed through homebrew
	brew remove --force --ignore-dependencies $(brew list)

	# fix potential gcc problem
	brew install gcc
	brew link --overwrite gcc

fi

## Homebrew - update/clear up
brew cleanup
brew update
brew doctor

## R
printf "Installing R"
printf "\n# ----------------------\n"

## Uninstall
brew uninstall --force r
[ -e  /usr/local/lib/R/3.4/site-library ] && rm -rf /usr/local/lib/R/3.4/site-library/*
[ -e  /usr/local/Cellar/r/3.4.1_1/lib/R/library ] && rm -rf  /usr/local/Cellar/r/3.4.1_1/lib/R/library*
## Reinstall
brew prune 
brew tap homebrew/science && brew install r
brew link --overwrite r

# Check if R is correctly configured
echolog "R: $(which R)"
echolog "R Version: $(R --version)"

## R Packages
printf "Installing R Packages"
printf "\n# ----------------------\n"

cd ${wd_path}
R CMD BATCH --no-save "--args TRUE" \
${wd_path}/code/helper_code/R_init.R ${wd_path}/log/R_init.Rout

printf "\n# SUCCESS - R successfully installed & configured"
printf "\n# ----------------------\n"

