# r.data.table.funs
A set of functions that I have found very useful for speeding up my analysis work. These are well designed (imo) functions that provide a
fast alternative to conjuring up functions yourself. These functions are free to use, I don't care (mostly) what you do with it,
are provided without any warranty yada yada, and do not give you the right to use it in closed source products (good luck doing that with
R code though).

# Contents
## agg_by_period
This is a useful case where you are required to aggregate value by a date index into separate periods,
possibily for use in tools that work better without pivoted up data (eg. Excel). The syntax is:
```
agp(table_name, j, by, index)
# j, by have their usual meaning as in data.table
# index is the date column you want to aggregate by
```

The data can be aggregated for, say, recent 3, 6, 12 months and year to date by suitably defining the values of the `date_period` list
(check the code for this variable definition).

## decile
Often, in sales analytics, you are required to group categories (districts, doctors, countries) into 10 groups that have equal contributions,
in decreasing order of contribution i.e. the first group will have the least members that contribute 10% of some value,
the next will have more members that contribute the next 10%, all the way to the last group that will have the highest number of
members that contirbute the bottom 10% of the value. This relates to percentiles, althought they are not identical.

```
decile_dt(x, decreasing = TRUE)
```
