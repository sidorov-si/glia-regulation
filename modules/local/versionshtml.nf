// This module uses code from https://github.com/nf-core/cutandrun/blob/master/workflows/cutandrun.nf
process VERSIONSHTML {
    label 'process_low'

    container 'quay.io/biocontainers/multiqc:1.12--pyhdfd78af_0'

    input:
    path versions

    output:
    path "software_versions.html", emit: versions_html

    script:
    """
    #!/usr/bin/env python

    import yaml
    import platform
    from textwrap import dedent

    def _make_versions_html(versions):
        html = [
            dedent(
                '''\\
                <style>
                #nf-core-versions tbody:nth-child(even) {
                    background-color: #f2f2f2;
                }
                </style>
                <table class="table" style="width:100%" id="nf-core-versions">
                    <thead>
                        <tr>
                            <th> Process Name </th>
                            <th> Software </th>
                            <th> Version  </th>
                        </tr>
                    </thead>
                '''
            )
        ]
        for process, tmp_versions in sorted(versions.items()):
            html.append("<tbody>")
            for i, (tool, version) in enumerate(sorted(tmp_versions.items())):
                html.append(
                    dedent(
                        f'''\\
                        <tr>
                            <td><samp>{process if (i == 0) else ''}</samp></td>
                            <td><samp>{tool}</samp></td>
                            <td><samp>{version}</samp></td>
                        </tr>
                        '''
                    )
                )
            html.append("</tbody>")
        html.append("</table>")
        return "\\n".join(html)

    with open("$versions") as f:
        workflow_versions = yaml.load(f, Loader=yaml.BaseLoader)
    
    workflow_versions["Workflow"] = {
        "Nextflow": "$workflow.nextflow.version",
        "$workflow.manifest.name": "$workflow.manifest.version"
    }

    with open("software_versions.html", 'w') as f:
        f.write(_make_versions_html(workflow_versions))
    """
}
