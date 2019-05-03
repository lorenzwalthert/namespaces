subset_exports <- function(tabular_namespace, simplify = TRUE) {
  is_export <- is_export(tabular_namespace)
  tabular_export <- tabular_namespace[is_export, "object"] %>%
    unlist()
  tabular_export
}

is_export <- function(tabular_namespace) {
  tabular_namespace$type == "export"
}

subset_non_base_packages <- function(namespace) {
  base_idx <- namespace$package %in% base_pkgs()
  namespace[!base_idx, ]
}

subset_valid_tags <- function(tags) {
  tags[!grepl("[[:alpha:]]", tags)]
}

base_pkgs <- function() {
  pkgs <- installed.packages()
  is_base_pkg <- pkgs[, "Priority"] %in% "base"
  pkgs[is_base_pkg, "Package"]
}

subset_imported_pkgs <- function(tabular_namespace,
                                 condition = c("import", "importFrom")) {
  is_import <- tabular_namespace$type %in% condition
  tabular_import <- tabular_namespace[is_import, "object"]
  split <- strsplit(unlist(tabular_import), ",", fixed = TRUE)
  package <- split %>%
    map_chr(~ .x[1]) %>%
    unname()
  object <- split %>%
    map_chr(~ .x[2]) %>%
    unname()
  tibble(package, object)
}

subset_unique_imports <- function(imports) {
  imports_full_pkg <- is.na(imports$object)
  complete_imports <- imports[imports_full_pkg, ]
  partial_imports <- imports[!imports_full_pkg, ]

  required_partial_imports <- setdiff(
    partial_imports$package, complete_imports$package
  )
  idx_required_partial_imports <-
    partial_imports$package %in% required_partial_imports
  partial_imports <- partial_imports[idx_required_partial_imports, ]
  rbind(complete_imports, partial_imports)
}
