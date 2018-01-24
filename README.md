# Vert Ramp Affirmation

## Description
This project serves as the overview of the parts of the feedback summary pipeline.
It contains stubs and mock ups to illustrate components of the intervention pipeline.
Specifically, the examples here demonstrate tailoring feedback for two recipients.

## Outline
The steps (and associated projects) to the intervention generation pipeline:
1. Run data analyzer (bit-stomach)
1. Run candidate generator (candidate-smasher)
1. Run reasoner (think-pudding)
1. Generate performance summaries (relevant-fermenter)

## Background
This work is a result of the persuit of building a feedback intervention generating system.
The project here attempts to construct a skeleton of the pipeline that will consider the performance data,
situation information, intervention situations, and intervention templates in order to produce appropriate performance feedback.

## The Pipeline
### Data Analyzer
- Inputs:
    - Situation
    - Performance Data
    - Performance Data Analysis
- Outputs:
    - Situation Plus

### Candidate Generator
- Inputs:
    - Situation Plus
    - Templates
- Outputs:
    - Candidates

### Reasoning Runner
- Inputs:
    - Candidates
    - ISR
- Outputs:
    - Annotated Candidates

### Figure Generator
- Inputs:
    - Annotated Candidates
    - Performance Data
    - Templates Implementations
- Outputs:
    - Performance Summary Figures


## Example Data Description
The example data consists of five performers (a,b,c,d,e).
The first two, a & b, are used as the recipients of feedback.
Recipient 'a' has performance above the mastery threshold specified in the situation, and has decreasing recent performance.
Recipient 'b' has performance below the mastery level, and has increasing performance.

## Machinery Explanation

1. Data analyzer reads data & data annotation.  
It makes inferences about each performer. 
The result of these inferences are added to the situation.
    ```
    performer_a has_mastery
    performer_a has_decreasing_performance
    performer_b has_increasing_performance

    performer_c has_mastery
    ...
    ```
1. The candidate generator takes the situation and the performer specified as the recipient.
It creates intermediate constructs called candidate interventions by combining the situation with each intervention template.
1. The reasoner is loaded with the candidates and the intervention-situation-interaction.
The question posed to reasoner is essentially, "Which candidate interventions are acceptable interventions?"
From the linked data tripples that have been given, it will make inferences and return a result answering the question.
    ```
    candidate_one acceptable_candidate
    ```
1. The figure geenrator takes the candidates, and passes the relevant data along to the matching template implementations.

## Use

1. Pass Situation, Performance Data, and Data Analyzer to Bit Stomach 
2. Save & Examine resulting Situation Plus.



