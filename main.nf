#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

input_data = file( "input/input_data.tsv" )
    .splitCsv(header: ['dataset_name', 'dataset_path'], 
              skip: 1,
              sep: '\t')

input_data.view()
