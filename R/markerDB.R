getSpecies <- function(){
  json_data = rjson::fromJSON(
    RCurl::getURL("http://markers.blebli.de/api/v1.0/species")
  )

  return(tolower(json_data))
}

getSpeciesInfo <- function(species){
  if(tolower(species) %in% tolower(getSpecies())){
    json_data = rjson::fromJSON(
      RCurl::getURL(paste0("http://markers.blebli.de/api/v1.0/species/", species))
    )
    return(json_data)
  }else{
    print(paste0(species, " not in the database!"))
    return(NULL)
  }
}

getSpeciesCellTypeInfo <- function(species,
                                   celltype){

  speciesInfo <- getSpeciesInfo(species)

  if(is.null(speciesInfo)){
    stop("Use another species, or find annotated species using getSpecies function.")
  }else{
    if(tolower(celltype) %in% tolower(speciesInfo$celltypes)){
      ct.info <- rjson::fromJSON(
        RCurl::getURL(paste0("http://markers.blebli.de/api/v1.0/species/", species, "/", celltype))
      )

      return(ct.info)
    }else{
      stop(paste0("No informations about ", celltype, " in ", species))
    }
  }
}

parseSpeciesCellTypeInfo <- function(species,
                                     celltype){
  rawInfo <- getSpeciesCellTypeInfo(species, celltype)

  out.df <- data.frame()
  for(i in 1:length(rawInfo)){
    out.df <- rbind(out.df, data.frame(rawInfo[[i]]))
  }

  return(out.df)
}


findCellTypes <- function(celltype, species){
  speciesInfo <- getSpeciesInfo(species)
  annot.cts <- speciesInfo$celltypes

  return(grep(tolower(celltype), tolower(annot.cts), value = T))
}


getMarkerGenes <- function(celltype, species, field = c("marker_accession", "marker_name"), positive = TRUE, filter_list = list()){

  if(length(field) > 1){
    field <- field[1]
  }

  url.string <- paste0("http://markers.blebli.de/api/v1.0/species/",species,"/",celltype,"/v:",field,"/f:positive=",as.character(as.numeric(positive)))

  if(length(filter_list) > 0){
    for(n in names(filter_list)){
      url.string <- paste0(url.string, "-", n, "=", filter_list[n])
    }
  }

  marker.genes <- rjson::fromJSON(
    RCurl::getURL(
        url.string
      )
    )

  return(marker.genes)
}


getAllCelltypesInTissue <- function(tissue, species){
  spec.info <- getSpeciesInfo(species)

  cts <- spec.info$celltypes

  out.cts <- NULL
  for(ct in cts){
    print(paste0("Checking ", ct))
    info <- getSpeciesCellTypeInfo(species, ct)[[1]]
    celltype <- info$celltype
    ts <- info$tissue


    if(ts == tissue){
      if(!(celltype %in% out.cts)){
        out.cts <- c(out.cts, celltype)
      }
    }


  }

  return(out.cts)
}