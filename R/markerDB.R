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

