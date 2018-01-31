bind_rows <- function(x, y = NULL, ...) {
  if (is.null(x) && is.null(y)) {
    return(tibble())
  }
  if (is.null(x)) {
    if (inherits(y, "data.frame")) {
      return(y)
    }
    return(do.call(rbind.data.frame, x))
  }
  if (is.null(y)) {
    if (inherits(x, "data.frame")) {
      return(x)
    }
    return(do.call(rbind.data.frame, x))
  }
  if (NCOL(x) != NCOL(y)) {
    for (nme in setdiff(names(x), names(y))) {
      y[[nme]] <- NA
    }
  }
  bind_rows(rbind.data.frame(x, y), ...)
}

#' @importFrom purrr as_mapper map
map_dfr <- function (.x, .f, ..., .id = NULL) {
  .f <- as_mapper(.f, ...)
  res <- map(.x, .f, ...)
  bind_rows(res, .id = .id)
}


