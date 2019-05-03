#' Decode base64
#'
#' Decodes base64, which is a common format returned by the GitHub API.
decode <- function(encoded) {
  rawToChar(base64enc::base64decode(encoded)) %>%
    strsplit("\n") %>%
    .[[1]]
}


#' Turn key value pairs into a string
#'
#'  @para ... named arguments where the name is the key and the
#'    value is the value.
key_value_pair_to_chr <- function(...) {
  values <- list(...)
  keys <- names(values)
  paste(keys, unname(values), sep = "=", collapse = "&") %>%
    remove_emtpy_chr()
}

remove_emtpy_chr <- function(x) {
  x[x != ""]
}
remove_comments <- function(x) {
  gsub("#.*$", "", x)
}

#' Wrapper around tibble::deframe()
#'
#' @param x object to deframe
#' @param deframe Whether or not to deframe.
may_unlist <- function(x, deframe) {
  if (deframe) {
    x %>%
      unlist() %>%
      unname()
  } else {
    x
  }
}

first <- function(x) {
  nth(x, 1)
}

last <- function(x) {
  nth(x, length(x))
}

nth <- function(x, n) {
  x[n]
}
