% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bisect.R
\name{binary_search}
\alias{binary_search}
\title{Binary search}
\usage{
binary_search(range, fun)
}
\arguments{
\item{range}{\code{fun} must evaluate to \code{TRUE} at least for the last element
in range. That means, if not successful in the middle, it will jump to
right.}

\item{a}{function to be applied to \code{range}.}
}
\value{
Returns \code{NA} if none of the elements in range evaluated to \code{TRUE} when
\code{fun} was applied to them. Otherwise, it will return the first element
(going from left to right) for which \code{fun(range[i])} evaluated to \code{TRUE}.
}
\description{
Plain binary search.
}
\keyword{internal}
