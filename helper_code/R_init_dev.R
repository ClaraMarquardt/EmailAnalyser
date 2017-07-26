# R init

# ---------------------------------------
# external dependencies
# ---------------------------------------

## ehR - load or install function
load_or_install <- function(package_names, custom_lib_path=FALSE, 
  custom_path=NA, verbose=FALSE, local_package=FALSE, 
  local_package_path=NA) {  

  # obtain & save default path
  # -----------------------------
  print(sprintf("lib_path: %s", custom_lib_path))

  # install/load devtools
  # -----------------------------
  if (!("devtools" %in% installed.packages(lib.loc=custom_lib_path)[,"Package"])) {
    suppressMessages(install.packages("devtools",repos="http://cran.cnr.berkeley.edu/", 
      dependencies=TRUE, lib=custom_lib_path,INSTALL_opts = c('--no-lock')))
  }
  library(devtools)
  dev_mode(TRUE)

  # install (if required, i.e. not yet installed)  
  # -----------------------------
  lapply(package_names, function(x) if(!x %in% c(installed.packages(
       lib.loc=custom_lib_path)[,"Package"])) {
    
       print(sprintf("Fresh Install: %s", x))
    
       # install
       if (x=="data.table") {
    
         suppressMessages(withr::with_libpaths(new = custom_lib_path,
           install_version("data.table", version = "1.9.6",
           repos = "http://cran.us.r-project.org",
           dependencies=TRUE)))
    
       } else {
    
         suppressMessages(install.packages(x,repos="http://cran.cnr.berkeley.edu/", 
           dependencies=TRUE, lib=custom_lib_path))
    
      }

  })
 
  # load
  # -----------------------------
  packages_loaded <- lapply(package_names, function(x) {
    if (verbose==TRUE) {
      print(sprintf("Loading: %s", x))
    }

    suppressMessages(library(x,
        character.only=TRUE, quietly=TRUE,verbose=FALSE, 
        lib.loc=custom_lib_path))

  })

} 
 


  # load
  # -----------------------------
  packages_loaded <- lapply(package_names, function(x) {
    if (verbose==TRUE) {
      print(sprintf("Loading: %s", x))
    }

    suppressMessages(library(x,
        character.only=TRUE, quietly=TRUE,verbose=FALSE, 
        lib.loc=custom_lib_path))

  })

} 

# ---------------------------------------
# external dependencies
# ---------------------------------------
library(ehR)
package_list <-list("dplyr", "data.table","stringr","lubridate",
  "tidyr", "reshape", "reshape2","zoo","caret","text2vec","glmnet","tidyverse","ggplot2")
load_or_install(package_names=package_list, custom_lib_path = lib_path)



