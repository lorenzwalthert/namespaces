#' What are the minimal dependencies of a package?
#'
#' Function to collect minimal dependencies of a package.
#' @details
#' To find the minimal version of all packages needed given a source package,
#' we first collect imported objects as follows:
#'
#' * Parse the name space of source package to find all imports.
#' * Parse all R files in R/ to find all masked imports like pkg::fun that
#'   are not visible in the NAMESPACE file.
#' * Packages that are imported as a whole, that is, for which the NAMESPACE
#'   entry is `import(pkg)` (e.g. via the roxygen tag `@@import pkg`), we just
#'   assume that the latest version is required.
#'
#' Next, we use [find_first_release()] to search through the NAMESPACE
#' files of the CRAN releases of the resepecive packages.
#' @param path The path to source package.
#' @importFrom purrr pmap_chr
#' @export
collect_minimal_dependencies <- function(path = ".") {
  # desc <- parse_cran_description()
  clean_imports <- parse_local_namespace(path) %>%
    bind_rows(extract_namespace_from_package_source(path)) %>%
    # add_row(type = desc$type, package = desc$package)
    subset_imported_pkgs() %>%
    subset_unique_imports() %>%
    subset_non_base_packages()

  clean_imports <- clean_imports %>%
    add_column(first_release = clean_imports %>% pmap_chr(find_first_release))
  clean_imports
}

#' Which release is the first to export something?
#'
#' Find the first release of `package` that exports `object`. If no match is
#' found, `NA` is returned.
#' @param package A package.
#' @param object The exported object  in `package`. If `NA`, simply the last
#'   release is returned.
#' @details
#' Queries the [GitHub CRAN mirror](https://github.com/metacran) to find all
#' releases of a packages and performs binary search on their NAMESPACE to find
#' the first release in which a certain object was exported.
#' @examples
#' find_first_release("tibble", "add_column")
#' find_first_release("tibble", "add_columns")
#' @importFrom purrr partial
#' @export
find_first_release <- function(package, object) {
  all_tags <- fetch_gh_tags("cran", package) %>%
    subset_valid_tags()
  if (is.na(object)) {
    return(last(all_tags))
  }
  is_exported_in_ref_with_obj_and_pkg <- partial(
    obj_is_exported_in_ref,
    obj = object, package = package
  )
  binary_search_cached(all_tags, is_exported_in_ref_with_obj_and_pkg)
}

#' Check whether an oject is exported by a certain package version
#'
#' @param package The package to check.
#' @param ref The version reference to check.
#' @param obj The object for which we want to know whether it is exported or
#'   not.
obj_is_exported_in_ref <- function(package, ref, obj) {
  exports <- parse_cran_namespace(package, ref = ref) %>%
    subset_exports()
  obj %in% exports
}
