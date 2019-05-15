library(dplyr, warn.conflicts = FALSE)
library(utils)

# Annotations for VA example
#   Hardcoding column names currently.  Subsequent iterations are expected to take advantage of
# column use and name specification from spek.

setup <- function(data, spec){
  cat(paste("\nSETUP\n", names(data), "\n\n"), file=stderr())
}

## Helper functions
eval_obs_paucity <- function(doc, ndoc){
  c_obs <- sum(doc, ndoc)

  if( c_obs < 12 & 
      dplyr::last(ndoc) < 6 &
      dplyr::last(doc) < 6 ){
    return(TRUE)
  }

  return(FALSE)
}

eval_negative_trend <- function(doc, ndoc){
  ratio <- doc/ndoc
  is_tail_ascending <- !is.unsorted(utils::tail(ratio,3), strictly=T)
  return(is_tail_ascending)
}

eval_negative_gap <- function(doc, ndoc){
  ratio <- doc/ndoc
  return(dplyr::last(ratio) < 0.9)
}

## Annotation functions
annotate_obs_paucity <- function(data, col_spec){
  data %>%
    group_by(id) %>%
    arrange(report_month) %>%
    summarize(obs_paucity = eval_obs_paucity(documented, not_documented))
}

annotate_negative_gap <- function(data, col_spec){
  data %>% group_by(id) %>%
    dplyr::filter(report_month == max(report_month)) %>%
    summarize(negative_gap = eval_negative_gap(documented, not_documented))
}

annotate_negative_trend <- function(data, col_spec){
  #cat(paste("\nnegTrend\n"), file=stderr())
  data %>%
    group_by(id) %>%
    arrange(report_month) %>%
    summarize(negative_trend = eval_negative_trend(documented, not_documented))
}
