extract_namespace_from_package_source <- function(path = ".") {
  r_files <- fs::dir_ls(fs::path(path, "R/"), type = "file") %>%
    map_dfr(extract_namespace_from_file) %>%
    type_object_to_namespace()
}

type_object_to_namespace <- function(raw_namespace) {
  tibble(
    type = "importFrom",
    object = paste(raw_namespace$package, raw_namespace$object, sep = ",")
  )
}

extract_namespace_from_file <- function(path) {
  enc::read_lines_enc(path) %>%
    extract_namespace_from_code()
}

extract_namespace_from_code <- function(code) {
  get_parse_data(code) %>%
    extract_namespace_from_parse_data()
}

#' @importFrom utils getParseData
get_parse_data <- function(text) {
  getParseData(parse(text = text, keep.source = TRUE))
}

extract_namespace_from_parse_data <- function(parse_data) {
  parse_data <- parse_data[order(parse_data$col1, parse_data$col1), ]
  is_ns_get <- parse_data$token == "NS_GET"
  parents_with_ns_get <- unique(parse_data[is_ns_get, ]$parent)
  map_dfr(parents_with_ns_get, extract_namespace_with_parents, parse_data)
}

#' @importFrom rlang set_names
extract_namespace_with_parents <- function(parent, parse_data) {
  pkg_and_obj_idx <- (parse_data$parent %in% parent) &
    (parse_data$token %in% c("SYMBOL_PACKAGE", "SYMBOL_FUNCTION_CALL", "SYMBOL"))
  parse_data[pkg_and_obj_idx, "text"] %>%
    set_names(c("package", "object")) %>%
    t() %>%
    as_tibble()
}
