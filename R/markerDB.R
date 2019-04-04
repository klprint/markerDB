#' Get all species in MarkerDB
#'
#' @param server URL of the server hosting the markerDB website.
#'
#' @return character vector of species in MarkerDB
#'
#' @export
getSpecies <- function(server = "http://markers.blebli.de") {
  json_data = rjson::fromJSON(
    RCurl::getURL(server, "/api/v1.0/species")
  )

  return(tolower(json_data))
}

#' Get informations of a species in MarkerDB
#'
#' This function helps to get information of a specieid species in MarkerDB.
#' The user not only gets the names of all celltypes known within in this species,
#' but also its latin and ENSEMBL name.
#'
#' @param species Character variable of species name
#' @param server URL of the server hosting the markerDB website.
#'
#' @return List of species annotations
#' @export
getSpeciesInfo <- function(species, server = "http://markers.blebli.de") {
  if (tolower(species) %in% tolower(getSpecies())) {
    json_data = rjson::fromJSON(
      RCurl::getURL(paste0(server, "/api/v1.0/species/", species))
    )
    return(json_data)
  } else {
    print(paste0(species, " not in the database!"))
    return(NULL)
  }
}


parseSpeciesCellTypeInfo <- function(rawInfo) {
  out.df <- NULL
  for (i in 1:length(rawInfo)) {
    out.df <- rbind(out.df, rawInfo[[i]])
  }

  return(as.data.frame(out.df))
}

#' Get a table of celltype informations
#'
#' To get a data.frame which holds all informations of a cell type within a specified species, use this function.
#'
#' @param celltype name of celltype
#' @param species name of species
#' @param server URL of the server hosting the markerDB website.
#'
#' @return data.frame of informations on all markers of a specific cell type.
#' @export
getSpeciesCellTypeInfo <- function(celltype, species, server = "http://markers.blebli.de") {

  speciesInfo <- getSpeciesInfo(species)

  if (is.null(speciesInfo)) {
    stop("Use another species, or find annotated species using getSpecies function.")
  } else {
    if (tolower(celltype) %in% tolower(speciesInfo$celltypes)) {
      ct.info <- rjson::fromJSON(
        RCurl::getURL(paste0(server, "/api/v1.0/species/", species, "/", celltype))
      )

      return(parseSpeciesCellTypeInfo(ct.info))
    } else {
      stop(paste0("No informations about ", celltype, " in ", species))
    }
  }
}


#' Greedy search for celltypes within a specific species
#'
#' Sometimes the name of a cell-type is only partially known, for these circumstances, this function was designed.
#' Using grep all celltypes which contain the "celltype" variable are returned.
#'
#' @param celltype partial cell type name
#' @param species name of species to look into
#'
#' @return vector of celltypes
#' @export
findCellTypes <- function(celltype, species) {
  speciesInfo <- getSpeciesInfo(species)
  annot.cts <- speciesInfo$celltypes

  return(grep(tolower(celltype), tolower(annot.cts), value = T))
}


#' Get all markers for a specific cell type within a species
#'
#' This functions gives a vector of annotated markers of a cell type within a predefined species.
#'
#' @param celltype name of celltype
#' @param species name of species (as can be found using getSpecies function)
#' @param field can be either "marker_accession" to get GeneIDs or "marker_name" to return gene names
#' @param positive True by default. Only return positive markers
#' @param filter_list Additional filters in list format (i.e: list(stage = "p7")).
#' Wildcards can be added by using a "\%" sign.
#' So, if all embryonic mouse markers are wanted, a list like list(stage="E\%") can be used.
#' @param exclusive Either Null, "all" or a vector with celltypes.
#' If provided, only marker genes are returned that are exclusive to the celltype specified in "celltype" amongst all annotated markers or the celltypes given in this parameter.
#' @param server URL of the server hosting the markerDB website.
#'
#' @return character vector of marker genes
#' @export
getMarkerGenes <- function(celltype, species, field = c("marker_accession", "marker_name"), positive = TRUE, filter_list = list(), exclusive = NULL, server = "http://markers.blebli.de") {

  if (length(field) > 1) {
    field <- field[1]
  }

  celltype <- gsub(" ", "_", celltype)

  url.string <- paste0(server, "/api/v1.0/species/", species, "/", celltype, "/v:", field, "/f:positive=", as.character(as.numeric(positive)))

  if (!is.null(exclusive)) {
    url.string <- paste0(url.string, "/e:")
    if (exclusive != "all") {
      exclusive <- paste(exclusive, collapse = "-")
      exclusive <- gsub(" ", "_", exclusive)
    }
    url.string <- paste0(url.string, exclusive)
  }

  if (length(filter_list) > 0) {
    for (n in names(filter_list)) {
      url.string <- paste0(url.string, "-", n, "=", filter_list[n])
    }
  }

  url.string <- gsub("%", "%25", url.string)

  marker.genes <- rjson::fromJSON(
    RCurl::getURL(
        url.string
      )
    )

  marker.genes <- unique(marker.genes)
  return(marker.genes)
}

