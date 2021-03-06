#' Fetch all tags of a github repo
#'
#' @importFrom purrr map_chr
#' @examples
#' namespaces:::fetch_gh_tags("cran", "styler")
#' @keywords internal
fetch_gh_tags <- function(user, repo) {
  get_request <- paste("/repos", user, repo, "git/refs/tags", sep = "/") %>%
    compose_get()
  gh_cached(get_request) %>%
    map_chr("ref") %>%
    extract_tags()
}

#' Extract tags from messy ref
#'
#' @examples
#' namespaces:::extract_tags("refs/tags/1.0.0")
#' @keywords internal
extract_tags <- function(messy_ref) {
  strsplit(messy_ref, "refs/tags/", fixed = TRUE) %>%
    map_chr(~ .x[length(.x)])
}
