process SELECT_SAMPLES {
    tag '${condition_pair}'
    label 'process_low'

    container "debian:sid-slim"

    input:
    each path(all_feature_counts)
    val condition_pair

    output:
    path "*_${condition_pair[0]}_vs_${condition_pair[1]}.txt", emit: selected_feature_counts
    path "versions.yml", emit: versions

    script:
    """
    touch featureCounts_${condition_pair[0]}_vs_${condition_pair[1]}.txt

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        awk: 1.0
    END_VERSIONS
    """
}

// \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//' ))
