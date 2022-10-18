#!/usr/bin/env Rscript

library(rmarkdown)

args = commandArgs()

rmd_name = args[8]

rmd_args = args[9:length(args)]

rmarkdown::render(rmd_name,
                  params = list(args = rmd_args), 
                  output_format = 'html_document')
