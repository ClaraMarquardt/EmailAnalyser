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

# ---------------------------------------
# external dependencies
# ---------------------------------------
package_list <-list("zoo","data.table","glmnet","text2vec","ggplot2")
load_or_install(package_names=package_list, custom_lib_path = lib_path)

# ---------------------------------------
# embedded dependencies
# ---------------------------------------

## theme_basic
theme_basic <-  function(axis_size=0.5, title_size=8, subtitle_size=6, 
                  font_gen ="URWHelvetica", col_gen="grey50")  
  theme_bw() +
  theme(
    axis.text.x = element_text(size=rel(axis_size), colour = col_gen,
      family=font_gen),
    axis.text.y = element_text(size=rel(axis_size), colour = col_gen,
      family=font_gen), 
    axis.title.x = element_text(size=rel(axis_size), colour = col_gen,
    family=font_gen),
      axis.title.y = element_text(size=rel(axis_size), colour = col_gen,
    family=font_gen),
    plot.title = element_text(size = title_size, colour = col_gen, face = "bold",
      family=font_gen),
    plot.subtitle = element_text(size = subtitle_size, colour = col_gen, 
      face = "plain",family=font_gen),
    plot.caption = element_text(size = (subtitle_size-1), colour = col_gen, 
      face = "plain",family=font_gen)
  )


## theme_legend_bottoms
theme_legend_bottom <- function(title_size=0.5, text_size=0.4, tick_size=0.08,
  legend_width=0.5, legend_height=0.2, hjust_title=0.5, font_gen ="URWHelvetica", 
  col_gen  ="grey50") 

  theme(
    legend.position="bottom", 
    legend.key.height=unit(legend_height,"cm"),
    legend.key.width=unit(legend_width,"cm"),
    axis.ticks.length=unit(tick_size,"cm"),
    legend.title=element_text(size=rel(title_size), colour=col_gen, family=font_gen, 
      hjust=hjust_title, face="plain"),
    legend.text=element_text(size=rel(text_size), colour=col_gen, family=font_gen))
  


