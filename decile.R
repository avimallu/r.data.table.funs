
# Required libraries ------------------------------------------------------

library(data.table)

# Add deciles -------------------------------------------------------------

decile_dt <-  function(x, decreasing = TRUE) {
  
  # browser()
  
  NA_positions = (is.na(x) | (x == 0))
  
  x = as.data.table(x = x)
  
  x[is.na(x), x := 0][
    , num := .I][
      order(-x)][
        , cumsums := cumsum(x)][
          , tot := cumsums/max(cumsums)][
            , dec := (if(decreasing) 11 - ceiling(tot * 10)
                      else ceiling(tot * 10))][
                        order(num)][
                          , dec := fifelse(NA_positions, NA_real_, dec)][
                            , dec]
  
}