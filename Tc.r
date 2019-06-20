# Plotting consensus times Tc
#Let's assume you have a vector of "average values" avg 
#and another vector of "standard deviations" sdev, they are of the same length n. Let's make the abscissa just the number of these "measurements", so x <- 1:n. Using these, here come the plotting commands:
#ver https://stackoverflow.com/questions/13032777/scatter-plot-with-error-bars

# Line types http://www.sthda.com/english/wiki/line-types-in-r-lty
# Log-log plots http://sphaerula.com/legacy/R/logLogPlots.html
# Fitting curves: https://stackoverflow.com/questions/14190883/fitting-a-curve-to-specific-data
# Interactive R :  https://www.datacamp.com/community/tutorials/15-questions-about-r-plots

I<-c(30^2,50^2,75^2,100^2,115^2,150^2,175^2,200^2)
I1<-c(40^2,50^2,75^2,100^2,115^2,150^2,175^2,200^2)

#With Stripes
Tcsmin<-c(130,174.81,331,529,593,887,1089,1256)
Tcs<-c(144,205,385,585,655,954,1175,1336)
Tcsmax<-c(160,229.81,428,641,715,1007,1240,1410)

#Without stripes
Tcmin<-c(28,98,168,235.89,288,490,624,766)
#Tc<-c(204,252.1,280.49,325.68,513,695,887)
Tc<-c(31,125,195,277,335,543,675,825)
Tcmax<-c(37,147,225.4,314.5,388,593,732,879)

par(lwd=2.5,cex=0.9,mfrow=c(1.9,2))
#mar=c(10,1,10,2)
#Log-log plot5
#plot(I, Tcs, type="p",log = "xy",pch=18, lwd=2, xlab="", ylab="",
#     main="",cex=1.2,tck=0.02)

#Stripes - Cartesian plot
plot(I1, Tcs,
     ylim=range(c(Tcsmin, 1400)), type="p",pch=0, lwd=1.5,xlab="", ylab="",
     main="",cex=2.0,tck=0.02,cex.axis=2.0)

#par(new = TRUE)
arrows(I1, Tcsmin, I1, Tcsmax, length=0.09, angle=90, code=3)

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
curve(0.926*x^{0.6916},40^2,200^2,xlab="", ylab="",xaxt='n',yaxt='n',lty="dashed")
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
curve(0.2883*x^{0.7487},30^2,200^2,xlab="", ylab="",xaxt='n',yaxt='n',lty="twodash")
