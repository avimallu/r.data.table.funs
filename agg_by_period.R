
# Required libraries ------------------------------------------------------

library(data.table)
library(purrr) # to be removed once mergelist is released in data.table

# Sample large data table -------------------------------------------------

DT = data.table(
  dates = seq.Date(as.Date("2019-01-01"), by = "1 week", length.out = 200),
  grp_1 = c("India", "Brazil", "China", "Russia", "South Africa"),
  grp_2 = c("Buttons", "Salt"),
  sales = runif(1e8, 0, 100)
)

# Aggregation function ----------------------------------------------------

agg_by_period <- function(i, DT, j, by, index) {
  
  # sum is optimized internally in data.table
  # between is parallelized in data.table
  # key the data.table by the index to have even faster operation times
  temp <- 
    setnames(DT[
      between(get(index), date_periods[[i]][[1]], date_periods[[i]][[2]]),
      lapply(.SD, sum, na.rm = TRUE), keyby = by, .SDcols = j],
      j, paste0(j, "_", names(date_periods[i])))
  
  # scale the latter period by any amount if required
  if(date_periods[[i]][[3]] != 1) {
    
    temp[, lapply(.SD, `*`, date_periods[[i]][[3]]),
         keyby = by]
    
  } else {
    
    temp
  }
  
}

# Aggregate By Period = agp, for data.tables ala DT
agp_DT <- function(DT, j, by, index) { 
  
  
  # to be replaced by mergelist when it is released in data.table
  reduce(
    lapply(seq_along(date_periods), agg_by_period, DT, j, by, index),
    merge.data.table, allow.cartesian = TRUE,
    by = by, all.x = TRUE,
    .init = unique(DT[, ..by]))

}

# Create fixed tables and functions to ease date period creation ----------

# Only to ease recalculation of min and max value over and over again
max_date = max(DT[, dates])
min_date = min(DT[, dates])

# Creating an alias to avoid using as.Date
d <- function(x) {as.Date(x)}

# This list can be configured to calcaulte different aggregate
# time periods of interest
date_periods <- list(
  # name      = start_date, end_date, scaling
  r3m         = list(max_date - 12 * 7, max_date, 1),
  p3m         = list(max_date - 25 * 7, max_date - 13 * 7, 1),
  r6m         = list(max_date - 25 * 7, max_date, 1) ,
  p6m         = list(max_date - 51 * 7, max_date - 26 * 7, 1),
  ytd         = list(d("2020-01-01"), max_date, 0.7)
)

# Benchmark ---------------------------------------------------------------

system.time(agp_DT(DT, "sales", "grp_1", "dates"))
system.time(agp_DT(DT, "sales", c("grp_1", "grp_2"), "dates"))•

