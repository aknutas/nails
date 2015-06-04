
# Load required libraries
library(splitstackshape)
library(reshape)
suppressPackageStartupMessages(library(plyr))
library(stringr)

# Set working directory to folder containing folders named "input" and "output.
# Input folder should contain full records and citations downloaded from 
# Web of knowledge in tab-delimited (UTF-16) format. Working directory should 
# contain the list of fieldtags for naming the variables (fieldtags.csv).
###############################################################################

# Load variable names
fieldtags <- read.csv("fieldtags.csv", header = T, 
                      sep = ";")

# List files in input folder
filelist <- list.files("input", full.names = T)

# Remove possible old literature data frame
rm(literature)

# Load files in the input folder and merge into a single file
for (file in filelist) {
    if (!exists("literature")) {
        literature <- read.delim2(file, header = T, 
                                  fileEncoding = "UTF-16", row.names = NULL, 
                                  quote = "")
        # Fix misplaced column names
        data.names <- names(literature)[2:length(names(literature))]
        literature <- literature[, 1:(ncol(literature) - 1)]
        names(literature) <- data.names
    }
    else {
        literature2 <- read.delim2(file, header = T, 
                                   fileEncoding = "UTF-16", row.names = NULL, 
                                   quote = "")
        # Fix misplaced column names
        data.names <- names(literature2)[2:length(names(literature2))]
        literature2 <- literature2[, 1:(ncol(literature2) - 1)]
        names(literature2) <- data.names
        # Merge data
        literature <- rbind(literature, literature2)
    }
}

# Add id variable
id <- c(1:nrow(literature))
ids <- data.frame(id = id)
literature = cbind(ids, literature)

###############################################################################

# Cleaning data

# Fix variable names
tags <- names(literature)
fields <- as.character(fieldtags$field[match(tags, fieldtags$tag)])
fields[is.na(fields)] <- tags[is.na(fields)]     # Throws warnings but seems to be working
fields <- gsub(" ", "", fields)
names(literature) <- fields
names(literature)[22] <- "KeywordsPlus"
names(literature)[2] <- "PublicationType"
names(literature)[41] <- "SourceAbbreviation"
names(literature)[54] <- "DOI"

# Helper function to remove leading and trailing whitespace
trim <- function (x) gsub("^\\s+|\\s+$", "", x)

# Fixing variable types
literature$AuthorFullName <- as.character(literature$AuthorFullName)
literature$AuthorFullName <- toupper(literature$AuthorFullName)
literature$AuthorFullName <- gsub("'", "", literature$AuthorFullName)
literature$AuthorFullName <- gsub('"', "", literature$AuthorFullName)

literature$Authors <- as.character(literature$Authors)

literature$AuthorKeywords <- as.character(literature$AuthorKeywords)
literature$AuthorKeywords <- tolower(literature$AuthorKeywords)
literature$AuthorKeywords <- gsub("'", "", literature$AuthorKeywords)
literature$AuthorKeywords <- gsub('"', "", literature$AuthorKeywords)

literature$YearPublished <- as.numeric(as.character(literature$YearPublished))

literature$DocumentTitle <- gsub("'", "", literature$DocumentTitle)
literature$DocumentTitle <- gsub('"', "", literature$DocumentTitle)

literature$SubjectCategory <- as.character(literature$SubjectCategory)
literature$SubjectCategory <- tolower(literature$SubjectCategory)
literature$SubjectCategory <- gsub("'", "", literature$SubjectCategory) 
literature$SubjectCategory <- gsub('"', "", literature$SubjectCategory) 

literature$CitedReferences <- as.character(literature$CitedReferences)
literature$CitedReferences <- gsub("'", "", literature$CitedReferences)
literature$CitedReferences <- gsub('"', "", literature$CitedReferences)
literature$CitedReferences <- toupper(literature$CitedReferences)
literature$CitedReferences <- gsub("DOI DOI", "DOI", literature$CitedReferences)
literature$TimesCited <- as.numeric(as.character(literature$TimesCited))

literature$DOI <- toupper(literature$DOI)
# Creating reference strings

