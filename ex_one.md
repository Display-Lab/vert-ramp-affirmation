# Example One

## Description

## Components
### ISR

### Template

### Peformers

### Use Case Statement

### Performance Data

IN_PROGRESS

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



