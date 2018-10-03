library(lattice)
#https://www.statmethods.net/advgraphs/axes.html
eq<-function(x){0.57/(1+exp(10.0*(x-0.218)))}
x<-seq(0,1,0.0001)
#I
Y<-c(0.020408163,
     0.041666667,
     0.063829787,
     0.086956522,
     0.111111111,
     0.136363636,
     0.162790698,
     0.19047619,
     0.219512195,
     0.25,
     0.282051282,
     0.315789474,
     0.351351351,
     0.388888889,
     0.428571429,
     0.470588235,
     0.515151515,
     0.5625,
     0.612903226,
     0.666666667,
     0.724137931,
     0.785714286,
     0.851851852,
     0.923076923,
     1)
#C-M2 L=100 P(AB)
SY<-c(0.510898331,
      0.489477477,
      0.4694780635,
      0.4551852,
      0.430192661,
      0.399,
      0.3780561644,
      0.336760563,
      0.29744186,
      0.24189914601,
      0.198391421,
      0.158854167,
      0.123225806,
      0.091083032,
      0.064146621,
      0.036613272,
      0.033084312,
      0.016753927,
      0.016580311,
      0.009183673,
      0.011099899,
      0.003021148,
      0.005015045,
      0.004,
      0.005)
#axis(1,at=x,labels=x,las=2,tck=0.02)
#mtext(side=1,text="X axis",line=1.5)
#pach to use 24 or 2, with lwd increase border.
par(lwd=3,cex.sub=10)
plot(x,eq(x),type="l",at = seq(0.0, 1.0, by = 0.1), lwd=2.5,xlim=c(0.01,1.0),ylim=c(0.0003,0.5),ylab='',xlab='',tck=0.04)
#par(new = TRUE,lwd=1)
#plot(Y,SY1,type="p",pch=2, lwd=3.2, col="orange",bg="orange",cex=1.6,ylim=c(0.0003,0.5),axes=FALSE,ylab='',xlab='')
#par(new = TRUE)
#plot(Y,SY2,type="p",pch=2, lwd=3.2, col="green3",bg="green3",cex=1.6,ylim=c(0.0003,0.5),axes=FALSE,ylab='',xlab='')
#par(new = TRUE)
#axis(1, at = seq(0.001, 1.0, by = 0.1), las=1)
par(new = TRUE)
plot(Y,SY,type="p",pch=23, lwd=3.2, col="dodger blue",bg="dodger blue",cex=1.6,ylim=c(0.0003,0.5),axes=FALSE,ylab='',xlab='')

#Determination Coefficient between Y and SY
expf = lm(SY ~ eq(Y))
summary(expf)$r.squared
