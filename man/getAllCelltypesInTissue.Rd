% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/markerDB.R
\name{getAllCelltypesInTissue}
\alias{getAllCelltypesInTissue}
\title{Finds all cell types annotated per tissue and species}
\usage{
getAllCelltypesInTissue(tissue, species, filter_list = list(),
  server = "http://markers.blebli.de")
}
\arguments{
\item{tissue}{name of tissue}

\item{species}{name of species}

\item{filter_list}{Additional filters in list format (i.e: list(stage = "p7")). Wildcards can be added by using a "\%" sign. So, if all embryonic mouse markers are wanted, list like list(stage="E\%") can be used.}

\item{server}{URL of the server hosting the markerDB website.}
}
\value{
Character vector of cell types
}
\description{
A easy function which lets the user filter MarkerDB for a tissue and species and returns a list of cell types annotated.
}
