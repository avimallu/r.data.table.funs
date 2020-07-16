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
Often, in sales analytics, one is required to group certain categorical variables into buckets that contribute to 10% of overall sales,
in decreasing order of contribution. That is, in the first bucket, you'll have very few members that, together contribute to 10%, and
this member count increases as the bucket count increases, each contributing to 10% of the overall sales. In terms of percentiles, the first
bucket can be defined as the members that are in the top 90%ile of contributors, the second bucket will be those that are in the top 80%ile
of contributors, excluding the top 90%ile of contributors, and so on.

```
decile_dt(x, decreasing = TRUE)
```
