fact <- function(n) if (n ==1) 1 else n * fact(n -1)
# The number of people (in thousands) travelling per month on an airline
# are recorded for the period 1949-1960.
data("AirPassengers")
AP = AirPassengers
summary(AP)
str(AP)
plot(AP)
plot(aggregate(AP), ylab="Annual passengers/1000's")
boxplot(AP ~ cycle(AP), names=month.abb)
par(mar=c(1,1,1,1))
layout(1,2)
plot(aggregate(AP)); boxplot(AP ~ cycle(AP))

# data = Import["http://www.massey.ac.nz/~pscowper/ts/cbe.dat"];
# data = Import["http://www.massey.ac.nz/~pscowper/ts/cbe.dat"];
# # ts = TemporalData[data[[2 ;; -1, 1]], {"1958", Automatic, "Month"}];
# # DateListPlot[ts["Path"]]
# ts2= TemporalData[Transpose[data[[2 ;; -1]]], {"1958", Automatic, "Month"}];
# # DateListPlot[ts2["Paths"]]
# The monthly supply of electricity (in millions of kWh), beer and chocolate-based productivity (in tonnes) in Australia
# over the period January 1958 to December 1990 are available from the Australian Bureau of Statistics (ABS).
www = "http://staff.elena.aut.ac.nz/Paul-Cowpertwait/ts/cbe.dat"
cbe = read.table(www, header=T)
cbe[1:4,]
class(cbe)
dim(cbe)
ts(1:120, start=c(1990,1), end=c(1993,8), freq=12)
ts(1:120, start=c(1990,1), end=c(1993,8), freq=12)
ts(1:120, start=c(1990,1), end=c(1993,8), freq=12)
ts(1:120, start=c(1990,1), end=c(1993,8), freq=12)
ts(1:120, start=c(1990,1), end=c(1993,8), freq=12)

#now create time series for electricity data
elec.ts <- ts(cbe[,3], start=1958, freq=12)
beer.ts <- ts(cbe[,2], start=1958, freq=12)
choc.ts <- ts(cbe[,1], start=1958, freq=12)
plot(cbind(elec.ts, beer.ts, choc.ts), main="Choc, Beer and Electricity production: 1958 - 1990")

#multiple time series - using intersect
ap.elec = ts.intersect(AP, elec.ts)
start(ap.elec); end(ap.elec)
ap.elec[1:3, ]
ap = ap.elec[, 1]; elec = ap.elec[, 2]
par(mar=c(4,4,4,4))
layout(1:3)
plot(ap, main="", ylab="Air Passengers/ 1000's")
plot(elec, main="", ylab="Electricity Production/ MkWh")
plot(as.vector(ap), as.vector(elec), 
     xlab="Air Passengers /1000's",
     ylab="Electricity production / MWh")
abline(reg=lm(ap ~ elec))
cor(ap,elec)

#The term non-stationary is used to describe a time series that has underlying
#trends or seasonal effects.

#Example Quarterly exchange rate data
# The exchange rates, for British pounds sterling to New Zealand dollars for 
# the period January 1991 to March 2000

www = "http://staff.elena.aut.ac.nz/Paul-Cowpertwait/ts/pounds_nz.dat"
z = read.table(www, header=T)
z[1:4, ]

z.ts = ts(z, st=1991, fr=4)
plot(z.ts, xlab="time / years",
     ylab = "Quarterly Exchange rate in $NZ / pound")

# random trends are called stochastic trends , the opposite would be called deterministic trends
# reference mathematical model "random walk"

# split the series for more analysis
dummy.ts = ts(st=c(1992,1), end=c(1996,1), freq=4)
z.92_96 = ts.intersect(z.ts, dummy.ts)[, 1]
dumm.ts = ts(st=c(1996,1), end=c(1998,1), fr=4)
z.96_98 = ts.intersect(z.ts, dumm.ts)[, 1]
layout(1:2)
plot(z.92_96,
     ylab="Exchange rate in $NZ / pound", xlab="time / years")
plot(z.96_98,
     ylab="Exchange rate in $NZ / pound", xlab="time / years")
# statitical tests should be made to decide whether a series has a stochastic trend to reduce the
# risk of making an inappropriate forecast.




#Global temperature series ########
www = "http://staff.elena.aut.ac.nz/Paul-Cowpertwait/ts/global.dat"
# data from 1856 to 2005
global = scan(www)
(2005 - 1856) * 12

global.ts = ts(global, st=c(1856,1), end=c(2005,12), fr=12)
global.annual = aggregate(global.ts, FUN=mean)
plot(global.ts); plot(global.annual)

# time period 1970 - 2005
dummy.ts = ts(st=c(1970,1), end=c(2005,12), fr=12)
new.series = ts.intersect(global.ts, dummy.ts)[,1]
new.time = time(new.series)
plot(new.series); abline(reg=lm(new.series ~ new.time))

#### The expected value


x = ap ; y = elec; n = length(x)
mean((x - mean(x)) * (y - mean(y)))
sum((x - mean(x)) * (y - mean(y)))/(n-1)
cov(x,y)
# the values computed using the internal function cov are those obtained using sum
# with a divisor of n???1. These are the unbiased estimates for the covariance, and
# are needed especially when the sample size n is small.

cor(x,y)
