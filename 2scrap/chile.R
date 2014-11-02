#	PolBeRG scraping worksho: Chilean elections scraper
#	Juraj Medzihorsky
#	14 March 2014


#	If you would like to use the data contact me at juraj.medzihorsky@gmail.com
#	Luis Schiumerini is using this data in his research, there will be a
#	publication to cite with the data.


library(XML)		# 	for handling tables in HTML
library(stringr)	#	for convenient handling of strings

options(encoding='UTF-8')


#	=====================
#	(1)	get commune codes
#	=====================

#	First get a list of all commune codes from the pages with 
#	alphabetic lists	

#	Prepare links

#	This was the link back in 2013:
#	root <- 'http://www.sitiohistorico.elecciones.gob.cl/SitioHistorico/'

root <- 'http://historico.servel.cl/SitioHistorico/'

com <- c('a-comunas-ac.htm',
         'a-comunas-dl.htm',
         'a-comunas-mp.htm',
         'a-comunas-qz.htm')
		 
com_pages <- paste(root, com, sep='')


#	Function to extract the codes:
#		1)	takes a link to a page as input
#		2)	reads the page as text
#		3)	finds a line with a specified character sequence
#		4)	extracts the desired information (a number) from that line 

get.com.codes <- function(com_page){
	A <- readLines(com_page) 
	a <- grep('javascript:Consulta', A)
	b <- str_extract(A[a], '[0-9]+')
	return(b)	
}


#	Apply the function to the four pages

codes <- unlist(sapply(com_pages, get.com.codes, USE.NAMES=F))

codes


#	====================================
#	(2) Extraction
#	====================================


#	Function to extract the results from a page
#		1)	inputs a link to a page
#		2)	reads the page as a html page, saving only tables
#		3)	if there are more than two tables
#				saves the third table
#		4)	else returns NA

qet.results <- function(this_page){
	P <- readHTMLTable(this_page, encoding='UTF-8')

	if(length(P)>2){
		Y <- P[[3]][, c(1:3, 5)]
		Y[, 1] <- as.character(Y[,1])
		Y[, 3] <- as.numeric(gsub('[.]', '', as.character(Y[,3])))	
		return(Y)
	} else {
		return(NA)
	}
}


#	================

#	blueprint for making links, blocks YYYY, TTTT, and CCCC will
#	get substituted as needed
#		YYYY	...	year
#		TTTT	...	type
#		CCCC	...	code (commune)


blueprint <- 'paginas/YYYY/TTTT/comunas/candidatos/total/CCCC.htm'


#	Types

types <- list(se = 'senadores',
			  di = 'diputados',
			  al = 'alcaldes',
			  co = 'concejales',
			  mu = 'municipales')

#	Years

years <- list(se = c(1989, 1993, 1997, 2001, 2005, 2009),
			  di = c(1989, 1993, 1997, 2001, 2005, 2009),
			  al = c(2004, 2008, 2012),
			  co = c(2004, 2008, 2012),
			  mu = c(1992, 1996, 2000))


#	Directory where the results will go
#		root / type / year / file.csv

root_dir <- 'd:/medzihorskyj/chile'

setwd(root_dir)


#	Now loop for the results
#		1)	create a directory for each type/year
#		2)	for each unique type-year-commune link save a separate file

for(i in 1:5){

	type <- types[[i]]
	b_t <- gsub('TTTT', type, blueprint)

	dir.create(paste(root_dir, type, sep='/'))
	
	for(j in 1:length(years[[i]])){
	
		year <- years[[i]][j]
		b_t_y <- gsub('YYYY', year, b_t)

		
		elec_dir <- paste(root_dir, type, year, sep='/')
		dir.create(elec_dir)
		setwd(elec_dir)
		
		
		for(k in 1:length(codes)){
		
			code <- codes[k]			
			b_t_y_c <- gsub('CCCC', code, b_t_y)

			V <- get.results(paste(root, b_t_y_c, sep='/'))
			
		
			if(is.na(V)==F){		
				
				name <- paste(type, year, code, 'csv', sep='.')
				
				write.table(V, name, row.names=F, sep=',', fileEncoding='UTF-8')
				
			}
		}
	}
}


#	And thats it! A separate script merges the collected results.
#	Well, there is actually a bit more at the end, namely the collection of
#	commune names, which I at first forgot about.


