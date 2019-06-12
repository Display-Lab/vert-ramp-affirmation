library(dplyr, warn.conflicts = FALSE)
library(utils)
library(rlang)
library(stats)

# Annotator functions for NHS mtx perscribing behavior spek


############
# Run Once #
############

# Calculate the achievable benchmark
setup_cache <- function(data, spek){
  cache <- list()
  cache$achievable_benchmark <- calc_achievable_benchmark(data, spek)

  return(cache)
}

####################
# Helper Functions #
####################

calc_achievable_benchmark <- function(data, spek){
  # Hardcode column names.  Extract from spek in subsequent versions.
  id_colname <- 'id'
  denom_colname <- 'total_scripts'
  numer_colname <- 'high_dose_scripts'

  # Get a list of unique performer ids
  unique_performers <- unique(data[[id_colname]])

  # Sort out how many performers constitute 10% of unique
  num_top_performers <- floor(length(unique_performers)/10)

  # Guard against edge case of < 10 unique performers
  if(num_top_performers == 0) { num_top_performers <- 1 }

  # Make a symbol of the numerator and denominator columns
  denom_col_sym <- rlang::sym(denom_colname)
  numer_col_sym <- rlang::sym(numer_colname)
  id_col_sym <- rlang::sym(id_colname)

  #Get top 10 performers
  top_means <- data %>%
    group_by(!!id_col_sym) %>%
    mutate(rate=!!numer_col_sym / !!denom_col_sym) %>%
    summarize(ave_rate=mean(rate)) %>%
    top_n(n=num_top_performers, wt=ave_rate) %>%
    pull(ave_rate)

  #Median score of top 10 performers
  return(stats::median(top_means))
}

annotate_negative_gap <- function(data, spek){
  # Hardcode column names.  Extract from spek in subsequent versions.
  id_colname <- 'id'
  denom_colname <- 'total_scripts'
  numer_colname <- 'high_dose_scripts'
  time_colname <- 'period'
  # Make a symbol of the numerator and denominator columns
  denom_col_sym <- rlang::sym(denom_colname)
  numer_col_sym <- rlang::sym(numer_colname)
  id_col_sym <- rlang::sym(id_colname)
  time_col_sym <- rlang::sym(time_colname)

  data %>%
    group_by(!!id_col_sym) %>%
    mutate(rate=!!numer_col_sym / !!denom_col_sym) %>%
    dplyr::filter(!!time_col_sym == max(!!time_col_sym)) %>%
    summarize(negative_gap = rate < cache$achievable_benchmark)
}

annotate_positive_gap <- function(data, spek){
  # Hardcode column names.  Extract from spek in subsequent versions.
  id_colname <- 'id'
  denom_colname <- 'total_scripts'
  numer_colname <- 'high_dose_scripts'
  time_colname <- 'period'
  # Make a symbol of the numerator and denominator columns
  denom_col_sym <- rlang::sym(denom_colname)
  numer_col_sym <- rlang::sym(numer_colname)
  id_col_sym <- rlang::sym(id_colname)
  time_col_sym <- rlang::sym(time_colname)

  data %>%
    group_by(!!id_col_sym) %>%
    mutate(rate=!!numer_col_sym / !!denom_col_sym) %>%
    dplyr::filter(!!time_col_sym == max(!!time_col_sym)) %>%
    summarize(negative_gap = rate > cache$achievable_benchmark)
}


