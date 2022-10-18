process FASTQHEAD {
    tag "$meta.id"
    label 'process_low'

    container 'ubuntu:18.04'

    input:
    tuple val(meta), path(reads)
    val read_number

    output:
    tuple val(meta), path("*_head.fastq"), emit: head_fastq
    path "versions.yml"                  , emit: versions

    script:
    """
    gunzip -c -f ${reads} > temp.fastq

    head -\$((4*${read_number})) \\
        temp.fastq > \\
        ${meta.id}_head.fastq

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        Bash: \$(echo "\$BASH_VERSION")
        gunzip: \$(gunzip --version | head -1 | awk '{print \$3}')
    END_VERSIONS
    """
}
