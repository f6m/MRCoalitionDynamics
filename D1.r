# Graficamos la ecuacion logistica:
curve(.4 / (1+790.3*exp(-1.001*x)), from=1, to=50, xlab="x", ylab="y")
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

#Random untie rule, means
N<-c(25^2,50^2,75^2,100^2,115^2,150^2,200^2)
D1mc2b<-c(103,626,1324,2254,3136,5790,11404)
D1mc2rb<-c(112,1060,2448,3824,5287,10550,21598)
D1mc2r<-c(130,1410,3008,4995,6984,13760,28750)

par(lwd=2.5,cex=1.5,mfrow=c(1,2))

#Stripes - Cartesian plot
plot(N, D1mc2b, xlim=range(c(0,200^2)),ylim=range(c(100,30000)),type="p",pch=21, col="steelblue2",lwd=2.9,xlab="", ylab="",
     main="",cex=2.0,tck=0.02, cex.axis=2.0)
#plotCI(Y,Empates,NCI,lwd=2.5,col="dodger blue",xlim=c(0.01,1.0),ylim=c(0.01,1.0),ylab='',xlab='')
par(new = TRUE) #tells R to make the second plot without cleaning the first
curve(0.1274*x^{1.070},0^2,200^2, xlim=range(c(0,200^2)), ylim=c(0,30000),xlab="", ylab="",xaxt='n',yaxt='n',lty="dotted",lwd=3.0)
par(new = TRUE) #tells R to make the second plot without cleaning the first
plot(N, D1mc2rb,
     ylim=range(c(100,30000)),type="p",pch=21, col="mediumorchid3",lwd=2.9,xlab="", ylab="",
     main="",cex=2.,tck=0.02, cex.axis=2.0,xaxt='n',yaxt='n')
par(new = TRUE) #tells R to make the second plot without cleaning the first
curve(0.0665*x^{1.1964},0^2,200^2, xlim=range(c(0,200^2)), ylim=c(0,30000),xlab="", ylab="",xaxt='n',yaxt='n',lty="dotdash",lwd=3.0)
par(new = TRUE)
plot(N, D1mc2r,
     ylim=range(c(100,30000)),type="p",pch=21, col="red",lwd=2.9,xlab="", ylab="",
     main="",cex=2.0,tck=0.02, cex.axis=2.0,xaxt='n',yaxt='n')
par(new = TRUE) #tells R to make the second plot without cleaning the first
curve(0.0865*x^{1.1970},0^2,200^2, xlim=range(c(0,200^2)), ylim=c(0,30000),xlab="", ylab="",xaxt='n',yaxt='n',lty="longdash",lwd=2.5)
#arrows(I, Tcsmin, I, Tcsmax, length=0.09, angle=90, code=3)

#Do nothing rule
M<-c(50^2,75^2,100^2,115^2,150^2,175^2,200^2)

cib<-c(7,13,23,26,55,33,22)
D1mc2bn<-c(274,601,1003,1390,2412,3204,4238)
D1mc2brn<-c(405,775,'',1820,'',4224,'')
D1mc2rn<-c(348,763,1374,1804,3058,4188,5485)

#par(lwd=2.5,cex=1.5,mfrow=c(1,2))
plot(M, D1mc2rn,
     ylim=range(c(100,6000)),type="p",pch=21, col="red",lwd=2.9,xlab="", ylab="",
     main="",cex=2.0,tck=0.02, cex.axis=2.0)
par(new = TRUE) #tells R to make the second plot without cleaning the first
curve(0.3462*x^{0.9103},0^2,200^2, xlim=range(c(0,200^2)), ylim=c(0,6000),xlab="", ylab="",xaxt='n',yaxt='n',lty="dotdash",lwd=3.0)
par(new = TRUE) #tells R to make the second plot without cleaning the first
plot(M, D1mc2brn,
     ylim=range(c(100,6000)),type="p",pch=21, col="mediumorchid3",lwd=2.9,xlab="", ylab="",
     main="",cex=2.0,tck=0.02, cex.axis=2.0,xaxt='n',yaxt='n')
par(new = TRUE) #tells R to make the second plot without cleaning the first
#plotCI(M, D1mc2bn,cib,xlim=c(0^2,200^2),
#     ylim=c(100,6000),pch=19, col="blue",lwd=3.5,xlab="", ylab="",
#     main="",cex=0.8,tck=0.02, cex.axis=2.0,xaxt='n',yaxt='n')
plot(M, D1mc2bn,
       ylim=range(c(100,6000)),type="p",pch=21, col="steelblue2",lwd=2.9,xlab="", ylab="",
       main="",cex=2.0,tck=0.02, cex.axis=2.0,xaxt='n',yaxt='n')
par(new = TRUE) #tells R to make the second plot without cleaning the first
curve(0.1294*x^{0.9801},0^2,200^2, xlim=range(c(0,200^2)), ylim=c(0,6000),xlab="", ylab="",xaxt='n',yaxt='n',lty="dotted",lwd=3.0)

# hack: we draw arrows but with very special "arrowheads"
#par(lwd=1.3,cex=1.5)
#par(new = TRUE)
arrows(I, Tcmin, I, Tcmax, length=0.05, angle=90, code=3)
par(new = TRUE)
curve(x^{0.98},50^2,200^2,xlab="", ylab="",xaxt='n',yaxt='n',lty="twodash")

