library(binsmooth)
library(pracma)
library(GoFKernel) # The package to take the inverse of the CDF for median


#library(haven)
#year2016data <- read_dta("~/Documents/SocResearch/Dissertation/data/data_derv/ki11_bidee05_ACS_alt_2016.dta")
#year2017data <- read_dta("~/Documents/SocResearch/Dissertation/data/data_derv/ki11_bidee05_ACS_alt_2017.dta")


#bEdges - A vector e1, e2, . . . , en giving the right endpoints of each bin. The value in en is ignored and assumed to be Inf or NA, indicating that the top bin is unbounded. The edges determine n bins on the intervals ei−1 ≤ x ≤ ei, where e0 is assumed to be 0.
#bCounts - A vector c1, c2, . . . , cn giving the counts for each bin (i.e., the number of data elements in each bin). Assumed to be nonnegative.
#m - An estimate for the mean of the distribution. If no value is supplied, the mean will be estimated by (temporarily) setting en equal to 2en−1.
#eps1 - Parameter controlling how far the edges of the subdivided bins are shifted. Must be between 0 and 0.5.
#eps2 - Parameter controlling how wide the middle subdivsion of each bin should be. Must be between 0 and 1.
#depth - Number of times to subdivide the bins.
#tailShape - Must be one of "onebin", "pareto", or "exponential".
#nTail - The number of bins to use to form the initial tail, before recursive subdivision. Ignored if tailShape equals "onebin".
#numIterations - The number of iterations to optimize the tail to fit the mean. Ignored if tailShape equals "onebin".
#pIndex - The Pareto index for the shape of the tail. Defaults to ln(5)/ ln(4). Ignored unless tailShape equals "pareto".
#tbRatio - The decay ratio for the tail bins. Ignored unless tailShape equals "exponential". Details


############
####2016####

#comes from $bidee/ki11_bidee06_ACS_cdf.do file
bEdges <- c(15323, 25538, 35753, 51075, 76613, 102151, 153226, 204301, 1021504, Inf) # upper bound $ value, inflated to 2017 dollars
bCounts <- c(233027, 223238, 241735, 368384, 536467, 427167, 500917, 219987, 257484) # count within each bracket
m <- 93825 # m is ACS mean

## Recursive subdivision PDF and CDF fitted to binned data ##
#rsubbins(bEdges, bCounts, m=85995, eps1 = 0.25, eps2 = 0.75, depth = 3, tailShape = c("onebin"))
#rsubbins(bEdges, bCounts, m=85995, eps1 = 0.25, eps2 = 0.75, depth = 3, tailShape = c("pareto"), nTail=16, numIterations=20, pIndex=1.160964)
#rsubbins(bEdges, bCounts, m=85995, eps1 = 0.25, eps2 = 0.75, depth = 3, tailShape = c("exponential"), nTail=16, numIterations=20, tbRatio=0.8)

## Optimized spline PDF and CDF fitted to binned data (smooth spline) ##
splb <- splinebins(bEdges, bCounts, m, numIterations = 16, monoMethod = c("hyman")) 
plot(splb$splinePDF, 0, 300000, n=500) 
integral(function(x){1-splb$splineCDF(x)}, 0, splb$E) # closer to given mean

#Gini coefficient (spline)
fCDF <- splb$splineCDF
cdf_mean <- splb$est_mean
gini <- 1-integral(function(x){(1-fCDF(x))^2}, 0, splb$E)/cdf_mean
print(gini)

#Median
invCDF <- inverse(fCDF, 0, splb$E)  #https://www.rdocumentation.org/packages/GoFKernel/versions/2.1-1/topics/inverse
median <- invCDF(.5)
print(median)



##Step function PDF and CDF fitted to binned data (polygonal) ##
sb <- stepbins(bEdges, bCounts, m)
plot(sb$stepPDF)
plot(sb$stepPDF, do.points=FALSE, col="gray", add=TRUE) # notice that the curve preserves bin area
plot(sb$stepCDF, 0, sb$E+100000)
integral(sb$stepPDF, 0, sb$E)

