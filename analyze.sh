#!/bin/bash
Rscript -e "library(knitr); knit('exploration.Rmd')" > step1.Rout 2> errorFile1.Rout
