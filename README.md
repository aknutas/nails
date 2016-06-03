nails
=====

**Network Analysis Interface for Literature Studies**  
by _Juho Salminen, Arash Hajikhani and Antti Knutas_  
at _Lappeenranta University of Technology_

What Is It?
----
This site shares our experiments and tools for performing Social Network Analysis (SNA) on citation data. As the amount of publications grows on any given field, automatic tools for this sort of analysis are becoming increasingly important prior to starting research on new fields.

SNA is an interesting way for researchers to map large datasets and get insights from new angles. The steps for downloading data from Web of Knowledge and using our tools to process it are detailed below. The set of tools which are required to perform the analyses are free and need a minimum amount of installation. Furthermore, we will soon make a web-based analysis server HAMMER available so that you can process the data without needing to do any installation or manual processing steps.

The project files are available as open source here in our [Github repository](https://github.com/aknutas/nails). If you link or refer to us, please link to our [project page](http://aknutas.github.io/nails/).

How to Use
----

These scripts can be used to complete an exploratory literature review
using data downloaded from Web of Knowledge.

1. Go to Web of Knowledge website and select Web of Science Core Collection 
from the dropdown menu. 
2. Search for literature.
3. Download data. Select Save to Other File Formats from the dropdown menu, 
enter the range of records (max 500 records for one download), and download 
Full Record and Cited References. File format should be Tab-delimited (Win) or
Tab-delimited (Mac). If you need more than 500 records, repeat the download.
4. Put the downloaded files into the input folder.
5. Open exploration.Rmd with RStudio and press Knit HTML -button. 
The script will combine the downloaded data into a single file, process it and
create visualizations. The results are saved as a HTML-file exploration.html.


The script also creates node and edge tables for author and citation 
networks that can be loaded to Gephi for further exploration.  

See further instructions for manual usage at https://sites.google.com/site/bibliometricdatavisualization/instructions

Requirements
----
For now the project verifiedly works on R version 3.2.0.
