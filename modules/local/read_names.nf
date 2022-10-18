process READ_NAMES {
    tag "$meta.id"
    label 'process_low'

    container 'quay.io/biocontainers/python:3.8--1'

    input:
    tuple val(meta), path(reads)

    output:
    tuple val(meta), path("*_read_names.txt"), emit: read_names
    path "versions.yml"                      , emit: versions

    script:
    """
    get_read_names.py $reads > ${meta.id}_read_names.txt

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        Python: \$(python --version | awk '{print \$2}') 
    END_VERSIONS
    """
}
