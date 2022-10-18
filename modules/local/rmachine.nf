process RMACHINE {
    tag "$meta.id"
    label 'process_low'
    stageInMode 'copy'

    container 'sviatsidorov/r_machine:1.0'

    input:
    tuple val(meta), path(bowtie2_log)
    path rmd

    output:
    tuple val(meta), path("tsv")   , emit: tsv_dir
    tuple val(meta), path("pdf")   , emit: pdf_dir
    tuple val(meta), path("*.html"), emit: knitted_html
    path "versions.yml"            , emit: versions

    script:
    """
    { <${bowtie2_log} \\
        head -1 | \\
        awk '{printf \$1}'; \\
        echo -ne "\\t\\t"; \\
        echo "all reads"; } > \\
    bowtie2_table.tsv

    { <${bowtie2_log} \\
        head -5 | \\
        tail -4 | \\
        sed 's/^ *//g' | \\
        sed 's/ /\\t/1' | \\
        sed 's/ /\\t/1' | \\
        tr -d '()%' | \\
        sed 's/were //g' | \\
        sed 's/; of these://g'; \\
        echo -ne "\\t"; } >> \\
    bowtie2_table.tsv

    { <${bowtie2_log} \\
        tail -1 | \\
        tr -d '%' | \\
        awk '{printf \$1 "\\t"}'; \\
        echo "overall alignment rate"; } >> \\
    bowtie2_table.tsv

    # process_bowtie2_log.R bowtie2_table.tsv

    render_rmd.R $rmd bowtie2_table.tsv

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        Bash: \$(echo "\$BASH_VERSION")
        R: \$(R --version | head -1 | awk '{print \$3}')
        R_dplyr: \$(Rscript -e 'packageVersion("dplyr")' | awk '{print \$2}' | tr -d "‘’")
        R_ggplot2: \$(Rscript -e 'packageVersion("ggplot2")' | awk '{print \$2}' | tr -d "‘’")
    END_VERSIONS
    """
}
