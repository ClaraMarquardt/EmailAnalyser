# R dependencies

# ---------------------------------------
# external dependencies - functions
# ---------------------------------------

## ehR - load or install function
load_or_install <- function(package_names, verbose=FALSE, upgrade=FALSE) {  

  # obtain & save default path
  # -----------------------------
  print(.libPaths())

  # upgrade packages
  # -----------------------------
  if (upgrade==TRUE) {

    print("Updating Packages")

    tryCatch({update.packages(ask = FALSE, repos = "https://cran.rstudio.com", 
      checkBuilt = TRUE, type="source")}, error=function(e) {print("Package update failed")})
  
  }


  # install (if required, i.e. not yet installed)  
  # -----------------------------
  lapply(package_names, function(x) if(!x %in% c(
      installed.packages()[,"Package"])) {
    
       print(sprintf("Fresh Install: %s", x))
    
       suppressMessages(install.packages(x,
        repos="https://cran.rstudio.com", 
        type="source"))

  })
 
  # load
  # -----------------------------
  packages_loaded <- lapply(package_names, function(x) {
    if (verbose==TRUE) {
      print(sprintf("Loading: %s", x))
    }

    suppressMessages(library(x,
        character.only=TRUE, quietly=TRUE,verbose=FALSE))

  })

} 

# ---------------------------------------
# external dependencies - execute
# ---------------------------------------
package_list <-list("dplyr", "data.table","stringr","lubridate",
  "tidyr", "reshape", "reshape2","zoo","caret","text2vec","glmnet","tidyverse","ggplot2")
load_or_install(package_names=package_list, upgrade=FALSE)

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
  

