#	CATA Example
#	Juraj Medzihorsky
#	2014-11-03


my_wd <- '/home/jm/downloads' 

setwd(my_wd)


#	'trimmed.RData' contains a word frequency matrix of several Slovakian
#	party manifestos


load('trimmed.RData')

#	install.packages('ca')

library(ca)


d1 <- ca(A, nd=1) 	#	nd is the number of dimensions to extract
d2 <- ca(A, nd=2) 
d3 <- ca(A, nd=3) 


#	Let's check the structure of the output

str(d2)

#	colcoord are the document positions
#	rowcoord are the word positions


#	Let's plot it first for two dims

par(xpd=T)	#	xpd=T allows text to stick out of the frame
plot(d2$colcoord, type='n', xlab='First dimension', ylab='Second dimension')
text(d2$colcoord, d2$colnames, cex=2, col=rgb(0,0,1,.5))

#	Does it make any sense?
#	Let's plot for three


par(xpd=T, mfrow=c(1, 2))	
plot(d3$colcoord[, 1:2], type='n', xlab='First dimension', ylab='Second dimension')
text(d3$colcoord[, 1:2], d3$colnames, cex=2, col=rgb(0,0,1,.5))
plot(d3$colcoord[, 2:3], type='n', xlab='Second dimension', ylab='Third dimension')
text(d3$colcoord[, 2:3], d3$colnames, cex=2, col=rgb(0,0,1,.5))


#	Let's compare with wordfish

#	install.packages('austin')

library(austin)


#	This is much slower

w1 <- wordfish(A, c(1, 5))	#	c(1, 5) sets the direction from 1st (HZDS) to 5th (SaS)


#	let's plot the results


plot(w1)	# the bars represent uncertainity


#	let's check the numbers

summary(w1)

str(w1)


#	theta are the document positions

w1$theta


#	do they correlate with CA results?

cor(w1$theta, d3$colcoord)

#	Almost perfect correlation with the first dimension from CA 









