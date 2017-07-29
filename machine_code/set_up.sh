# WD
wd_path=$(pwd)
echo ${wd_path}

## PHP
## ----------------

# Install PHP

printf "\n# Installing PHP with imap support"
printf "\n# ----------------------\n"

sudo curl -s https://php-osx.liip.ch/install.sh | bash -s 7.1

# Check if PHP is correctly configured
export php_custom_path="/usr/local/php5/bin/php"
export php_custom_path_ini=$(${php_custom_path} -r "echo php_ini_loaded_file();")

echo $php_custom_path
echo $php_custom_path_ini
${php_custom_path} -c ${php_custom_path_ini} -r "echo phpinfo();" 

printf "\n# SUCCESS - PHP successfully installed & configured"
printf "\n# ----------------------\n"

## R 
## ----------------

## Homebrew
if ! [ -x "$(command -v brew)" ]; then
	printf "\n# Installing & Updating Homebrew"
	printf "\n# ----------------------\n"

	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"</dev/null
fi

brew cleanup
brew update

## R
printf "Installing R"
printf "\n# ----------------------\n"

brew uninstall --force r
brew prune 
brew tap homebrew/science && brew install r 
brew link --overwrite r

# Check if R is correctly configured
echo $(which R)
echo $(R --version)

## R Packages
printf "Installing R Packages"
printf "\n# ----------------------\n"

cd ${wd_path}
R CMD BATCH --no-save "--args TRUE" \
${wd_path}/code/helper_code/R_init.R ${wd_path}/code/helper_code/R_init.Rout

printf "\n# SUCCESS - R successfully installed & configured"
printf "\n# ----------------------\n"

