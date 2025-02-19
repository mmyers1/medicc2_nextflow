#!/usr/bin/env nextflow

params.catalog = 'test_cohort_inputs.csv'

medicc_inputs = Channel.fromPath(params.catalog) |
    splitCsv(header:true)

signals = medicc_inputs.map({row -> tuple(row.id, file(row.signals_filename, checkIfExists: true))})
segments = medicc_inputs.map({row -> tuple(row.id, file(row.segments_filename, checkIfExists: true))})
medicc_args = medicc_inputs.map({row -> tuple(row.id, row.medicc_args)})
allele_specific = medicc_inputs.map({row -> tuple(row.id, row.allele_specific)})
output_directory = medicc_inputs.map({row -> tuple(row.id, row.output_directory)})

include { MEDICC_SITKA } from './subworkflows/medicc_sitkasegs'

workflow {
    MEDICC_SITKA(signals, segments, medicc_args, allele_specific, output_directory)
}
