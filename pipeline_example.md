# Pipeline Walkthrough

1. User Centered Design
1. Data Aquisition & Munging
1. BitStomach
1. CandidateSmasher
1. Think Pudding
1. Esteemer
1. Pictoralist

## User Centered Design
The entire human facing half of the production pipeline.
Talking to people for contextual inquiry.
Not applicable in this fully synthetic example.

## Data Aquisition & Munging
Recieve or pull data from client.
Preprocessing data to get into expected formats (csv, json).
Eschewed in this fully synthetic example.

## BitStomach

### Input
- Spek describes the performers
- Performance data has values for the behavior measure
- Annotations encode how the performance data will be processed

Performers section of spek:
```json
  "slowmo:has_performer": [
    {
      "@id": "http://example.com/app#Alice",
      "@type": "http://example.com/slowmo#ascribee"
    },
    {
      "@id": "http://example.com/app#Bob",
      "@type": "http://example.com/slowmo#ascribee"
    }],

```

### Output: Add Performcer Dispositions to Spek
The performers get annotated using performance data.
http://purl.obolibrary.org/obo/RO\_0000091 is "has disposition" 
Below is the performers section of the spek.

Added dispositions such as negative\_gap to Alice:
```json
  "slowmo:has_performer": [
      {
        "@id": "http://example.com/app#Alice",
        "@type": "http://example.com/slowmo#ascribee",
```
```json
        "http://purl.obolibrary.org/obo/RO_0000091": [
            { "@value": "mastery_unknown" },
            { "@value": "negative_gap" },
            { "@value": "negative_trend" },
            { "@value": "small_gap" }
        ]
```
Added dispositions to performer, Bob:
```json
      },
      {
          "@id": "http://example.com/app#Bob",
          "@type": "http://example.com/slowmo#ascribee",
```
```json
          "http://purl.obolibrary.org/obo/RO_0000091": [
              { "@value": "mastery_present" },
              { "@value": "positive_trend" }
          ]
```

A performcer, Carol, has been added to the performers in the spek.
Carol was in the performance data, but not in the input spek.
```json
      },
      {
          "@id": "http://example.com/app#Carol",
          "@type": "http://example.com/slowmo#ascribee",
          "http://purl.obolibrary.org/obo/RO_0000091": [
              { "@value": "mastery_present" }
          ]
      }
  ],
```



## Candidate Smasher

### Input
- Spek
- External Template Metadata (optional)

The uri of "uses template" is "http://example.com/slowmo#slowmo\_0000003"
Metadata about templates can be declared inline in the spek, or just the id of the template.
Additional metadata about templates can be supplied as an external metadata file.
The results of the inline and external metadata are merged.

Templates section of spek:
```json
    "http://example.com/slowmo#slowmo_0000003": [
        {
            "@id": "https://example.com/app/onto#ShowGapTemplate"
        },
        {
            "@id": "https://inferences.es/app/onto#ShowTrendTemplate"
        }
    ]
```

External Template Metadata:
```json
    {
      "@id": "https://example.com/app/onto#ShowGapTemplate",
      "@type": "http://purl.obolibrary.org/obo/psdo#psdo_0000002",
      "name": "gap figure",
      "uses_intervention_property":[ 
        "normative_comparator",
        "peer_comparison"
      ]
    },
    {
      "@id": "https://inferences.es/app/onto#ShowTrendTemplate",
      "@type": "http://purl.obolibrary.org/obo/psdo#psdo_0000002",
      "name": "trend figure",
      "uses_intervention_property":[ "show_trend"]
    }
```

### Output: Add Candidates to Spek

