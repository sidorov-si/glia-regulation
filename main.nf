#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

params.samples_tsv = "input/input_data.tsv"

Channel 
    .fromPath( params.samples_tsv )
    .splitCsv( header: true, sep: '\t' )
    .set { input_data_ch }

input_data_ch
    .filter { it[0] == "consensus_element_counts" }
            //  .map { it -> it[1] }
             .view()

// Channel
//     .fromPath(  )
//     .view()
