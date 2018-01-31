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
  )
}
