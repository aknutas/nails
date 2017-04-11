#!/bin/bash
Rscript -e "library(knitr); require(markdown); markdownToHTML('exploration.md', 'exploration.html');" > step2.Rout 2> errorFile2.Rout
