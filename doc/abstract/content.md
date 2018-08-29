# Message Tailoring Software Pipeline
## Background
Giving people appropriate performance feedback is desired for medical professionals.

The fields of psychology and implementation science offer evidence and theory about acceptable and appropriate performance feedback.

A single performance feedback template may not be appropriate for all recipients.

User centered designe processes collect relevant details about organizations and feedback recipients.

Visual design best practices inform the creation of attractive and consistent figures.

## Problem
Here we describe a software pipeline that combines the results of user centered design and visual best practices with data processing and psychological theory to produce feedback tailored for each recipient.

## Process Overview
The suite of modular applications we have crafted perform the data processing and semantic reasoning to select and subsequently generate a tailored feedback figure for each recipient.

They are the complimentary computational process to the human centered processes that assess the recipient organization and set the parameters for tailoring feedback.

## Process Detail
_TODO: you are here_

The software pipeline begins with the outputs of user centered design processes;  
a succinct representation of the applicatble psychological theory, figure templates, and relevant information about the feedback recipients.

The first computational step is the processing of the performance data data to make inferences about the attributes of each performer.
This is done via annotation functions that were written to implement the environment specific interpretations of attributes.
Each annotation function determines if a performer has a specific attribute.
e.g. a positive gap is performance 10 percent above average or an upward trend is performance increasing by at least .5 over three consecutive time points.
Data is subset by recipient identifier and passed into each of the annotation functions.
The result is the set of recipients with performance data derived attributes.

This directly feeds into creating feedback candidates by combining the attributes of performers with the attributes of feedback templates.
Template attributes, unlike performer attributes, are known before runtime.
They describe the nature and capability of the feedback template.
For instance, a template that can display performance from multiple performers would have a peer comparison attribute.
Concatenating the attributes from a performer and a template to produce a feedback candidate provides a computational and conceptual convenience.
It puts all the attributes that a psychological theory will operate on in a single container.
The result of combining each recipient with each template yields the cartesian product of the sets.

Subsequently, each candidate is evaluated using the preconditions of each psychological theory to annotate which theories indicate a candiate is acceptable.
Each theory has precoditions that are required to be true in order for the theory to be applicable.
For instance, a theory indicating that peer comparison is more acceptable when there is an upward trend in performance requires has both peer comparison and upward performance trend as preconditions.
A candidate that meets the preconditions for a theory is annotated as acceptable by that theory.
The result of this operation is the set of candidates that have attributes about which theories indicate the candidate is acceptable.

In a similar fashion to applying preconditions, the moderators of each psychological theory are evaluated with each candiate to generate intra-theory scores that allow the selection of the highest scoring candidate for each theory.
A theory may have zero or more moderators that indicate scoring beyond the boolean criteria of the precoditions.
Multiple theories may have the same moderator, but the value attached to the moderator is different for each theory.
For example, a theory may indicate that peer comparison is acceptable and have a moderator that scores positive gap as a 3 while scoring negative gap as a 1.
Thus, an acceptable feedback candidate that has a positive gap will be scored higher than on with a negative gap.
These intra-theory scores are scoped only to the theory where they are defined, and may not be used to compare between theories.
The result of moderator scoring is the set of acceptable candidates with values that permit selecting the highest scoring candidate for each theory.

The terminus of the pipeline is generating the figures indicated by the top scoring candidate for each theory.
Each feedback candidate has a property with the identifier of the the recient and template from which it was created.
The functional code to generate a figure is retrieved using the template identifier, and it is passed the recipient's performance data.
This process generates the figures for each of the recipients.

These figures can then be presented to their recipients to be evaluated for acceptability and appropriateness.
The acceptability and appropriateness of each figure can be attributed back to the theory that selected for generating the figure.
In this way, the figures are proxies for the theories and the relative value of each can be approximated for the environment.
Sufficient replication accross many similar environments can lead to an inter-theory scoring model that would permit the selection of a single most appropriate performance feedback for individual recipients.



