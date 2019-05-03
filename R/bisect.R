#' Binary search
#'
#' Plain binary search.
#' @param range `fun` must evaluate to `TRUE` at least for the last element
#'   in range. That means, if not successful in the middle, it will jump to
#'   right.
#' @param a function to be applied to `range`.
#' @return
#' Returns `NA` if none of the elements in range evaluated to `TRUE` when
#' `fun` was applied to them. Otherwise, it will return the first element
#' (going from left to right) for which `fun(range[i])` evaluated to `TRUE`.
#' @importFrom rlang seq2
binary_search <- function(range, fun) {
  terminal <- may_terminate(range, fun)
  if (length(terminal) == 1) {
    return(terminal)
  }
  candidate <- middle_idx(range)
  result <- fun(range[candidate])
  direction <- ifelse(result, "lower", "upper")
  range <- split_range(range, direction)
  binary_search(range, fun)
}
binary_search_cached <- memoise::memoise(binary_search)

#' How did it all end?
#'
#' Asssess the result of a binary search. Return the successful condition
#' if one is found, otherwise return NA. If the search has not yet been
#' determined, return a character string of length zero. The function is not
#' written for performance, but just to be explicit.
#' @param range A range of candidates for the bisection
#' @param fun A function to be applied to range once range shrank to length one.
may_terminate <- function(range, fun) {
  if (length(range) > 1) {
    return()
  }
  if (!fun(range)) {
    NA
  } else {
    range
  }
}

middle_idx <- function(range) {
  idx <- floor((length(range) + 1) / 2)
  idx
}

split_range <- function(range, part = "upper") {
  middle <- middle_idx(range)
  if (part == "lower") {
    range[seq2(1L, middle)]
  } else {
    range[seq2(middle + 1L, length(range))]
  }
}
