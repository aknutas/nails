# Network Analysis Interface for Literature Studies
# Copyright (C) 2017 Lappeenranta University of Technology and Juho Salminen
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

options(stringsAsFactors = FALSE)

# Load required libraries
library(plyr)
library(splitstackshape)

# List files in input folder
file_list <- list.files("input", full.names = TRUE)

# Read and combine files
literature <- ldply(file_list, read.csv, header=TRUE, sep=",")

# Add id variable
literature$id <- c(1:nrow(literature))

# Helper function to remove leading and trailing whitespace
trim <- function (x) gsub("^\\s+|\\s+$", "", x)

# Clean variables
literature$Authors <- toupper(literature$Authors)
literature$Authors <- gsub("'", "", literature$Authors)
literature$Authors <- gsub('"', "", literature$Authors)

literature$Author.Keywords <- tolower(literature$Author.Keywords)
literature$Author.Keywords <- gsub("; ", ";", literature$Author.Keywords)

literature$Index.Keywords <- tolower(literature$Index.Keywords)
literature$Index.Keywords <- gsub("; ", ";", literature$Index.Keywords)

literature$References <- toupper(literature$References)

# Change NAs to zeros
literature$Cited.by[is.na(literature$Cited.by)] <- 0

# Create reference string
# SURNAME, L., SURNAME, A., TITLE (YEAR) JOURNAL NAME, vol (issue), PP. startpage-endpage

makeRef <- function(x) {
    reference <- x["Authors"]
    if (x["Title"] != "") {
        reference <- paste(reference, ", ", x["Title"], sep = "")
    }
    if (!is.na(x["Year"])) {
        reference <- paste(reference, " (", x["Year"], ")", sep = "")
    }
    if (x["Source.title"] != "") {
        reference <- paste(reference, ", ", x["Source.title"], sep = "")
    }
    if (!is.na(x["Volume"])) {
        reference <- paste(reference, ", ", x["Volume"], sep = "")
    }
    if (x["Issue"] != "") {
        reference <- paste(reference, " (", x["Issue"], ")", sep = "")
    }
    if (x["Page.start"] != "" & x["Page.end"] != "") {
        reference <- paste(reference, ", PP. ", x["Page.start"], "-",
                           x["Page.end"], sep = "")
    }
    reference <- toupper(reference)
    return(reference)
}

# Add variable ReferenceString to literature.
# Information of a record in same format as in CitedReferences
literature$ReferenceString <- apply(literature, 1, makeRef)

# Remove duplicates
literature <- literature[!duplicated(literature[, "ReferenceString"]), ]

# Save the literature as a single csv-file literature.csv.
write.table(literature, "output/literature.csv",
            sep = ";", row.names = F, qmethod = "double")

################################################################################

# Create a new data frame, where each author is in a separate row

# Subset data
literatureByAuthor = subset(literature,
                            select = c("Authors", "id"))

# Create data frame: Authors split by ";", each name on a new row,
# id copied to new rows
literatureByAuthor <- cSplit(literatureByAuthor,
                                            splitCols = "Authors",
                                            sep = ",", direction = "long")

# Merge the rest of the data by id
literatureByAuthor <- merge(literatureByAuthor, literature[,-1],
                            by = "id")
# Save file
write.table(literatureByAuthor, "output/literature_by_author.csv",
            row.names = F, sep = ';', qmethod = "double")

################################################################################

# Create a new data frame, where each keyword is in a separate row.
# Same functionality as with the author names, see above.

literatureByKeywords <- subset(literature,
                               select = c("Author.Keywords", "id"))
# Remove NAs and empty keywords
literatureByKeywords <- literatureByKeywords[
    !is.na(literatureByKeywords$Author.Keywords),]
literatureByKeywords <- literatureByKeywords[
    literatureByKeywords$Author.Keywords != "", ]

# Create data frame: Author.Keywords split by ";", each name on a new row,
# id copied to new rows
literatureByKeywords <- cSplit(literatureByKeywords,
                                              splitCols = "Author.Keywords",
                                              sep = ";", direction = "long")

# Merge the rest of the data by id
literatureByKeywords <- merge(literatureByKeywords, literature[,-17],
                              by = "id")
# Save file
write.table(literatureByKeywords, "output/literature_by_keywords.csv",
            row.names = F, sep = ';', qmethod = "double")

###############################################################################

# Create new data frame, where each index keyword is in a separate row.
# Same functionality as with the author names, see above.

literatureByIndex <- subset(literature,
                               select = c("Index.Keywords", "id"))

# Remove NAs and empty keywords
literatureByIndex <- literatureByIndex[
    !is.na(literatureByIndex$Index.Keywords),]
literatureByIndex <- literatureByIndex[
    literatureByIndex$Index.Keywords != "", ]

# Create data frame: Index.Keywords split by ";", each name on a new row,
# id copied to new rows
literatureByIndex <- cSplit(literatureByIndex, splitCols = "Index.Keywords",
                                              sep = ";", direction = "long")

# Merge to the rest of the data
literatureByIndex <- merge(literatureByIndex, literature[,-18],
                              by = "id")

# Save file
write.table(literatureByIndex, "output/literature_by_index.csv",
            row.names = F, sep = ';', qmethod = "double")

###############################################################################

# Create a new data frame, where each cited reference is in a separate row

# Create data frame: References split by ";", each reference on a new row,
# id copied to new rows
references <- subset(literature, select = c("References", "id"))
names(references) <- c("Reference", "id")
references <- cSplit(references, splitCols = "Reference", sep = ";",
                    direction = "long")

# Merge to literature data
references <- merge(references, literature, by = "id")
references$Reference <- as.character(references$Reference)

# Helper function to extract years from references
getYear <- function(x) {
    year <- NA
    try( {
        year <- sub("\\).*", "", x)
        year <- as.numeric(sub(".*\\(", "", year))
    })
    return(year)
}

# Extract publication years of references
refYear <- sapply(references$Reference, getYear)

# Create data frame of nodes from references
citationNodes <- data.frame(Id = references$Reference,
                            Year = refYear)

citationNodes$Origin <- rep("reference", nrow(citationNodes))

# Create data frame of nodes from literature records
literatureNodes <- data.frame(Id = literature$ReferenceString,
                              Year = literature$Year)
literatureNodes$Origin <- rep("literature", nrow(literatureNodes))

# Remove reference nodes that appear also in literature data
citationNodes <- citationNodes[!(citationNodes$Id %in% literatureNodes$Id), ]

# Merge node data frames, remove NAs and duplicates, add Label column
citationNodes <- rbind(citationNodes, literatureNodes)
citationNodes$Year[is.na(citationNodes$Year)] <- ""
citationNodes <- citationNodes[!duplicated(citationNodes[, "Id"]), ]
citationNodes$Label <- citationNodes$Id


# Save node table
write.table(citationNodes, "output/citation_nodes.csv",
            sep = ';', row.names = F)

###############################################################################
# Create citations edge table

# Create table
citationEdges <- data.frame(Source = references$ReferenceString,
                            Target = references$Reference,
                            id = references$id,
                            Year = references$Year,
                            Title = references$Title)
citationEdges$Source <- as.character(citationEdges$Source)
citationEdges$Target <- as.character(citationEdges$Target)

# Save citaion edge table
write.table(citationEdges, "output/citation_edges.csv",
            sep = ';', row.names = F)