sbpt <- stepbins(bEdges, bCounts, m, tailShape="pareto")
plot(sbpt$stepPDF, do.points=FALSE)
plot(sbpt$stepCDF, 0, sbpt$E+100000)
integral(function(x){1-sbpt$stepCDF(x)}, 0, sbpt$E)

#Gini coefficient (polygonal)
fCDF <- sbpt$stepCDF
cdf_mean <- integral(function(x){1-sbpt$stepCDF(x)}, 0, sbpt$E)
print(cdf_mean)
gini <- 1-integral(function(x){(1-fCDF(x))^2}, 0, sbpt$E)/cdf_mean
print(gini)

#Median
invCDF <- inverse(fCDF, 0, sbpt$E)  #https://www.rdocumentation.org/packages/GoFKernel/versions/2.1-1/topics/inverse
median <- invCDF(.5)
print(median)



############
####2017####

#comes from  $bidee/ki11_bidee06_ACS_cdf.do file
bEdges <- c(15000, 25000, 35000, 50000, 75000, 100000, 150000, 200000, 999999, Inf)
bCounts <- c(222379, 214506, 232186, 361132, 534663, 434733, 522665, 237220, 279997)
m <- 95442 # m is ACS mean

#rsubbins(bEdges, bCounts, m=89294, eps1 = 0.25, eps2 = 0.75, depth = 3, tailShape = c("onebin"))
#rsubbins(bEdges, bCounts, m=89294, eps1 = 0.25, eps2 = 0.75, depth = 3, tailShape = c("pareto"), nTail=16, numIterations=20, pIndex=1.160964)
#rsubbins(bEdges, bCounts, m=89294, eps1 = 0.25, eps2 = 0.75, depth = 3, tailShape = c("exponential"), nTail=16, numIterations=20, tbRatio=0.8)

## Optimized spline PDF and CDF fitted to binned data (SMOOTH SPLINE) ##
splinebins(bEdges, bCounts, m, numIterations = 16, monoMethod = c("hyman"))
splb <- splinebins(bEdges, bCounts, m, numIterations = 16, monoMethod = c("hyman"))
plot(splb$splinePDF, 0, 300000, n=500) 

integral(function(x){1-splb$splineCDF(x)}, 0, splb$E) # closer to given mean

#Gini coefficient (spline)
fCDF <- splb$splineCDF
cdf_mean <- splb$est_mean
gini <- 1-integral(function(x){(1-fCDF(x))^2}, 0, splb$E)/cdf_mean
print(gini)

#Median
invCDF <- inverse(fCDF, 0, splb$E)  #https://www.rdocumentation.org/packages/GoFKernel/versions/2.1-1/topics/inverse
median <- invCDF(.5)
print(median)


## Step function PDF and CDF fitted to binned data (POLYGONAL) ##
sb <- stepbins(bEdges, bCounts, m)
plot(sb$stepPDF)
plot(sb$stepCDF, 0, sbpt$E+100000)
plot(sb$stepPDF, do.points=FALSE, col="gray", add=TRUE) # notice that the curve preserves bin area
integral(sb$stepPDF, 0, sbpt$E)

sbpt <- stepbins(bEdges, bCounts, m, tailShape="pareto")
plot(sbpt$stepPDF, do.points=FALSE)
integral(function(x){1-sbpt$stepCDF(x)}, 0, sbpt$E)

#Gini coefficient (polygonal)
fCDF <- sbpt$stepCDF

cdf_mean <- integral(function(x){1-sbpt$stepCDF(x)}, 0, sbpt$E)
pdf_mean <- integral(function(x){x*sbpt$stepPDF(x)}, 0, sbpt$E)
gini <- 1-integral(function(x){(1-fCDF(x))^2}, 0, sbpt$E)/cdf_mean
print(gini)

#Median
invCDF <- inverse(fCDF, 0, sbpt$E)  #https://www.rdocumentation.org/packages/GoFKernel/versions/2.1-1/topics/inverse
median <- invCDF(.5)
print(median)
#can use this same function to get quantiles, etc.

#can use fCDF function to find proportion of distribution withincome below that amount
fCDF(62416)
