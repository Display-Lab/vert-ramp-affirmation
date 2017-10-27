# Vert Ramp Affirmation

## Description
Code and stubs to provide minimal or mock implementations of the components of the intervention pipeline.
Demonstration of tailoring feedback for two recipients.

## Use
1. Run data analyzer
1. Run candidate generator
1. Run reasoner
1. Generate interventions (performance summaries)

### Explanation

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

## Background
This work is a result of the persuit of building a feedback intervention generating system.
The project here attempts to construct a skeleton of the pipeline that will consider the performance data,
situation information, intervention situations, and intervention templates in order to produce appropriate performance feedback.
The minimal list of components that need to be stubbed or realized in order to construct the pipeline are listed in the section of the same name.

## Components

- Performance Data
- Situation Information
- Performance Data Analyzer
- Intervention Templates 
- Intervention-Situation-Interaction (ISI)
- Candidate Generator
- Reasoner (Stardog)

| Input                                              | Machinery             | Product                          |
|----------------------------------------------------|-----------------------|----------------------------------|
| Perf. Data, Situation Information                  | Perf. Analyzer        | Situation Plus,  template config |
| Situation Plus, Intervention Templates             | Candidate Generator   | Intervention Candidates          |
| Intervention Candidates, ISI List                  | Reasoner              | Acceptable Candidates            |
| Perf. Data, Acceptable Candidates, template config | Perf. Summary Builder | Performance Summaries            |


## Example Data Description
The example data consists of five performers (a,b,c,d,e).
The first two, a & b, are used as the recipients of feedback.
Recipient 'a' has performance above the mastery threshold specified in the situation, and has decreasing recent performance.
Recipient 'b' has performance below the mastery level, and has increasing performance.

