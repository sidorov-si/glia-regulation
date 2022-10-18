#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { NF_EXAMPLE } from './workflows/example_wf.nf'

workflow {
    NF_EXAMPLE()
}