# Helper function to construct strings
makeRef <- function(x) {
    refstring <- getName(x)
    if (!is.na(x["YearPublished"])) {
        refstring <- paste(refstring, x["YearPublished"], sep = ", ")
    }
    if (x["SourceAbbreviation"] != "") {
        refstring <- paste(refstring, x["SourceAbbreviation"], sep = ", ")
    }
    if (!is.na(x["Volume"])) {
        refstring <- paste(refstring, ", V", x["Volume"], sep = "")
    }
    if (!is.na(x["BeginningPage"])) {
        refstring <- paste(refstring, ", P", x["BeginningPage"], sep = "")
    }
    if (x["DOI"] != "") {
        refstring <- paste(refstring, ", DOI ", x["DOI"], sep = "")
    }
    return(refstring)
}

# Helper function to extract the name of first author
getName <- function(x) {
    name = NA
    try( {
        names <- unlist(strsplit(x["AuthorFullName"], ";"))
        names <- names[1]
        names <- unlist(strsplit(names, " "))
        name <- names[1]
        name <- gsub(",", "", name)
        if (length(names) > 1) {
            name <- paste(name, substring(names[2], 1, 1))
        }
        if (length(names) > 2) {
            name <- paste(name, substring(names[3], 1, 1), sep = "")
        } 
    } )
    return(name)
}

# Add variable ReferenceString to literature.
# Information of a record in same format as in CitedReferences
literature$ReferenceString <- apply(literature, 1, makeRef)

# Remove duplicates
literature <- literature[!duplicated(literature[, "ReferenceString"]), ]

# Save the literature as a single csv-file literature.csv.
write.table(literature, "output/literature.csv", 
            sep = ";", row.names = F, qmethod = "double")

###############################################################################

# Create a new data frame, where each author is in a separate row

# Subset data
literatureByAuthor = subset(literature, 
                            select = c("AuthorFullName", "id"))
# Remove NAs
literatureByAuthor <- literatureByAuthor[
    !is.na(literatureByAuthor$AuthorFullName),]
# Create data frame: AuthorFullName split by ";", each name on a new row, 
# id copied to new rows
literatureByAuthor <- cSplit(literatureByAuthor, 
                                            splitCols = "AuthorFullName", 
                                            sep = ";", direction = "long")
# Removing rows with NA as author name created in previous step
literatureByAuthor <- literatureByAuthor[
    !is.na(literatureByAuthor$AuthorFullName),]
# Drop weird extra column created in previous step
literatureByAuthor <- subset(literatureByAuthor, 
                             select = c("id", "AuthorFullName"))
# Merge the rest of the data by id
literatureByAuthor <- merge(literatureByAuthor, literature[,-7], 
                            by = "id")
# Save file
write.table(literatureByAuthor, "output/literature_by_author.csv", 
            row.names = F, sep = ';', qmethod = "double")

###############################################################################

# Create a new data frame, where each keyword is in a separate row.
# Same functionality as with the author names, see above.

literatureByKeywords <- subset(literature, 
                               select = c("AuthorKeywords", "id"))
literatureByKeywords <- literatureByKeywords[
    !is.na(literatureByKeywords$AuthorKeywords),]
literatureByKeywords <- literatureByKeywords[
    literatureByKeywords$AuthorKeywords != "", ]
if (nrow(literatureByKeywords) > 0) {
  literatureByKeywords <- cSplit(literatureByKeywords, 
                                 splitCols = "AuthorKeywords", 
                                 sep = ";", direction = "long")
  literatureByKeywords <- literatureByKeywords[
    !is.na(literatureByKeywords$AuthorKeywords),]
  literatureByKeywords <- subset(literatureByKeywords, 
                                 select = c("id", "AuthorKeywords"))
  literatureByKeywords <- merge(literatureByKeywords, literature[,-21], 
                                by = "id")
}

# Save file
write.table(literatureByKeywords, "output/literature_by_keywords.csv", 
            row.names = F, sep = ';', qmethod = "double")

###############################################################################

# Create new data frame, where each subject category is in a separate row.
# Same functionality as with the author names, see above.

literatureByCategory <- subset(literature, 
                               select = c("SubjectCategory", "id"))

literatureByCategory <- literatureByCategory[
    !is.na(literatureByCategory$SubjectCategory),]
literatureByCategory <- literatureByCategory[
    literatureByCategory$SubjectCategory != "", ]
literatureByCategory <- cSplit(literatureByCategory, 
                                              splitCols = "SubjectCategory", 
                                              sep = ";", direction = "long")
literatureByCategory <- literatureByCategory[
    !is.na(literatureByCategory$SubjectCategory),]
