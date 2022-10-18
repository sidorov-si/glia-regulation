#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

Channel 
    .fromPath( "input/input_data.tsv" )
    .splitCsv( header: ['dataset_name', 'dataset_path'], 
               skip: 1,
               sep: '\t' )
    .view()
    // .set { input_data_ch }

//input_data_ch.view()
