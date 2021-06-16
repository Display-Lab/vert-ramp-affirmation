# Goal Stayed Worse Example

## Performance data
Harun has performance levels of 91% for July 2020, 92% for August 2020, and 91% for September 2020.

## Comparator
Harun's goal for July, August, and September 2020 is 95%.

## Recipient annotations
This data set should result in an annotation that there is information content about a goal comparator, consecutive negative performance gaps, and the absence of a positive trend for Harun:

1. Goal comparator content (http://purl.obolibrary.org/obo/psdo_0000094)
2. Consecutive negative performance gap content (http://example.com/slowmo#ConsecutiveNegativeGapContent)
3. Absence of positive performance trend content (http://example.com/slowmo#PositiveTrendContentAbsence)
4. Recipient content (http://purl.obolibrary.org/obo/psdo_0000041)

## Template annotations
The consistently_worse_goal_bar template is about a consecutive negative performance gap set and a goal comparator element:
1. Goal comparator element (http://purl.obolibrary.org/obo/psdo_0000046)
2. Consecutive negative performance gap set (http://example.com/slowmo#ConsecutiveNegativeGapSet)

## Resulting candidates
The candidate produced for Harun has:

1. Goal comparator content (http://purl.obolibrary.org/obo/psdo_0000094)
2. Consecutive negative performance gap content (http://example.com/slowmo#ConsecutiveNegativeGapContent)
3. Absence of positive performance trend content (http://example.com/slowmo#PositiveTrendContentAbsence)
4. Recipient content (http://purl.obolibrary.org/obo/psdo_0000041)
5. Goal comparator element (http://purl.obolibrary.org/obo/psdo_0000046)
6. Consecutive negative performance gap set (http://example.com/slowmo#ConsecutiveNegativeGapSet)

## Causal pathway preconditions
The goal_stayed_worse causal pathway has preconditions:

1. Goal comparator content (http://purl.obolibrary.org/obo/psdo_0000094)
2. Consecutive negative performance gap content (http://example.com/slowmo#ConsecutiveNegativeGapContent)
3. Absence of positive performance trend content (http://example.com/slowmo#PositiveTrendContentAbsence)
4. Recipient content (http://purl.obolibrary.org/obo/psdo_0000041)
5. Goal comparator element (http://purl.obolibrary.org/obo/psdo_0000046)
6. Consecutive negative performance gap set (http://example.com/slowmo#ConsecutiveNegativeGapSet)

## Evaluation result
The candidate is found to be acceptable by the causal pathway goal_stayed_worse.

