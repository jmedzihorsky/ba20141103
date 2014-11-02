#	PolBeRG scraping workshop
#	Head-Fi
#	ljokerl headphonelist scraper
#	Juraj Medzihorsky
#	14 March 2014


library(XML)


#	headphonelist version of the table link
#	t_link <- 'http://theheadphonelist.com/'

t_link <- 'http://web.archive.org/web/20130326035242/http://theheadphonelist.com/'


#	===================
#	Table
#	===================

a <- readLines(t_link)


A <- readHTMLTable(a)


typeof(a)
typeof(A)


length(a)
length(A)



sapply(A, dim)

A1 <- A[[4]]
A4 <- A[[7]]

colnames(A1) <- colnames(A4) <- NULL



vars <- c('model', 'headset', 'accessories', 'build', 'isolation', 
		  'microphonics', 'comfort', 'sound', 'average', 'price')

colnames(A1) <- colnames(A4) <- vars


A1[20, ]	#	this is with variable descriptions in rows 1:4
A4[20, ]


A4$price <- as.numeric(gsub('[$]', '', A4$price))


plot(as.numeric(A4$price), A4$sound, col='blue', pch=20, frame=F)	


plot(log(A4$price), A4$average, col='blue', pch=20, frame=F)	


cor(log(A4$price), as.numeric(A4$average))


#	Thats it.
