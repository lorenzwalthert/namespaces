gh_cached <- memoise::memoise(gh::gh)

#' Fetch the content of a GitHub file
#'
#' Get the content of a file from a GitHub repository.
#' @inheritParams compose_content_request
#' @param ... Parameters passed to [compose_content_request()].
#' @examples
#' fetch_gh_content(
#'   user = "cran", repo = "styler", path = "NAMESPACE", ref = "1.0.0"
#' )
fetch_gh_content <- function(user, repo, path, ...) {
  request <- compose_content_request(user, repo, path, ...)
  encoded <- gh_cached(request)$content
  decode(encoded)
}

#' Create a content request
#'
#' @param user The user name under which the repo of interest lives.
#' @param repo The name of the repository of interest.
#' @param path The path to the file for which the content should be retrieved
#'   relative to the root of `repo`.
#' @param ... Parameters for the request in the form of key / value parirs. See
#'   also [key_value_pair_to_chr()]
compose_content_request <- function(user, repo, path, ...) {
  request <- paste("/repos", user, repo, "contents", path, sep = "/")
  pairs <- key_value_pair_to_chr(...)
  get_request_with_params <- paste0(request, if (length(pairs) > 0) "?", pairs) %>%
    compose_get()
}
