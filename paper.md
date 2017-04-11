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
 - name: Arash Hajikhani
   affiliation: 1
affiliations:
 - name: Lappeenranta University of Technology
   index: 1
date: 25 March 2017
---

# Summary

NAILS performs statistical and Social Network Analysis (SNA) on citation data. SNA is a new way for researchers to map large datasets and get insights from new angles by analyzing connections between articles. As the amount of publications grows on any given field [1], automatic tools for this sort of analysis are becoming increasingly important prior to starting research on new fields. NAILS also provides useful data when performing Systematic Mapping Studies (SMS) in scientific literature. A systematic mapping study [2] is a secondary study that aims at classification and thematic analysis of earlier research. The SMS is more general in search terms and aims at classifying and structuring the field of research, while the target of systematic literature review is to summarise and evaluate the research results. According to Kitchenham et al. [3] performing a SMS can be especially suitable if few literature reviews have been done on the topic and there is a need to get a general overview of the field of interest. Both kinds of studies can be used to identify research gaps in the current state of research.

In this paper we present the literature analysis tool NAILS, which uses a series of custom statistical and network analysis functions to give the user an overview of literature datasets. The features can be divided into two primary sections: Firstly, statistical analysis, which for example gives an overview of publication frequencies, most published authors and journals. Secondly, the more novel network analysis, which gives further insight into relationship between the interlinked citations and cooperation between authors. For example, the most basic features can use citation network analysis identify the most cited authors and publication forums. Advanced features support mapping researcher cooperation and citation networks, and finding the core publications in the examined field of science. The tool’s source code is freely available in Github, an open source code repository, and the web-based interface can also be accessed from the [project page] (http://aknutas.github.io/nails/).

You can download, install and use our scripts directly. See steps below.

1. Install RStudio and R. For now the project verifiedly works on R version 3.3.3 and RStudio 1.0.136.
2. Install the following R package dependencies: splitstackshape[4], reshape[5], plyr[6], stringr[7], tm[8], SnowballC[9], lda[10], LDAvis[11], igraph[12]
3. Clone (download) from our [GitHub repository](https://github.com/aknutas/nails) to a folder of your choice.
4. Go to Web of Knowledge [website](http://webofknowledge.com/) and select the Web of Science Core Collection from the dropdown menu.
Search for literature. If you do not have access, check if any of your local universities have public access libraries with access to Web of Knowledge.
5. Download data. Select Save to Other File Formats from the dropdown menu, enter the range of records (max 500 records for one download), and download Full Record and Cited References. File format should be Tab-delimited (Win) or Tab-delimited (Mac). If you need more than 500 records, repeat the download.
6. Put the downloaded files into the input folder.
7. Open exploration.Rmd with RStudio and press Knit HTML -button. The script will combine the downloaded data into a single file, process it and create visualizations. The results are saved as a HTML-file exploration.html.
8. See detailed instructions instructions with screenshots for manual processing steps and installation at https://sites.google.com/site/bibliometricdatavisualization/instructions

For command line Linux usage the script "startnails.sh" is provided in the repository root that first executes analysis script and then the render script. For that knitr[13], markdown[14] and related packages are required. However, RStudio or visual operation is not required.

Alternatively you can upload files to our online analysis server. The service is in early beta testing so we appreciate reporting of issues to the project issues page or as a private Twitter message to [@aknutas](https://twitter.com/aknutas). You can view a brief [video tutorial](https://youtu.be/I1bRXQs_zMk?list=PLJiFJenPKrLOpdu7E1gEhVEAWF7CLQs_2) on how to get started.

# References
[1] Parolo, P. D. B., Pan, R. K., Ghosh, R., Huberman, B. A., Kaski, K., & Fortunato, S. (2015). Attention decay in science. Journal of Informetrics, 9(4), 734-745.

[2] Petersen, K., Feldt, R., Mujtaba, S., & Mattsson, M. (2008). Systematic Mapping Studies in Software Engineering. In EASE (Vol. 8, pp. 68-77).

[3] Kitchenham et al. (2007). Guidelines for performing systematic literature reviews in software engineering. In Technical report, Ver. 2.3 EBSE Technical Report. EBSE.

[4] Ananda Mahto (2014). splitstackshape: Stack and Reshape Datasets After Splitting Concatenated Values. R package version 1.4.2. https://CRAN.R-project.org/package=splitstackshape

[5] H. Wickham. Reshaping data with the reshape package. Journal of Statistical Software, 21(12), 2007.
[6] Hadley Wickham (2011). The Split-Apply-Combine Strategy for Data Analysis. Journal of Statistical Software, 40(1), 1-29. URL http://www.jstatsoft.org/v40/i01/.

[7] Hadley Wickham (2017). stringr: Simple, Consistent Wrappers for Common String Operations. R package version 1.2.0. https://CRAN.R-project.org/package=stringr

[8] Ingo Feinerer, Kurt Hornik, and David Meyer (2008). Text Mining Infrastructure in R. Journal of Statistical Software 25(5): 1-54. URL: http://www.jstatsoft.org/v25/i05/.

[9] Milan Bouchet-Valat (2014). SnowballC: Snowball stemmers based on the C libstemmer UTF-8 library. R package version 0.5.1. https://CRAN.R-project.org/package=SnowballC

[10] Jonathan Chang (2015). lda: Collapsed Gibbs Sampling Methods for Topic Models. R package version 1.4.2. https://CRAN.R-project.org/package=lda
[11] Carson Sievert and Kenny Shirley (2015). LDAvis: Interactive Visualization of Topic Models. R package version 0.3.2. https://CRAN.R-project.org/package=LDAvis

[12] Csardi G, Nepusz T: The igraph software package for complex network research, InterJournal, Complex Systems 1695. 2006. http://igraph.org

[13] Yihui Xie (2016). knitr: A General-Purpose Package for Dynamic Report Generation in R. R package version 1.15.1.

[14] JJ Allaire, Jeffrey Horner, Vicent Marti and Natacha Porte (2015). markdown: 'Markdown' Rendering for R. R package version 0.7.7. https://CRAN.R-project.org/package=markdown
