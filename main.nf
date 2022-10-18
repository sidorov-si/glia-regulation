#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { GLIA_ANALYSIS } from './workflows/glia_analysis.nf'

workflow {
    GLIA_ANALYSIS()
}
