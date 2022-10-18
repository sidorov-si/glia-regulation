include { FASTQC } from '../modules/nf-core/modules/fastqc/main.nf'
include { READ_NAMES } from '../modules/local/read_names.nf'
include { FASTQHEAD } from '../modules/local/fastqhead.nf'
include { BOWTIE2_ALIGN } from '../modules/nf-core/modules/bowtie2/align/main'
include { RMACHINE } from '../modules/local/rmachine.nf'
include { VERSIONSHTML } from '../modules/local/versionshtml.nf'

reads = [
    [
        [
            id: "testx",
            single_end: true
        ],
        "https://github.com/hartwigmedical/testdata/raw/master/100k_reads_hiseq/TESTX/TESTX_H7YRLADXX_S1_L001_R1_001.fastq.gz"
    ],
    [
        [
            id: "testy",
            single_end: true
        ],
        "https://github.com/hartwigmedical/testdata/raw/master/100k_reads_hiseq/TESTY/TESTY_H7YRLADXX_S1_L001_R1_001.fastq.gz"
    ]
]

Channel
    .from( reads )
    .map{ row -> [ row[0], file(row[1], checkIfExists: true) ] }
    .set{ ch_reads }

index_handler = file( "/Users/sidoros/nextflow-example/Bowtie2Index" )

// index_handler = file( params.genomes['GRCh38'].bowtie2 )
// Would take the Bowtie2 index of GRCh38 from the iGenomes project hosted at Amazon S3: s3://ngi-igenomes/igenomes/Homo_sapiens/NCBI/GRCh38/Sequence/Bowtie2Index

rmd_handler = file( "/Users/sidoros/nextflow-example/rmd/process_bowtie2_log.Rmd" )

workflow NF_EXAMPLE {

    FASTQC( ch_reads )

    READ_NAMES( ch_reads )

    FASTQHEAD( ch_reads, 1000 )

    BOWTIE2_ALIGN( FASTQHEAD.out.head_fastq.filter( ~/.*testx.*/ ),
                   index_handler,
                   false, 
                   true )

    //RMACHINE( BOWTIE2_ALIGN.out.log )

    RMACHINE( BOWTIE2_ALIGN.out.log, 
              rmd_handler )

    Channel
        .empty()
        .mix( FASTQC.out.versions )
        .mix( READ_NAMES.out.versions )
        .mix( FASTQHEAD.out.versions )
        .mix( BOWTIE2_ALIGN.out.versions )
        .mix( RMACHINE.out.versions )
        .set{ ch_versions }

    VERSIONSHTML( ch_versions.unique().collectFile() )

    // Channel
    //     .from( 1..200 )
    //     .randomSample( 20 )
    //     .view()

    // Channel
    //     .from( 1..10 )
    //     .map{ it * 2 }
    //     .view()

    // Channel
    //     .from( 1..10 )
    //     .reduce{ a, b -> a + b }
    //     .view()

    // Channel
    //     .from( 'aaa', 'aab', 'baa', 'aac', 'cac' )
    //     .count( ~/^aa.*/ )
    //     .view()

    // Channel
    //     .from( 'x_sample1.tsv', 'x_sample2.tsv', 'y_sample1.tsv' )
    //     .branch{
    //         x: it =~ /^x_.*/
    //         y: it =~ /^y_.*/
    //     }
    //     .set{ ch_samples }
    
    // ch_samples.x.view{ "x: $it" }
    // ch_samples.y.view{ "y: $it" }

}
