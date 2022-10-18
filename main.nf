#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

//include { SELECT_SAMPLES } from '../modules/local/select_samples.nf'

params.samples_tsv = "input/input_data.tsv"

Channel 
    .fromPath( params.samples_tsv )
    .splitCsv( header: true, sep: '\t' )
    .set { input_data_ch }

Channel
    .empty()
    .mix( input_data_ch
              .filter { it.dataset_name == "consensus_element_counts" }
              .map { it -> file( it.dataset_path ) } )
    .view()
//consensus_element_counts_ch = 

// workflow GLIA_ANALYSIS {

//     SELECT_SAMPLES(  )
// }