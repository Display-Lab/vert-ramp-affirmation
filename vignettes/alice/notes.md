# Notes while creating Alice example

peer comparison requires peers.
needed to create peers data with expected average.
does template specified in spek get merged with external templates?
try ruby gem csvlint to validate structure of data files
csvlint current version doesn't work with current ruby.
try python frictionless describe and validate.
suggest using miniconda for python installation and package management, but might be bridge too far.

calculation of peer average should exclude the recipient.
  this was discussed before, but the straight average everyone was decided upon.
  i don't recall the reasons, but it's computationally easier anyway.
  means the peer data is going to be wierd in order to get a .93 mean rate.
  calculating a synthetic data set for coming up with a given mean is a bit of a pain.
  97,94,91,90 gives mean of 93.

aspire annotations don't generalize without modification to rate data.
should write a general rate data annotation set.

bitstomach does not like when performace data does not have a measure column.
  write test case for data set cases: mapt, map, mpt, apt, pt, ap
  provide assumption for missing dimensions
should try to sort out generic function for calc peer average to avoid having it in every annotation.r
  going to be problematic to handle numerator only, numer & denominator, and rate data in one function.
  consider splitting to three and attempting to detect the case for each measure.
  numerator only is going to be the hard one here.

bitstomach reads in rate as character data.
  should read in a double as per the spek. This is a problem with `spekex::cols_for_readr`.
  spekex updated.

candidates smasher cli (cansmash) parameter flags differ from bitstomach and thinkpudding.
  `-s` should point to spek

fucked up the `@context` element of the json-ld docs.
  the spec does not like having a ':' in the keys:

  >  Strings that have the form of an IRI (e.g., containing a ":") should not be used as terms.

  consider dropping the prefix for the context entries that are convenient lookups.
  using "psdo:term" should still work as the psdo prefix is define in the context.
  see templates.json in alice example for corrected version.