literatureByCategory <- subset(literatureByCategory, 
                               select = c("id", "SubjectCategory"))
literatureByCategory <- merge(literatureByCategory, literature[,-58], 
                              by = "id")
literatureByCategory$SubjectCategory <- trim(literatureByCategory$SubjectCategory) 

# Save file
write.table(literatureByCategory, "output/literature_by_subject.csv", 
            row.names = F, sep = ';', qmethod = "double")

###############################################################################

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



###############################################################################

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
                            FullReference = referencelist)
citationNodes$Id <- as.character(citationNodes$Id)
citationNodes$FullReference <- as.character(citationNodes$FullReference)
citationNodes$Id[is.na(citationNodes$Id)] <- citationNodes$FullReference[is.na(citationNodes$Id)]
citationNodes$Origin <- rep("reference", nrow(citationNodes))

# Create data frame of nodes from literature records
literatureNodes <- data.frame(Id = literature$DOI, 
                              YearPublished = literature$YearPublished, 
                              FullReference = literature$ReferenceString)
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


# Save node table
write.table(citationNodes, "output/citation_nodes.csv", 
            sep = ';', row.names = F)

###############################################################################
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

# Save citaion edge table
write.table(citationEdges, "output/citation_edges.csv", 
            sep = ';', row.names = F)

###############################################################################

# Create node and edge tables for author network

# Calculating total number of citations for each author
citationSums <- aggregate(literatureByAuthor$TimesCited, 
                          by = list(AuthorFullName = toupper(literatureByAuthor$AuthorFullName)), 
                          FUN = sum)

# Fixing column names
names(citationSums) <- c("AuthorFullName", "TotalTimesCited")

# Creating new data frame to plot citations by author

# Extract author names 
authorNames <- unlist(strsplit(literature$AuthorFullName, ";"))
authorNames <- trim(authorNames)
# Count author name frequencies
authors <- table(authorNames)
# Transform to a data frame
authors <- as.data.frame(authors)
# Merge with data frame containing the total times citated by each author
authors <- merge(authors, citationSums, by.x = "authorNames", 
                 by.y = "AuthorFullName" )
# Fix column name
names(authors)[1] <- "AuthorFullName" 

# Remove leading and trailing whitespace
authors$AuthorFullName <- trim(authors$AuthorFullName)

# Fix variable names and add Label column
names(authors)[1] <- "Id"
authors$Label <- authors$Id

# Save author node table
write.table(authors, "output/author_nodes.csv", 
            sep = ';', quote = F, row.names = F)

# Helper functions for extracting edges

# Paste two nodes together
Collapser <- function(node){
    x <- paste(node, collapse = ';')
}

# Create node from a string containing author names of a paper
CreateNodes <- function(x){
    nodes <- strsplit(x, ';')
    if(length(unlist(nodes)) > 1){
        nodes <- combn(unlist(nodes), 2, simplify = F)
        nodes <- lapply(nodes, Collapser)
    } else{nodes <- NA}
    return(nodes)
}

# Count the length of nodes created from each row
authors <- strsplit(literature$AuthorFullName, ";")
authors <- lapply(literature$AuthorFullName, CreateNodes)
nodelengths <- sapply(authors, length)

# Create nodes and put into a data frame
nodes <- unlist(lapply(literature$AuthorFullName, CreateNodes))
nodes <- as.data.frame(nodes)
nodes <- as.data.frame(str_split_fixed(nodes$nodes, ";", 2))

# Fix column names
names(nodes) <- c("Source", "Target")

# Create id and edge type columns
nodes$id <- rep(literature$id, nodelengths)
nodes$Type <- rep("Undirected", nrow(nodes))

# Remove NAs from Source column
nodes <- nodes[!is.na(nodes$Source), ]

# Remove leading and trailing whitespace from Sources and Targets
nodes$Source <- trim(nodes$Source)
nodes$Target <- trim(nodes$Target)

# Merge with literature
nodes <- merge(nodes, literature[, -c(3, 7)], by = "id", )

# Subset data. Use this to select columns to include in network data
nodes <- subset(nodes, 
                select = c("Source", "Target", "Type", "id",          # Don't change
                           "YearPublished", "DocumentTitle", "DOI",   # Change
                           "TimesCited"))                                  

# Save author edge table
write.table(nodes, "output/author_edges.csv", 
            sep = ';', row.names = F)


