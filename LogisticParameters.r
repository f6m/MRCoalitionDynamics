# Graficamos la ecuacion logistica:
# curve(.4 / (1+790.3*exp(-1.001*x)), from=1, to=50, xlab="x", ylab="y")

#eq <- function(x){ 2.4/(1+0.3*exp(-x) }
#plot(eq(1:1000), type='l')
#curve(logistic(x),add=TRUE)

#Let's assume you have a vector of "average values" avg 
#and another vector of "standard deviations" sdev, they are of the same length n. Let's make the abscissa just the number of these "measurements", so x <- 1:n. Using these, here come the plotting commands:
#ver https://stackoverflow.com/questions/13032777/scatter-plot-with-error-bars

# Line types http://www.sthda.com/english/wiki/line-types-in-r-lty
# Log-log plots http://sphaerula.com/legacy/R/logLogPlots.html
# Fitting curves: https://stackoverflow.com/questions/14190883/fitting-a-curve-to-specific-data
# Interactive R :  https://www.datacamp.com/community/tutorials/15-questions-about-r-plots

# Several funcitons in plot: https://www.sixhat.net/plotting-multiple-data-series-in-r.html
# Size: https://plot.ly/r/setting-graph-size/

#Libreria para plotCI
library(plotrix)

#N= 75 
curve(.51 / (1+exp(9*(x-0.33))), from=0.001, to=1.0, xlab="I", ylab="D")

#N= 100 
par(new = TRUE)
curve(.54 / (1+exp(11*(x-0.232))),0.001,1.0,xlab="", ylab="",xaxt='n',yaxt='n',lty="twodash")

#N= 115
par(new = TRUE)
curve(.51 / (1+exp(14.2*(x-0.227))),0.001,1.0,xlab="", ylab="",xaxt='n',yaxt='n',lty="twodash")

#N= 150
par(new = TRUE)
curve(.54 / (1+exp(15*(x-0.18))),0.001,1.0,xlab="", ylab="",xaxt='n',yaxt='n',lty="twodash")

#N= 200 
par(new = TRUE)
curve(.54 / (1+exp(21*(x-0.132))),0.001,1.0,xlab="", ylab="",xaxt='n',yaxt='n',lty="twodash")

#N= XX 
par(new = TRUE)
curve(.51 / (1+exp(41*(x-0.10))),0.001,1.0,xlab="", ylab="",xaxt='n',yaxt='n',lty="twodash")

#N= XX 
par(new = TRUE)
curve(.51 / (1+exp(141*(x-0.0010))),0.001,1.0,xlab="", ylab="",xaxt='n',yaxt='n',lty="twodash")



