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

Science!
----
The basic design and bibliometric principles of the system have been published in a research article:

Antti Knutas, Arash Hajikhani, Juho Salminen, Jouni Ikonen, and Jari Porras. 2015. _Cloud-Based Bibliometric Analysis Service for Systematic Mapping Studies_. In Proceedings of the 16th International Conference on Computer Systems and Technologies (CompSysTech '15). DOI: 10.1145/2812428.2812442

A preprint version of the article is [available for download](http://www.codecamp.fi/lib/exe/fetch.php/wiki/nails-compsystech2015-preprint.pdf) as PDF. The official version is now available at the [ACM Digital Library](http://dl.acm.org/citation.cfm?doid=2812428.2812442).

If you use the software in your scientific work, please consider citing us.

How to Use
----

These scripts can be used to complete an exploratory literature review
using data downloaded from Web of Knowledge. You can follow the steps below or view a brief [video tutorial](https://youtu.be/I1bRXQs_zMk?list=PLJiFJenPKrLOpdu7E1gEhVEAWF7CLQs_2) on how to get started.

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

See further instructions for manual usage at https://sites.google.com/site/bibliometricdatavisualization/instructions or follow the [video tutorial](https://youtu.be/I1bRXQs_zMk?list=PLJiFJenPKrLOpdu7E1gEhVEAWF7CLQs_2).

Requirements
----
For now the project verifiedly works on R version 3.2.0.

We are open source and free software
----
This program is [free software](https://www.gnu.org/philosophy/free-sw.html): you can redistribute it and/or modify it under the terms of the [GNU General Public License](https://www.gnu.org/licenses/quick-guide-gplv3.html) as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. See LICENSE file for more information.

What does it mean? We are free as in freedom. You may run the software as you wish, for any purpose; you are free to study how the program works, and change it as you wish; you are free to redistribute copies; and you are free to distribute copies of modified versions to others. You may not distribute this software in a non-free manner or add additional restrictions. The only limitations are that you have to follow the free software license, retain the original copyright notices and acknowledgement texts in the program output (section 7b). See links above for more information. If you edit and improve the software, we would love to hear back from you.
