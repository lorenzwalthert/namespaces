#' Compose a request
#'
#' @param type The type of the request
compose_request <- function(type, request, options) {
  paste(type, request)
}
#' @importFrom purrr partial
compose_get <- purrr::partial(compose_request, "GET")
