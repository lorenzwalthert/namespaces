
collect_dependent_namespaces <- function(path) {
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

#' @param object The exported object
find_first_release <- function(package, object) {
  all_tags <- fetch_gh_tags("cran", package)
  if (is.na(object)) return(last(all_tags))
  is_exported_in_ref_with_obj_and_pkg <- partial(
    obj_is_exported_in_ref, obj = object, package = package
  )
  bisect_search(all_tags, is_exported_in_ref_with_obj_and_pkg)
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
