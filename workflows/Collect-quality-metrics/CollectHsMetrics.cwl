#!/usr/bin/env cwl-runner

class: CommandLineTool
baseCommand: java
cwlVersion: v1.0

doc: CollectHsMetrics cwl version. Created during CollaborationFest 2019.

requirements:
  InlineJavascriptRequirement: {}
  DockerRequirement:
    dockerPull: us.gcr.io/broad-gotc-prod/genomes-in-the-cloud:2.4.1-1540490856
  ResourceRequirement:
    ramMin: 10240
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
    valueFrom: CollectHsMetrics
  - position: 5
    valueFrom: VALIDATION_STRINGENCY=SILENT
  - position: 8
    valueFrom: METRIC_ACCUMULATION_LEVEL=null
  - position: 9
    valueFrom: METRIC_ACCUMULATION_LEVEL=SAMPLE
  - position: 10
    valueFrom: METRIC_ACCUMULATION_LEVEL=LIBRARY

inputs:
# TODO add bai as secondary input file
  input_bam:
    type: File
    inputBinding:
      position: 3
      prefix: INPUT=
      separate: false
  ref_fasta:
    type: File
    inputBinding:
      position: 4
      prefix: REFERENCE_SEQUENCE=
      separate: false
    secondaryFiles:
    - .fai
  target_interval_list:
    type: File
    inputBinding:
      position: 6
      prefix: TARGET_INTERVALS=
      separate: false
  bait_interval_list:
    type: File
    inputBinding:
      position: 7
      prefix: BAIT_INTERVALS=
  metrics_filename:
    type: string
    inputBinding:
      position: 11
      prefix: OUTPUT=
      separate: false
  ref_fasta_index:
    type: File

outputs:
  metrics:
    type: File
    outputBinding:
      glob: $(inputs.metrics_filename)
