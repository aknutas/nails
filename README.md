nails
=====

**Network Analysis Interface for Literature Studies**  
by _Juho Salminen, Arash Hajikhani and Antti Knutas_  
at _Lappeenranta University of Technology_


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

