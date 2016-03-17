
# Helper function to remove leading and trailing whitespace
trim <- function (x) gsub("^\\s+|\\s+$", "", x)

# Helper function to extract DOIs

getDOIs <- function(x) {
    if (length(x) == 2) {
        return(x[2])
    } else {
        return(NA)
    }
}

# Helper function to extract years
getYear <- function(x) {
    year = NA
    if (length(x) > 1) {
        year = as.numeric(x[2])
    }
    return(year)
}

create_network <- function(literature) {
    # Create a new data frame, where each cited reference is in a separate row
    
    # Create data frame: CitedReferences split by ";", each reference on a new row, 
    # id copied to new rows
    
    referencelist <- strsplit(literature$CitedReferences, ";")
    reflengths <- sapply(referencelist, length)
    id <- rep(literature$id, reflengths)
    
    # Extract DOIs from references
    referencelist <- unlist(referencelist)
    referencelist <- trim(referencelist)
    references <- strsplit(referencelist, " DOI ")
    references <- sapply(references, getDOIs)
    
    # Extract publication years of references
    refYear <- strsplit(referencelist, ",")
    refYear <- sapply(refYear, getYear)
    
    # Create data frame with references and ids and merge literature to it
    referencedf <- data.frame(Reference = references, id = id, 
                              FullReference = referencelist)
    referencedf <- merge(referencedf, literature, by = "id")
    
    
    # Create data frame of nodes from references
    citationNodes <- data.frame(Id = referencedf$Reference, 
                                YearPublished = refYear,  
                                FullReference = referencelist,
                                id = NA,
                                PublicationType = NA,
                                AuthorFullName = NA,
                                DocumentTitle = NA,
                                PublicationName = NA,
                                BookSeriesTitle = NA,
                                Language = NA,
                                DocumentType = NA,
                                ConferenceTitle = NA,
                                ConferenceDate = NA,
                                ConferenceLocation = NA,
                                ConferenceSponsors = NA,
                                AuthorKeywords = NA,
                                SubjectCategory = NA,
                                TimesCited = NA,
                                Abstract = NA,
                                DOI = NA,
                                CoreLiterature = FALSE)
    citationNodes$Id <- as.character(citationNodes$Id)
    citationNodes$FullReference <- as.character(citationNodes$FullReference)
    citationNodes$Id[is.na(citationNodes$Id)] <- citationNodes$FullReference[is.na(citationNodes$Id)]
    citationNodes$Origin <- rep("reference", nrow(citationNodes))
    
    # Create data frame of nodes from literature records
    literatureNodes <- data.frame(Id = literature$DOI, 
                                  YearPublished = literature$YearPublished, 
                                  FullReference = literature$ReferenceString)
    literatureNodes <- subset(literature, select = c(DOI,
                                                     YearPublished,
                                                     ReferenceString,
                                                     id,
                                                     PublicationType,
                                                     AuthorFullName,
                                                     DocumentTitle,
                                                     PublicationName,
                                                     BookSeriesTitle,
                                                     Language,
                                                     DocumentType,
                                                     ConferenceTitle,
                                                     ConferenceDate,
                                                     ConferenceLocation,
                                                     ConferenceSponsors,
                                                     AuthorKeywords,
                                                     SubjectCategory,
                                                     TimesCited,
                                                     Abstract,
                                                     DOI,
                                                     CoreLiterature))
    names(literatureNodes)[c(1:3, 20)] <- c("Id", "YearPublished", "FullReference",
                                            "DOI")
    
    #literatureNodes$Id <- literature$DOI
    #literatureNodes$FullReference <- literature$ReferenceString
    literatureNodes$Id <- as.character(literatureNodes$Id)
    literatureNodes$FullReference <- as.character(literatureNodes$FullReference)
    literatureNodes$Id[literatureNodes$Id == ""] <- literatureNodes$FullReference[literatureNodes$Id == ""]
    literatureNodes$Origin <- rep("literature", nrow(literatureNodes))
    
    # Remove reference nodes that appear also in literature data
    citationNodes <- citationNodes[!(citationNodes$Id %in% literatureNodes$Id), ]
    
    # Merge node data frames, remove NAs and duplicates, add Label column
    citationNodes <- rbind(citationNodes, literatureNodes)
    citationNodes <- citationNodes[!is.na(citationNodes$Id), ]
    citationNodes$YearPublished[is.na(citationNodes$YearPublished)] <- ""
    citationNodes <- citationNodes[!duplicated(citationNodes[, "Id"]), ]
    citationNodes$Label <- citationNodes$Id
    
    # Create citations edge table
    
    # Remove NAs from dataframe created in previous step
    #Dreferencedf <- referencedf[!is.na(referencedf$Reference), ]
    #Nreferencedf <- referencedf[is.na(referencedf$Reference), ]
    
    referencedf$ReferenceString <- as.character(referencedf$ReferenceString)
    referencedf$FullReference <- as.character(referencedf$FullReference)
    
    # Create table
    citationEdges <- data.frame(Source = referencedf$DOI, 
                                Target = referencedf$Reference, 
                                id = referencedf$id, 
                                YearPublished = referencedf$YearPublished, 
                                DocumentTitle = referencedf$DocumentTitle)
    citationEdges$Source <- as.character(citationEdges$Source)
    citationEdges$Target <- as.character(citationEdges$Target)
    
    noSource <- citationEdges$Source == ""
    noTarget <- is.na(citationEdges$Target)
    citationEdges$Source[noSource] <- referencedf$ReferenceString[noSource]
    citationEdges$Target[noTarget] <- referencedf$FullReference[noTarget]
    
    return(list(citationNodes, citationEdges))
}




