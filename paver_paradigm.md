# Paver Paradigm

Change from candidates to pavers to better model the eventual messages being generated and delivered to people.
Pavers focus on the dispositions of a performer.
In contrast to the candidates of the previous modeliing, do not require concatenation with template metadata.
Instead templates support a paver in a similar fashion to how causal pathways approve a paver.
This main difference is a one-to-many mapping between a paver and the templates that support it.

This puts more importance on esteemer's mechanism of scoring.
It must now score two things:

  - Pavers
  - Templates supporting a paver.

In essence, this means esteemer has to choose the paver AND the template that should render it.

## Paver
The annotations about a performer-measure-comparator.
E.g. What can be said about Bob's performance of documentation rate compared to the goal documentation rate.
```json
{
  "@type": "slowmo#paver",
  "@id": "_:paver1",
  "slowmo:ancestorPerformer": "Bob",
  "ro:hasDisposition": [
    {"@type": "psdo#positiveGap"},
    {"@type": "psdo#positiveTrend"},
    {"@type": "cpo#goalComparator"}
  ],
  "slowmo:regardingMeasure": "documentationRate",
  "slowmo:regardingComparator": "goal"
}
```

### Causal Pathway Acceptance.
The criteria of a causal pathway is a list under hasPrecondition.
This will be matched (by thinkpudding) against the hasDisposition list of a paver.
```json
{
  "@type": "cpo#causalPathway",
  "@id": "slowmo#goalAchievement",
  "slowmo:hasPrecondition": [
    {"@type": "psdo#positiveGap"},
    {"@type": "cpo#goalComparator"}
  ]
}
```

If a paver has all the dispositions required by the preconditions, then the paver gets marked as accepted by the causal pathway:

```json
  "AcceptedBy": [{"@id": "slowmo#goalAchievement"}]
```

### Figure Template Support
The matching criteria of a figure template is listed in supportedDispositions:
```json
{
  "@type": "slowmo#figureTemplate",
  "@id": "slowmo#horizontalBar",
  "slowmo:supportedDispositions": [
    {"@type": "psdo#positive_gap"},
    {"@type": "psdo#negative_gap"},
    {"@type": "cpo#goal_comparator"},
    {"@type": "cpo#social_comparator"}
  ]
}
```
Supported dispositions are those that the figure template can possibly support.
A template can be said to support a paver if the performance dispositions of the paver are all incluced in those supported.
This leads to a problem stuffing non-performance dispositions into pavers.  E.g. role when it's included in performance data.
Might need to make a separate bitstomach and spek accomodation to process non-performance dispositions out of performance data.
If a figure template supports all of the dispositions of a paver, then the paver gets marked as supported by the figure template:

```json
  "SupportedBy": [{"@id": "slowmo#horizontalBar"}]
```

## Patio

Collecting the information about a performer for a single measure is the patio construct.
This aggregation collects pavers that are about the same measure, but different comparators.

The following example collects two pavers, \_:pv1 and \_:pv2, which are about the goal comparator and social comparator respectively.
Both pavers in this example annotate postive gaps with regard to their comparator.

As a computational convenience, all the causal pathways that accept at least one of the pavers is listed under CausalPathwayAcceptances.
Do the number of accepts for a causal pathway matter?  I.e. the number of comparators about which a causal pathway is true.

```json
{
  "@type": "slowmo#patio",
  "@id": "_:patio1",
  "slowmo:causalPathwayAcceptance": [
    {"@id": "slowmo#goalAchievement"},
    {"@id": "slowmo#benchAchievement"}
  ],
  "slowmo:ConstituentPavers": [ {"@id": "_:paver1"}, {"@id": "_:paver2"} ]
}
```

### Message Compatibility
A patio is compatible with a message iff the causalPathwayAcceptance includes all of the required causal pathways of a message template.

E.g. a message designed for the BenchAchievement causal pathway
```json
{
  "@type": "slowmo#messageTemplate",
  "@id": "slowmo#betterThanAverageBear",
  "slowmo:requiredPathwayAcceptances": [
    {"@id": "slowmo#benchAchievement"}
  ]
}
```
If the patio has all the required causalPathwayAcceptance then the patio gets marked as compatible with the message.

```json
{
  "CompatibleWith": [{"@id": "slowmo#betterThanAverageBear"}]
}
```

### Which message to choose?
A collection of all the information about a single performer and measure (patio) may indicate that there are more than one messages that could be sent to the performer about that measure.
When there are mulitiple compatible messages for a patio which message to choose?
A precendence of message templates or a scoring method is needed.

### Multiple Messages with Unaligned Causal Pathways
The question is, "There is a performer, a measure, and multiple messages that could be sent to that performer about the measure.  Which should be sent?"

When there is more than one comparator for a measure, each performer will generate multiple pavers regarding that measure.  
This can be a problem because they may have causal pathways that are perfectly aligned.  E.g. a positive gap with a goal and negative gap with social benchmark.

The patio would look like:
```json
{
  "@type": "slowmo#patio",
  "@id": "_:patio1",
  "slowmo:causalPathwayAcceptance": [
    {"@id": "slowmo#goalAchievement"},
    {"@id": "slowmo#benchDiff"}
  ],
  "slowmo:ConstituentPavers": [ {"@id": "_:paver3"}, {"@id": "_:paver4"} ]
}
```

Given the existence of a message template for each causal pathway, both will be compatible with the patio.
```json
{
  "@id": "slowmo#belowSocialComparison",
  "@type": "slowmo#messageTemplate",
  "slowmo:requiredPathwayAcceptances": [ {"@id": "slowmo#benchDiff"} ]
},
{
  "@id": "slowmo#goalAchiever",
  "@type": "slowmo#messageTemplate",
  "slowmo:requiredPathwayAcceptances": [ {"@id": "slowmo#benchAchievement"} ]
}
```
What information is needed to choose between these two? [All together example spek](paver_example.json).

Additionally, there could be a message template specifically authored to handle the situation of this combination of causal pathways.  
In this case, there would be a three way choice the selection method needs to resolve. 
Does the addition of a combination message template change the information needed to resolve the choice?
```json
{
  "@type": "slowmo#messageTemplate",
  "@id": "slowmo#goodEnough",
  "slowmo:requiredPathwayAcceptances": [ 
    {"@id": "slowmo#goalAchievement"},
    {"@id": "slowmo#benchDiff"},
  ]
}
```

## Choosing between Measures
The question is, "There is a performer with a compatible message for each of three measures, and the constraint is only one message can be sent.  Which message should be sent?"

What information is needed to answer this?

## Choosing the figure template to render for the message.
Assume there were multiple measures each with the same comparator for simplicity.
(Handling multiple comparator figure templates is going to be a pain in the ass, but doable.)
The most important single measure has been selected.
That patio is contains a single a paver.  
Single performer, measure, comparator.
The problem is there are a half dozen figure templates that support it, becaue it's dispositions is `positive_gap`.
There are many ways to display `positive_gap`, how do we choose which one?
What information is require to choose?

