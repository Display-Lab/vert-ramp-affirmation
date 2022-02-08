# SPARQL Queries

## Insert Data
```sql
PREFIX : <http://stardog.com/tutorial/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

INSERT DATA {
    GRAPH <http://localhost:3030/udemy> {
:Bugs_Bunny a :Looney_Tunes_Character ;
      :name "Bugs Bunny" ;
      :species "Hare" ;
      :gender "Male" ;
      :made_debut_appearance_in :A_Wild_Hare ;
      :created_by :Tex_Avery ;
      :personality_trait "Cunning" , "Charismatic" , "Smart" ;
      :known_for_catchphrase "What's up, doc?" .
    
:A_WildHare a :Short ;
      :release_date "1940-07-27"^^xsd:date  .
    
:Tex_Avery a :Person ;
      :name "Frederick Bean Avery" ;
      :born_on "1908-02-26"^^xsd:date ;
      :died_on "1980-08-26"^^xsd:date .
    }
}
```
## Get all
### Get Entire Graph
```sql
SELECT ?s ?p ?o 
FROM <http://localhost:3030/graphname>
WHERE { ?s ?p ?o }
```

### Get One entry
```sql
SELECT ?s ?p ?o 
FROM <http://localhost:3030/graphname>
WHERE { ?s ?p ?o }
LIMIT 1
```

### Candidates
#### Get All Candidates (obo:cpo_0000053)
```sql
SELECT ?candidate ?p ?o 
FROM <http://localhost:3030/graphname>
WHERE { ?candidate a obo:cpo_0000053  }
```

#### Get all candidates with a condition (acceptable by SocialBetter)
```sql
SELECT ?candidate ?p ?o 
FROM <http://localhost:3030/graphname>
WHERE { ?candidate a obo:cpo_0000053  ;
            :acceptable_by "http://feedbacktailor.org/ftkb#SocialBetter" .
}
```
#### First result with condition
```sql
SELECT ?candidate ?p ?o 
FROM <http://localhost:3030/graphname>
WHERE { ?candidate a obo:cpo_0000053  ;
            :acceptable_by "http://feedbacktailor.org/ftkb#SocialBetter" .
} 
LIMIT 1
```

#### Count all candidates
```sql
SELECT (COUNT (?candidate) AS ?numberOfCandidates)
FROM <http://localhost:3030/graphname>
WHERE { ?candidate a obo:cpo_0000053  }
```

#### Count all candidates' distinct causal pathways
```sql
SELECT (COUNT (DISTINCT ?causalPathway) As numberOfCausalPathways)
FROM <http://localhost:3030/graphname>
WHERE { ?candidate a obo:cpo_0000053  ;
:acceptable_by ?causalPathway .
} 
```