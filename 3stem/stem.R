#	Text to Word Frequency Matrix example
#	Juraj Medzihorsky
#	2014-11-02


#	where are we now?

getwd()


#	where's the text?

text_dir <- paste(getwd(), 'text', sep='/')


#	let's go there

setwd(text_dir)


#	what's there?

dir()

#	we can load in a text as a character vector

t1 <- readLines(dir()[1])

length(t1)	#	316 rows

#	let's check the 16th one

t1[16]

#	how many characaters does it have?

nchar(16)



#	now let's make a word frequencies matrix

#	tm and austin libraries needed

library(tm)


#	options for reading the documents

reader_options <- list(reader=readPlain,
					   language="en",
					   load=FALSE)


#	options for counting the words
#	tolower	... all in lower case
#	removeNumbers	... ignore numbers
#	removePunctuation	... ignore punctuation
#	stopwords	...	ignore stopwords
#	stemming	...	words to stems

filter_options <- list(tolower,
					   removeNumbers=TRUE,
					   removePunctuation=TRUE,
					   stopwords=TRUE,
					   stemming=TRUE)


corpus <- Corpus(DirSource(text_dir), readerControl=reader_options)


library(austin)

M <- as.wfm(as.matrix(TermDocumentMatrix(corpus, control=filter_options)), 1)


#	how big is it?

dim(M)

#	documents are columns


#	let's check the first ten rows

M[1:10, ]

#	the end, now's the time for CATA
