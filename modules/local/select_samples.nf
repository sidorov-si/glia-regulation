process SELECT_SAMPLES {
    tag "${condition_pair}"
    label 'process_low'
    debug true

    container "ubuntu:22.04"

    input:
    each path(all_feature_counts)
    val condition_pair

    output:
    //path "*_${condition_pair[0]}_vs_${condition_pair[1]}.tsv", emit: selected_feature_counts
    //path "versions.yml", emit: versions

    script:
    """
    #collist=\$(<${all_feature_counts} \
    #    tail -n +2 | \
    #    head -1)

    <${all_feature_counts} \
        tail -n +2 | \
        head -1

    #echo \${collist} "\\n"


    """
}

//  | \
//         head -1 | \
//         tr '\\t' '\\n' | \
//         grep -nE '${condition_pair[0]}|${condition_pair[1]}' | \
//         cut -d\$':' -f1)

// \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//' ))

    // <${all_feature_counts} \
    //     tail -n +2 | \
    //     awk -F"\\t" \
    //         -v selected_cols="\${collist}" \
    //         'BEGIN { OFS = "\\t" }
    //          { printf \$1, \$2, \$3, \$4, \$5, \$6 "\\t"; \
    //            split(selected_cols, selected_cols_array, " "); \
    //            for (i = 1; i <= length(selected_cols_array); ++i) { \
    //                printf \$selected_cols_array[i] "\\t" \
    //            }; \
    //            printf "\\n" \
    //          }' > \
    //     featureCounts_${condition_pair[0]}_vs_${condition_pair[1]}.tsv

    // cat <<-END_VERSIONS > versions.yml
    // "${task.process}":
    //     awk: \$(awk -V)
    // END_VERSIONS