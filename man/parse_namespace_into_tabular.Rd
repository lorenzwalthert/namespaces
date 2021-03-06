% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/namespaces-parse.R
\name{parse_namespace_into_tabular}
\alias{parse_namespace_into_tabular}
\title{Turn a raw name space into a table}
\usage{
parse_namespace_into_tabular(namespace)
}
\arguments{
\item{namespace}{A vector with the content of a name space}
}
\description{
Turns the content of a name space file into a tabular format
}
\examples{
namespace <- namespaces:::fetch_gh_content(
  user = "cran", repo = "styler", path = "NAMESPACE", ref = "1.0.0"
)
namespaces:::parse_namespace_into_tabular(namespace)
}
\keyword{internal}
