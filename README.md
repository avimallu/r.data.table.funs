# r.data.table.funs
A set of functions that I have found very useful for speeding up my analysis work. These are well designed (imo) functions that provide a
fast alternative to conjuring up functions yourself. These functions are free to use, I don't care (mostly) what you do with it,
are provided without any warranty yada yada, and do not give you the right to use it in closed source products (good luck doing that with
R code though). Read the LICENSE.

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
(check the code for this variable definition). For example, for the following glimpse of data:

```
> DT
                dates        grp_1   grp_2     sales
        1: 2019-01-01        India Buttons  5.857764
        2: 2019-01-08       Brazil    Salt 94.159590
        3: 2019-01-15        China Buttons 95.128017
        4: 2019-01-22       Russia    Salt 17.057105
        5: 2019-01-29 South Africa Buttons 68.489827
       ---                                          
 99999996: 2022-09-27        India    Salt 43.997368
 99999997: 2022-10-04       Brazil Buttons 46.981903
 99999998: 2022-10-11        China    Salt  7.700367
 99999999: 2022-10-18       Russia Buttons 84.551482
100000000: 2022-10-25 South Africa    Salt 75.611129
```

the summarized dataset will look something like:

```
> agp_DT(DT, "sales", c("grp_1", "grp_2"), "dates")
           grp_1   grp_2 sales_r3m sales_p3m sales_r6m sales_p6m sales_ytd
 1:       Brazil Buttons  24986904  50009826  74996730  50008718 262554380
 2:       Brazil    Salt  24996211  24986346  49982557  75021112 245026785
 3:        China Buttons  25022494  24988808  50011302  74985508 245044854
 4:        China    Salt  49967206  25022877  74990082  50008190 262566617
 5:        India Buttons  25030072  24992465  50022537  75059273 245038138
 6:        India    Salt  24998593  49995222  74993814  50016927 262498605
 7:       Russia Buttons  50015343  24993829  75009172  75012270 262531196
 8:       Russia    Salt  24980912  25010533  49991445  74935847 262490950
 9: South Africa Buttons  24999193  50004908  75004101  50006625 262463146
10: South Africa    Salt  50010186  24989640  74999826  75005350 262494492
```

## decile
Often, in sales analytics, one is required to group certain continous variables into buckets that contribute to 10% of overall sales,
in decreasing order of contribution. That is, in the first bucket, you'll have very few members that, together contribute to 10%, and
this member count increases as the bucket count increases, each contributing to 10% of the overall sales. In terms of percentiles, the first
bucket can be defined as the members that are in the top 90%ile of contributors, the second bucket will be those that are in the top 80%ile
of contributors, excluding the top 90%ile of contributors, and so on.

```
decile_dt(x, ile = 10, decreasing = TRUE)
```

The decile function defaults to 10 groups, but can be changed to be any `n` groups i.e. quartlie or quintile through the `ile` argument.

## glean
A quick hack-y replacement for `dplyr::glimpse` for `data.table`, but enhanced to differentiate data types by color and read numeric and integer values in human friendly styles (i.e. 4,721,123 as 4.72M). The colours are meant for differentiation, but not identifcation i.e. serves as an analytical aid while reading very long tables. Currently uses a bit too many libraries (4 of them), which I'm not comfortable with - the aim is to reduce them all to 2 (i.e. `data.table` and `crayon`, both of which have no dependencies themselves). Stay tuned - this is still very much a WIP.

![glean screenshot](https://github.com/avimallu/r.data.table.funs/blob/master/screens/glean.JPG?raw=true)
