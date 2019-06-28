library(dplyr, warn.conflicts = FALSE)
library(utils)
library(rlang)
library(stats)


#
# Helper Functions
#

eval_positive_trend <- function(numer, denom){
  ratio <- numer/denom
  is_tail_ascending <- !is.unsorted(utils::tail(ratio,3), strictly=T)
  return(is_tail_ascending)
}

eval_negative_gap <- function(numer, denom){
  ratio <- numer/denom
  return(dplyr::last(ratio) < 0.8)
}

eval_large_gap <- function(numer, denom){
  ratio <- numer/denom
  is_large <- abs(dplyr::last(ratio) - 0.8) > .1
  return(is_large)
}

#
## Annotation functions
#

annotate_negative_gap <- function(data, spek){
  data %>% group_by(id) %>%
    dplyr::filter(month == max(month)) %>%
    summarize(negative_gap = eval_negative_gap(passed, non_excluded))
}

annotate_positive_trend <- function(data, spek){
  data %>%
    group_by(id) %>%
    arrange(month) %>%
    summarize(positive_trend = eval_positive_trend(passed, non_excluded))
}

annotate_large_gap <- function(data, spek){
  data %>% 
    group_by(id) %>%
    dplyr::filter(month == max(month)) %>%
    summarize(large_gap = eval_large_gap(passed, non_excluded))
}
