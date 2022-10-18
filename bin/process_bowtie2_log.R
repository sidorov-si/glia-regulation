#!/usr/bin/env Rscript

library(dplyr)
library(ggplot2)

args = commandArgs()

input.name = args[8]
output.name = paste0(sub('\\.tsv', '', input.name), "_processed.tsv")

tsv.dir = "tsv"
dir.create(file.path(".", tsv.dir))

pdf.dir = "pdf"
dir.create(file.path(".", pdf.dir))

df = read.table(file = input.name,
                sep = "\t",
                quote = "\"",
                header = F)

names(df) = c("number", "percentage", "category")

write.table(df %>% dplyr::select(category, number, percentage),
            file = file.path(tsv.dir, output.name),
            sep = "\t",
            quote = F,
            row.names = F)

p = df %>% 
    dplyr::filter(!is.na(percentage)) %>%
    ggplot() +
        geom_col(aes(x = category,
                     y = percentage,
                     fill = category)) +
        theme_classic() + 
        theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5))

ggsave(filename = file.path("pdf", "bowtie2_log_barplot.pdf"),
       plot = p)
