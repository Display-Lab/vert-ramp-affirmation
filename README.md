# Vert Ramp Affirmation

## Background
The Display Lab work is divided into two parts: User Centered Design and Feedback Production.
User Centered Design produces:
- Display Templates
- Performance Data Annotations
- ISRs (Intervention Situation Relations)
- Performers

Feedback Production consumes the above and produces:
- Appropriate Performance Feedback Displays

## Description
This project serves as the overview of the parts of the feedback production pipeline.
It contains stubs and mock ups to illustrate components of the intervention pipeline.
Specifically, it has examples to demonstrate tailoring feedback for two recipients.

## Outline
The steps (and associated projects) to the intervention generation pipeline:
1. Data analsis for performance features
1. Performance feedback candidate generation
1. Reasoning about appropriateness of candidates 
1. Generate performance summaries using appropriate candidates

## Definitions
- Display Template: Code to generate plot or figure.
- Annotations: Mathematical calculations to make assertions from performance data.
- ISR: Computable representation of theory or domain expertise about what makes a performance display candidate appropriate.
- Spek: top level data container for list of templates, list of ISRs, list of performers.

## The Pipeline
### Data Analyzer (Bit Stomach)
- Inputs:
    - Spek
    - Performance Data
    - Performance Data Analysis
- Outputs:
    - Spek plus additional annotations

### Candidate Generator (Candidate Smasher)
- Inputs:
    - Spek Plus
    - Templates
- Outputs:
    - Candidates

### Reasoning Runner (Think Pudding)
- Inputs:
    - Candidates
    - ISRs
- Outputs:
    - Annotated Candidates

### Figure Generator (Relevant Fermenter)
- Inputs:
    - Annotated Candidates
    - Performance Data
    - Templates
- Outputs:
    - Performance Summary Figures

## Examples
- [example one](ex_one.md)
