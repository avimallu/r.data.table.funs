
library(data.table)
library(bit64)
library(stringi)
library(crayon)
library(glue)
library(numform)

# DT <- data.table(
#   logical = sample(c(TRUE, FALSE), 100, replace = TRUE),
#   states  = state.name,
#   species = iris$Species, 
#   order_of_letters = factor(letters[1:26], ordered = TRUE),
#   integral_numbers = as.integer(rnorm(100) * 100),
#   numeric_values   = rnorm(100) * 100,
#   integer64        = as.integer64("231982787612") +
#                     (as.integer64(rnorm(1e4) * 1000)),
#   range_of_date_values = seq.Date(
#     as.Date("2019-01-01"), by = "1 month", length.out = 100),
#   range_of_time_values = 
#     as.POSIXct(rnorm(1e4), origin = as.Date("2019-01-01")),
#   list_columns_also = list(letters[1:26], LETTERS[1:26], 1:26)
# )

vapply_1c = function (x, fun, ..., use.names = TRUE) {
  vapply(X = x, FUN = fun, ..., FUN.VALUE = NA_character_, USE.NAMES = use.names)
}

format_lines <- function(lines, classes) {
  
  # The purpose of these colours is not to differentiate each possible data
  # type, but to have a visual cue on different data types in a print
  
  class_colour = list(
    # Logical will be a mild red - not very visible, but relatively unimportant
    logical   = make_style("sienna2"),
    # Character will be a bland medium green
    character = make_style("limegreen"),
    # Integer is blue - lighter to darker to show range of storage
    integer   = make_style("steelblue1"),
    integer64 = make_style("steelblue2"),
    numeric   = make_style("steelblue3"),
    # Factor will be a mild yellow if unordered, and yellow if ordered
    factor    = make_style("yellow2"),
    ordered   = make_style("yellow3"),
    # A normal date (or IDate) will be in wheaty spectrum
    Date      = make_style("wheat3"),
    IDate     = make_style("wheat3"),
    POSIXct   = make_style("wheat4"),
    # Other "exotic" data types for completeness
    list       = make_style("rosybrown"),
    expression = make_style("plum"),
    complex    = make_style("palegreen3"),
    raw        = make_style("orange1")
  )
  
  colours = class_colour[classes]
  
  lines  = mapply(function(x, y) { match.fun(x)(y) },
                   colours, lines, SIMPLIFY = TRUE)
  
  unname(lines)
  
}

glean_colnames <- function(col_names, col_len) {
  
  paste0(substr(
    vapply_1c(col_names, paste, collapse = ",", use.names = FALSE),
    1, ifelse(nchar(col_names) > col_len, col_len - 3, col_len)),
    ifelse(nchar(col_names) > col_len, "...", ""))
  
}

glean_values <- function(head, val_len) {
  
  head = as.data.table(head)
  numeric_cols = names(which(sapply(head, is.numeric)))
  head[, (numeric_cols) := lapply(.SD, function(x) {
    x = signif(x, 3)
    f_denom(x, mix.denom = TRUE, digits = 2)
  }),
       .SDcols = numeric_cols]
  
  # browser()
  
  values = substr(
    vapply_1c(head, paste, collapse = ",", use.names = FALSE),
   1, val_len) 
  
}

glean <- function(x) {
  
  width       = getOption("width")
  max_col_len = as.integer(width * 0.55)
  col_len     = min(max(nchar(names(x))), max_col_len)
  
  # browser()
  
  col_nm  = glean_colnames(names(x), col_len)
  
  # browser()
  
  # 2 (align with #) + 5 (type separator) + 5 (end) = 12
  val_len = getOption("width") - col_len - 12 - fifelse(
    max_col_len == col_len, 3, 0)
  
  # browser()
  
  # Determine values to print
  values  = glean_values(head(x, 100), val_len)
  
  # browser()
  
  rows = nrow(x)
  columns = length(x)
  
  class_abb = c(
    list = "<lst>", integer = "<int>", numeric = "<num>",
    character = "<chr>", Date = "<Dat>", complex = "<cmp>",
    factor = "<fct>", POSIXct = "<D&T>", logical = "<lgl>",
    IDate = "<IDt>", integer64 = "<i64>", raw = "<raw>",
    expression = "<exp>", ordered = "<ord>")
  
  classes = vapply_1c(x, function(col) class(col)[1L], use.names=FALSE)
  abbs    = class_abb[classes]
  
  lines  = format_values(
    paste0(
      "  ",
      stri_pad(col_nm, col_len, "right"), " ",
      stri_pad(paste0(abbs, ": "), 7, "right"),
      stri_pad(values, val_len, "right"), "..."),
    classes)
  
  # browser()
  
  cat(paste0("  Rows: ", rows, ", Columns: ", columns, "\n"))
  cat(paste0(lines, collapse = "\n"))
  
  # browser()
  invisible(NULL)
  
}

#glean(DT)
#glean(Lahman::People)