#' Finds all cell types annotated per tissue and species
#'
#' A easy function which lets the user filter MarkerDB for a tissue and species and returns a list of cell types annotated.
#'
#' @param tissue name of tissue
#' @param species name of species
#' @param filter_list Additional filters in list format (i.e: list(stage = "p7")). Wildcards can be added by using a "\%" sign. So, if all embryonic mouse markers are wanted, list like list(stage="E\%") can be used.
#' @param server URL of the server hosting the markerDB website.
#'
#' @return Character vector of cell types
#' @export
getAllCelltypesInTissue <- function(tissue, species, filter_list = list(), server = "http://markers.blebli.de") {

  url.string <- paste0(server, "/api/v1.0/species/", tolower(species), "/f:tissue=", tissue)

  if (length(filter_list) > 0) {
    for (n in names(filter_list)) {
      url.string <- paste0(url.string, "-", n, "=", filter_list[n])
    }
  }

  url.string <- gsub("%", "%25", url.string)

  curl.return <- rjson::fromJSON(
    RCurl::getURL(
      url.string
    )
  )$celltypes

  if (length(curl.return) > 0) {
    return(curl.return)
  } else {
    stop("No entries found!")
  }
}

appendFilters <- function(url.string, filter_list) {
  if (length(filter_list) > 0) {
    url.string <- paste0(url.string, "/f:")
    url.string <- paste0(url.string, names(filter_list)[1], "=", filter_list[[1]])

    if (length(filter_list) > 1) {
      for (n in names(filter_list)[2:length(names(filter_list))]) {
        url.string <- paste0(url.string, "-", n, "=", filter_list[n])
      }
    }

  }

  return(url.string)
}

#' Returns cell types per species and filter criteria
#'
#' This is a more flexible function, but basically resembles the usability of getAllCelltypesInTissue without the tissue argument.
#' Using the filter_list argument with a "tissue" name can reproduce the getAllCelltypesInTissue function.
#'
#' CAUTION this function returns cell types where positive AND negative markers are known.
#'
#' @param species Name of species
#' @param filter_list Additional filters in list format (i.e: list(stage = "p7")). Wildcards can be added by using a "\%" sign. So, if all embryonic mouse markers are wanted, list like list(stage="E\%") can be used
#' @param server URL of the server hosting the markerDB website.
#' @export
getAllCelltypes <- function(species, filter_list = list(), server = "http://markers.blebli.de") {
  url.string <- paste0(server, "/api/v1.0/species/", tolower(species))

  url.string <- appendFilters(url.string, filter_list)

  url.string <- gsub("%", "%25", url.string)

  curl.return <- rjson::fromJSON(
    RCurl::getURL(
      url.string
    )
  )$celltypes

  return(curl.return)
}

#' Returns celltype predictions for the provided list of genes
#'
#' @param genes Vector with genes (Ensembl IDs)
#' @param species Ensembl name of species (hsapiens_gene_ensembl), necessary for celltype prediction including orthologues
#' @param server URL of the server hosting the markerDB website.
#'
#' @return data.frame with predicted celltypes and p-values.
#' @export
getCelltypeEnrichment <- function(genes, species=NULL, server = "http://markers.blebli.de") {
  if (is.null(species)) {
    url.string <- paste0(server, "/api/v1.0/cellTypeEnrichment")
  } else {
    url.string <- paste0(server, "/api/v1.0/cellTypeEnrichment/", species)
  }

  genes <- list(markers = genes)

  r <- httr::POST("http://markers.blebli.de/api/v1.0/celltypeEnrichment", body=genes, encode = "json")

  res = httr::content(r)

  out <- NULL
  for (i in 1:length(res)) {
    sp <- names(res)[[i]]
    for (j in 1:length(res[[i]])) {
      out <- rbind(out, data.frame(celltype = names(res[[i]])[[j]], p = res[[i]][[j]], species = sp))
    }
  }

  return(out)
}
