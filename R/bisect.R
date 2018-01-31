#' @param range `fun` must evaluate to `TRUE` at least for the last element
#'   in range. That means, if not successful in the middle, it will jump to
#'   right
#' @importFrom rlang seq2
bisect_search <- function(range, fun) {
  if (length(range) < 2) return(range)
  candidate <- middle_idx(range)
  result <- fun(range[candidate])
  direction <- ifelse(result, "lower", "upper")
  range <- split_range(range, direction)
  bisect_search(range, fun)
}

middle_idx <- function(range) {
  idx <- floor((length(range) + 1)/2)
  idx
}

split_range <- function(range, part = "upper") {
  middle <- middle_idx(range)
  if (part == "lower") {
    range[seq2(1L, middle - 1L)]
  } else {
    range[seq2(middle + 1L, length(range))]
  }
}
