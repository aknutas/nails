---
title: 'nails: Network Analysis Interface for Literature Studies'
tags:
  - systematic mapping study
  - literature review
  - bibliometric analysis
  - citation analysis
  - social network analysis
  - R
authors:
 - name: Juho Salminen
   orcid: 0000-0003-0688-2211
 - name: Antti Knutas
   orcid: 0000-0002-6953-0021
   affiliation: 1
 - name: Arash hajikhani
   affiliation: 1
affiliations:
 - name: Lappeenranta University of Technology
   index: 1
date: 25 March 2017
---

# Summary

NAILS performs statistical and Social Network Analysis (SNA) on citation data. SNA is a new way for researchers to map large datasets and get insights from new angles by analyzing connections between articles. As the amount of publications grows on any given field [1], automatic tools for this sort of analysis are becoming increasingly important prior to starting research on new fields. NAILS also provides useful data when performing systematic mapping studies in scientific literature.

We present the literature analysis tool NAILS, which uses a series of custom statistical and network analysis functions to give the user an overview of literature datasets. The features can be divided into two primary sections: Firstly, statistical analysis, which for example gives an overview of publication frequencies, most published authors and journals. Secondly, the more novel network analysis, which gives further insight into relationship between the interlinked citations and cooperation between authors. For example, the most basic features can use citation network analysis identify the most cited authors and publication forums. Advanced features support mapping researcher cooperation and citation networks, and finding the core publications in the examined field of science. The tool’s source code is freely available in Github, an open source code repository, and the web-based interface can also be accessed from the [project page] (http://aknutas.github.io/nails/).

You can download, install and use our scripts directly. See steps below.

1. Install RStudio and R. For now the project verifiedly works on R version 3.3.3 and RStudio 1.0.136.
2. Install the following R packages: splitstackshape, reshape, plyr, stringr, tm, SnowballC, lda, LDAvis, igraph
3. Clone (download) from our [GitHub repository](https://github.com/aknutas/nails) to a folder of your choice.
4. Go to Web of Knowledge [website](http://webofknowledge.com/) and select the Web of Science Core Collection from the dropdown menu.
Search for literature. If you do not have access, check if any of your local universities have public access libraries with access to Web of Knowledge.
5. Download data. Select Save to Other File Formats from the dropdown menu, enter the range of records (max 500 records for one download), and download Full Record and Cited References. File format should be Tab-delimited (Win) or Tab-delimited (Mac). If you need more than 500 records, repeat the download.
6. Put the downloaded files into the input folder.
7. Open exploration.Rmd with RStudio and press Knit HTML -button. The script will combine the downloaded data into a single file, process it and create visualizations. The results are saved as a HTML-file exploration.html.
8. See detailed instructions instructions with screenshots for manual processing steps and installation at https://sites.google.com/site/bibliometricdatavisualization/instructions

Alternatively you can upload files to our online analysis server. The service is in early beta testing so we appreciate reporting of issues to the project issues page or as a private Twitter message to [@aknutas](https://twitter.com/aknutas). You can view a brief [video tutorial](https://youtu.be/I1bRXQs_zMk?list=PLJiFJenPKrLOpdu7E1gEhVEAWF7CLQs_2) on how to get started.

# References
[1] Parolo, P. D. B., Pan, R. K., Ghosh, R., Huberman, B. A., Kaski, K., & Fortunato, S. (2015). Attention decay in science. Journal of Informetrics, 9(4), 734-745.
