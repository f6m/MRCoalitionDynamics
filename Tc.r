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

I<-c(50^2,75^2,100^2,115^2,150^2,175^2,200^2)

#Including stripes
Tcsmin<-c(183.81,423,603,665,900,1054,1186)
   Tcs<-c(235,467,647,721,954,1125,1266)
Tcsmax<-c(274.81,501,685,772,1014,1190,1336)

#Without stripes
Tcmin<-c(88,166,219.89,288,448,604,746)
#Tc<-c(204,252.1,280.49,325.68,513,695,887)
Tc<-c(125,195,277,335,513,645,795)
Tcmax<-c(149,221.4,314.5,388,569,689,843)

par(lwd=2.5,cex=0.9,mfrow=c(1.9,2))
#mar=c(10,1,10,2)
#Log-log plot5
#plot(I, Tcs, type="p",log = "xy",pch=18, lwd=2, xlab="", ylab="",
#     main="",cex=1.2,tck=0.02)

#Stripes - Cartesian plot
plot(I, Tcs,
     ylim=range(c(Tcsmin, 1300)), type="p",pch=0, lwd=1.5,xlab="", ylab="",
     main="",cex=2.0,tck=0.02,cex.axis=2.0)

#par(new = TRUE)
arrows(I, Tcsmin, I, Tcsmax, length=0.09, angle=90, code=3)

#par(lwd=2.5,cex=1.5)
#par(new = TRUE)
#plot(I, Tcsmax,
 #    ylim=range(c(Tcsmin, Tcsmax)), type="l",pch=5, lwd=2, xlab="", ylab="",
#     main="",cex=0.5,tck=0.02)

#POWER LAW FITS
#Power law max
#par(new = TRUE)
#curve(0.98*x^{0.31},0,200^2,xlab="", ylab="",xaxt='n',yaxt='n',lty="dashed")
#Power law mean
par(new = TRUE)
curve(3.22*x^{0.298},50^2,200^2,xlab="", ylab="",xaxt='n',yaxt='n',lty="dashed")
#Power law min
#par(new = TRUE)
#curve(1.18*x^{0.386},0,200^2,xlab="", ylab="",xaxt='n',yaxt='n',lty="twodash")


#par(lwd=2.5,cex=1.2)
#No Stripes plot
plot(I, Tc,
     ylim=range(c(Tcmin, 850)), type="p",pch=15, lwd=1, xlab="", ylab="",
     main="",cex=2.0,tck=0.02,cex.axis=2.0)

# hack: we draw arrows but with very special "arrowheads"
#par(lwd=1.3,cex=1.5)
#par(new = TRUE)
arrows(I, Tcmin, I, Tcmax, length=0.05, angle=90, code=3)
par(new = TRUE)
curve(x^{0.98},50^2,200^2,xlab="", ylab="",xaxt='n',yaxt='n',lty="twodash")

#Draw line  and powr law
#par(new = TRUE)
#curve(x^{0.505},0,2000^2,xlab="", ylab="",xaxt='n',yaxt='n',lty="dashed")
#curve(0.0178*x+130,0,2000^2,xlab="", ylab="",xaxt='n',yaxt='n',lty="dashed")
