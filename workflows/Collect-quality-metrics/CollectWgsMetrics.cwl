#!/usr/bin/env cwl-runner

class: CommandLineTool
baseCommand: java
cwlVersion: v1.0

doc: CollectWgsMetrics cwl version. Created during CollaborationFest 2019.

requirements:
  InlineJavascriptRequirement: {}
  DockerRequirement:
    dockerPull: us.gcr.io/broad-gotc-prod/genomes-in-the-cloud:2.3.2-1510681135
  ResourceRequirement:
    ramMin: 3072
    coresMin: 3
    tmpdirMin: $(Math.ceil((inputs.ref_fasta.size 
                            + inputs.ref_fasta_index.size
                            + inputs.input_bam.size) / 1000000000) + 20)
    outdirMin: $(Math.ceil((inputs.ref_fasta.size 
                            + inputs.ref_fasta_index.size
                            + inputs.input_bam.size) / 1000000000) + 20)

arguments:
  - position: 0
    valueFrom: -Xms2000m
  - position: 1
    prefix: -jar
    valueFrom: /usr/gitc/picard.jar
  - position: 2
    valueFrom: CollectWgsMetrics
  - position: 4
    valueFrom: VALIDATION_STRINGENCY=SILENT
  - position: 6
    valueFrom: INCLUDE_BQ_HISTOGRAM=true
  - position: 9
    valueFrom: USE_FAST_ALGORITHM=true

inputs:
  input_bam:
    type: File
    inputBinding:
      position: 3
      prefix: INPUT=
      separate: false
  ref_fasta:
    type: File
    inputBinding:
      position: 5
      prefix: REFERENCE_SEQUENCE=
      separate: false
  wgs_coverage_interval_list:
    type: File
    inputBinding:
      position: 7
      prefix: INTERVALS=
      separate: false
  metrics_filename:
    type: string
    inputBinding:
      position: 8
      prefix: OUTPUT=
      separate: false
  read_length:
    type: int
    inputBinding:
      position: 10
      prefix: READ_LENGTH=
      separate: false
  ref_fasta_index:
    type: File
  
outputs:
  metrics:
    type: File
    outputBinding:
      glob: $(inputs.metrics_filename)
