#' Turn a raw name space into a table
#'
#' Turns the content of a name space file into a tabular format
#' @param namespace A vector with the content of a name space
#' @examples
#' namespace <- namespaces:::fetch_gh_content(
#'   user = "cran", repo = "styler", path = "NAMESPACE", ref = "1.0.0"
#' )
#' namespaces:::parse_namespace_into_tabular(namespace)
#' @importFrom purrr map_chr
parse_namespace_into_tabular <- function(namespace) {
  bare_namespace <- remove_comments(namespace) %>%
    remove_emtpy_chr() %>%
    trimws() %>%
    map_chr(~substr(.x, 1L, nchar(.x) - 1))
  lst_namespace <- strsplit(bare_namespace, "(", fixed = TRUE)
  tibble(
    type = map_chr(lst_namespace, ~.x[1]),
    object = map_chr(lst_namespace, ~.x[2])
  ) %>%
    expand_multiple_io_per_line()
}

#' Expand NAMESPACE to one entry per line
#'
#' Expand a line from a NAMESPACE listing multiple objects into a multiple lines
#' containing one object each line.
#' @param tabular_namespace A name space in a tabular format, that is, a tibble
#'   with a column type and one with object.
#' @examples
#' tabular <- tibble::tibble(
#'   type = "export",
#'   object = "base64encode, base64decode, dataURI, checkUTF8"
#' )
#' expand_multiple_io_per_line(tabular)
#' @importFrom purrr pmap_dfr
expand_multiple_io_per_line <- function(tabular_namespace) {
  pmap_dfr(tabular_namespace, expand_multiple_io)

}

#' @importFrom purrr flatten_chr
#' @importFrom tibble tibble
expand_multiple_io <- function(type, object) {
  raw_exports <- object %>%
    strsplit(", ", fixed = TRUE) %>%
    flatten_chr()
  tibble(type, object = raw_exports)

}
