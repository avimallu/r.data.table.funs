require(data.table)

decile_dt <-  function(x, ile = 10, decreasing = TRUE) {
  
  # x should be a numeric vector
  # Data with 0 or with NA are marked to restore them when required
  # Use decreasing = TRUE for cases where D10 > D9 > D8...
  # Use decreasing = FALSE for cases where D1 > D2 > D3...
  # D0 is always for cases where the vector is 0 or NA
  
  NA_positions = (is.na(x) | (x == 0))
  
  # Convert to data.table
  x = as.data.table(x = x)
  
  # set NA values as 0
  x[is.na(x), x := 0][
    # add vector to maintain original order
    , num := .I][
      # sort by decreasing order of X
      order(-x)][
        # calculate cumulative sums by this order
        , cumsums := cumsum(x)][
          # this calculates the total fraction by maximum value
          , tot := cumsums/max(cumsums)][
            # actual decile calculation
            , dec := (if(decreasing) (ile + 1) - ceiling(tot * ile)
                      else ceiling(tot * ile))][
                        # restore original order
                        order(num)][
                          # restore original NA values or 0 to NA
                          , dec := fifelse(NA_positions, NA_real_, dec)][
                            # return as vector
                            , dec]
  
}