The candidates are essentially concatenations of a performer and template.
Each has the dispositions (http://purl.obolibrary.org/obo/RO_0000091) of the performer, 
and the intervention properties of the template.
The performer and template progenitors are recorded as AncestorPerformer and AncestorTemplate.

Two of the candidates added to spek:
```json
  {
      "@id": "http://example.com/app/1f11539501aab7ee57ac755947c5d916",
      "@type": "http://example.com/cpo#cpo_0000053",
      "http://example.com/slowmo#AncestorPerformer": "http://example.com/app#Alice",
      "http://example.com/slowmo#AncestorTemplate": "https://inferences.es/app/onto#ShowTrendTemplate",
      "http://example.com/slowmo#uses_intervention_property": { "@value": "show_trend" },
      "http://purl.obolibrary.org/obo/RO_0000091": [
          { "@value": "mastery_unknown" },
          { "@value": "negative_gap" },
          { "@value": "negative_trend" },
          { "@value": "small_gap" }
      ],
      "http://schema.org/name": { "@value": "trend figure" }
  },
  {
      "@id": "http://example.com/app/925ec1812aeea4f491165499bc74e7d0",
      "@type": "http://example.com/cpo#cpo_0000053",
      "http://example.com/slowmo#AncestorPerformer": "http://example.com/app#Bob",
      "http://example.com/slowmo#AncestorTemplate": "https://example.com/app/onto#ShowGapTemplate",
      "http://example.com/slowmo#uses_intervention_property": [
          { "@value": "normative_comparator" },
          { "@value": "peer_comparison" }
      ],
      "http://purl.obolibrary.org/obo/RO_0000091": [
          { "@value": "mastery_present" },
          { "@value": "positive_trend" }
      ],
      "http://schema.org/name": { "@value": "gap figure" }
  },
```

## Think Pudding

This application expects the tripple store Fuseki to be running and accessible.

### Input
- Spek
- Causal Pathway Metadata

Example of metadata for a causal pathway:
```json
    {
      "@id": "http://example.com/app#onward_upward",
      "@type": "cpo:causal_pathway",
      "name": "Onward Upward",

      "cpo:has_prerequisite":[
        "positive_trend",
        "show_trend"
      ],

      "cpo:has_moderator":[
        { "slowmo:candidate_attribute": "slowmo:trend_slope_moderate",
          "slowmo:weight": {"@value": 10 }},
        { "slowmo:candidate_attribute": "slowmo:trend_slope_steep",
          "slowmo:weight": {"@value": 100 }}
      ],

      "cpo:mechanism": "motivation",
      "cpo:proximal_outcome": "performance improves",
      "slowmo:source_reference": "Kluger and DeNisi 1996"
    },

```

### Output: Candidate acceptability added.
Candidates that match the prerequisites of a causal pathway get "acceptable\_by" predicate added.

This candidate is accetable by the causal pathway named "onward upward".
It satisfied all of the prerequisites of the causal pathway.
Specifically, it has the positive\_trend disposition and the show\_trend intervention property.
```json
  {
    "@id": "http://example.com/app/c8cae3bc7a8d6635825e35f9ea59d5e1",
    "@type": "http://example.com/cpo#cpo_0000053",
    "AncestorPerformer": "http://example.com/app#Bob",
    "AncestorTemplate": "https://inferences.es/app/onto#ShowTrendTemplate",

    "acceptable_by": "http://example.com/app#onward_upward",

    "uses_intervention_property": "show_trend",
    "RO_0000091": [
      "mastery_present",
      "positive_trend"
    ],
    "name": "trend figure"
  },
```

This candidate is acceptable by the causal pathway, "eliminate negative gap".
The prerequisites for that pathway are negative\_gap and "normative\_comparator".
```json
  {
    "@id": "http://example.com/app/e3dfa93a31d886318aafd587d90f1e6a",
    "@type": "http://example.com/cpo#cpo_0000053",
    "AncestorPerformer": "http://example.com/app#Alice",
    "AncestorTemplate": "https://example.com/app/onto#ShowGapTemplate",

    "acceptable_by": "http://example.com/app#eliminate_neg_gap",

    "uses_intervention_property": [
      "normative_comparator",
      "peer_comparison"
    ],
    "RO_0000091": [
      "small_gap",
      "negative_trend",
      "negative_gap",
      "mastery_unknown"
    ],
    "name": "gap figure"
  }
```


