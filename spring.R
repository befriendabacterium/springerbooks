# START -------------------------------------------------------------------
rm(list=ls())
set.seed(1234)
setwd("~/springerbooks")

# LOAD PACKAGES -----------------------------------------------------------

#install.packages('pdftools')
library(pdftools)
#install.packages('XML')
library(XML) # HTML processing
#install.packages('RCurl')
library(RCurl)
#install.packages('rvest')
library(rvest)

# DOWNLOAD PDFS -----------------------------------------------------------
download.folder = getwd()
download.folder

pdf='springerz.pdf' #name of report PDF to be processed - should be a report over 3 pages long that includes local-level graphs (e.g. Great Britain report)
extracted_text<-pdf_text(pdf)
extracted_text<-unlist(strsplit(extracted_text,'\n'))

splittext<-unlist(strsplit(extracted_text," ",""))
splittext

urls<-splittext[grepl('http',splittext)]

for (u in 1:length(urls)){
  base.url<-urls[u]
  urlcurrent<-read_html(base.url)
  parsed<-htmlParse(urlcurrent)
  doc.links<-xpathSApply(parsed,path = "//a",xmlGetAttr,"href")
  pdf.url <- as.character(doc.links[grep('pdf', doc.links)])[1]
  pdf.url<-paste("https://link.springer.com", pdf.url, sep="")
  download.file(pdf.url, paste(u,'.pdf',sep=''), method = 'auto', quiet = FALSE, mode = "w",
                cacheOK = TRUE, extra = getOption("download.file.extra"))
  print(paste(u,'/',length(urls),sep=''))
}

