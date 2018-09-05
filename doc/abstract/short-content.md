# Tailoring Performance Feedback Using Semantic Technology

## Abstract
Here we describe a software pipeline that combines the results of user centered design and visual best practices with data processing and psychological theory to produce feedback tailored for each recipient.
The suite of modular applications we have crafted perform the data processing and semantic reasoning to select and generate tailored feedback figures for each recipient.
They are the complimentary computational process to the human centered processes that assess the recipient organization and set the parameters for tailoring feedback.

## Short Summary
The software begins by processing performance data to make inferences about each performer.
Inferred attributes, such as "positive gap" or "upward trend", are assigned to performers.
Each performer's attributes are considered in conjunction with psychological theory preconditions to determine the acceptability of potential feedback templates. 
The templates for each performer are further analyzed and scored to determine the ranking of feedback templates for each theory.

Feedback templates are used with the performance data to generate feedback figures for each performer.
The figures generated for each performer are presented to them for evaluation.
The performer scores each for acceptability and appropriateness.

The figure scoring by the performer provides the ground truth data with which to evaluate tailoring by each theory.
A theory that is good at tailoring has higher performer scores of the figures from templates identified as appropriate and high ranking.
A good theory has correspondingly high scores of figures it identified as appropriate and high ranking.

### Future Work
Using figures are proxies for the theories, the scoring informs a ranking of theories.
Inter-theory ranking models permit the selection of a single most appropriate performance feedback in subsequent iterations.
Sufficient replication accross many similar environments can lead to robust scoring model for comparing 
