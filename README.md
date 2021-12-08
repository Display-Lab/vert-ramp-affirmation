[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.1300847.svg)](https://doi.org/10.5281/zenodo.1300847)

# Precision Feedback Service
Software pipeline overview for Display Lab's Precision Feedback Service.
![overview](doc/overview.svg)

This project serves as the overview of the parts of the Precision Feedback Service.
It contains stubs and mock ups to illustrate components of the software pipeline.
Specifically, it has examples to demonstrate production of feedback messages for multiple recipients.

## Background
The software pipeline operates on two kinds of inputs: performance data and feedback intervention knowledge.
Performance data contains performance levels (typically as a ratio or percentage) for a specified metrics, recipients, and time intervals. It may also contain comparison data, such as goals or benchmarks.
Feedback intervention knowledge is specified in the form of 1) a Precision Feedback Knowledgebase, and 2) recipient requirements and preferences.

The Precision Feedback Knowledgebase is developed by Display Lab, and has the following kinds of knowledge:
- Performance data annotation functions
- Feedback message templates (for email and dashboard content)
- Causal pathway models
- Ontologies for feedback interventions

Recipient requirements and preferences are developed via a human-centered design process and specified as follows:
- Requirements: User stories are written in natural language and then translated to a computer-interpretable specification written in JSON
- Preferences: A preference elicitiation survey is used to generate utilities (i.e. preference weights) for attributes of feedback interventions

The Precision Feedback Service consumes the above and produces the following output:
- Appropriate feedback messages for each recipient in the most recent time interval

## Outline
The major steps of the software pipeline:
1. Analyze performance data by annotating all observable comparisons and trends  
1. Generate all possible (candidate) feedback messages using annotations and feedback message templates
1. Reason about the appropriateness of candidates using causal pathways
1. Score and select candidates for generation of visual displays and message text
1. Generate visual displays and message text for email and dashboard content

## Definitions
Many terms used are defined in the [Performance Summary Display Ontology (PSDO)](https://github.com/Display-Lab/psdo) and [Causal Pathway Ontology (CPO)](https://github.com/Display-Lab/cpo), developed by Display Lab. Each ontology has a published dictionary ([PSDO Dictionary](https://github.com/Display-Lab/psdo/blob/master/DICTIONARY.md), [CPO Dictionary](https://github.com/Display-Lab/cpo/blob/master/DICTIONARY.md)). PSDO is also available via [BioPortal](https://bioportal.bioontology.org/ontologies/PSDO).
Major components of the Precision Feedback Knowledgebase and the Precision Feedback Service are defined as follows:
- Feedback message template: A collection of metadata that specifies information content for an email message, including text and code to generate charts/figures.
- Recipient: An individual, team, or organization to whom a performance feedback message is sent. 
- Performance data annotation: Mathematical calculations to make assertions about comparisons and trends in performance data.
- Candidate message: A mashup of the attributes of a message template and a recipient's performance comparisons and trends. Created as a computational convenience.
- Causal pathway model: A theory-based specification of the influence process of a feedback message. It has as its parts preconditions, mechanisms, moderators, and outcomes.
- Spek: A top-level data container for metadata, including feedback message templates, causal pathways, recipient requirements and preferences, and candidate messages.
- Ascribee: An entity to which a performance level is ascribed, such as a person, team, goal, peer average, or benchmark. The ascribee's performance level is specified for a given metric and time interval.

## The Software Pipeline

For a more detailed explanation and example, see: [pipeline example](pipeline_example.md)

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
    - Feedback message template metadata
- Outputs:
    - Spek with added candidates

### Reasoning Runner ([Think Pudding](https://github.com/Display-Lab/think-pudding))
- Inputs:
    - Spek
    - Causal pathways
- Outputs:
    - Spek with additional candidate annotations

### Candidate Scoring ([Esteemer](https://github.com/Display-Lab/esteemer))
- Inputs:
    - Spek
    - Causal pathways
- Outputs:
    - Spek with additional candidate annotations

### Figure Generator ([Pictoralist](https://github.com/Display-Lab/pictoralist))
- Inputs:
    - Spek
    - Performance data
    - Feedback message template implementations
- Outputs:
    - Performance summary messages


## Installing Dependencies on OSX
- [OSX installation instructions](./OSX_Install.md)
- [Ubuntu installation instructions](./Ubuntu_Install.md)

