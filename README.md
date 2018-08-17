[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.1300847.svg)](https://doi.org/10.5281/zenodo.1300847)

# Vert Ramp Affirmation
Softare pipeline overview for Display Lab's Tailored Performance Feedback System.
![overview](doc/overview.svg)

This project serves as the overview of the parts of the feedback production pipeline.
It contains stubs and mock ups to illustrate components of the intervention pipeline.
Specifically, it has examples to demonstrate tailoring feedback for two recipients.

## Background
The Display Lab work is divided into two parts: User Centered Design and Feedback Production.
User Centered Design produces:
- Display Templates
- Performance Data Annotations
- Causal Pathways (Formerly Intervention Situation Relations)
- Ascribee Descriptions

Feedback Production consumes the above and produces:
- Appropriate Performance Feedback Displays

## Outline
The major steps of the intervention generation pipeline:
1. Data analsis for performance features
1. Performance feedback candidate generation
1. Reasoning about appropriateness of candidates 
1. Scoring and selection of candidates 
1. Generate performance summaries using appropriate candidates

## Definitions
- Display Template: Code to generate plot or figure.
- Ascribee: A person to which performance values are ascribed. 
- Annotations: Mathematical calculations to make assertions from performance data.
- Candidate: A mashup of the attributes of a template and an ascribee.  Created as a computational convenience.
- Causal Pathway: Computable representation of theory or domain expertise about what makes a performance display candidate appropriate.
- Spek: top level data container for templates, causal pathways, ascribees, and candidates.

## The Pipeline
### Data Analyzer ([Bit Stomach](https://github.com/Display-Lab/bit-stomach))
- Inputs:
    - Spek
    - Performance data
    - Performance data annotation functions
- Outputs:
    - Spek with additional ascribee annotations

### Candidate Generator ([Candidate Smasher](https://github.com/Display-Lab/candidate-smasher))
- Inputs:
    - Spek
    - Template metadata
- Outputs:
    - Spek with added candidates

### Reasoning Runner ([Think Pudding](https://github.com/Display-Lab/think-pudding))
- Inputs:
    - Spek
    - Causal pathways
- Outputs:
    - Spek with additional candidate annotations

### Candidate Scoring (Esteemer)
- Inputs:
    - Spek
    - Causal pathways
- Outputs:
    - Spek with additional candidate annotations

### Figure Generator (Pictoralist)
- Inputs:
    - Spek
    - Performance data
    - Template implementations
- Outputs:
    - Performance summary figures
