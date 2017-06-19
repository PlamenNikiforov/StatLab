setwd('C:\\Users\\plame\\Desktop\\FMI\\Statlab\\Project')

find_return <-function(asset){
  t <- 2
  x <- vector(mode="numeric", length=0)
  while(t < length(asset)){
    x <- c(x,log(asset[t]/asset[t-1],exp(1)))
    t <- t + 1
  }
  dim(x) <- c(480,1)
  x
}

risk_function<-function(ro,sd,fixed = c(0,0,0,0,0)){
  params <- fixed
    function(port){
      params[fixed] <- port
      risk <- 0;
      for (i in 1:5) {
        risk <- sqrt((port[i])^2 + (sd[i])^2)
        for (j in i:5) {
          risk <- 2*port[i]*port[j]*sd[i]*sd[j]*ro[i,j]
        }
      }
      risk
    }
}

assets <- read.csv(file="info.csv",header = TRUE)
summary(assets)

AUD <- assets[,"AUD"]
EUR <- assets[,"EUR"]
GBP <- assets[,"GBP"]
NZD <- assets[,"NZD"]
XAU <- assets[,"XAU"]
  
rAUD <- apply(find_return(AUD),2,mean)
rEUR <- apply(find_return(EUR),2,mean)
rGBP <- apply(find_return(GBP),2,mean)
rNZD <- apply(find_return(NZD),2,mean)
rXAU <- apply(find_return(XAU),2,mean)

sdAUD <- apply(find_return(AUD),2,sd)
sdEUR <- apply(find_return(EUR),2,sd)
sdGBP <- apply(find_return(GBP),2,sd)
sdNZD <- apply(find_return(NZD),2,sd)
sdXAU <- apply(find_return(XAU),2,sd)

sd <- c(sdAUD,sdEUR,sdGBP,sdNZD,sdXAU)

ro <- cor(assets)

RF <- risk_function(ro,sd)
Ri <- 0.5*(10^(-6))
A <- matrix(c(rAUD,rEUR,rGBP,rNZD,rXAU,-1,0,0,0,0,0,-1,0,0,0,0,0,-1,0,0,0,0,0,-1,0,0,0,0,0,-1),6,5,byrow = TRUE)
b <- c(Ri,-1,-1,-1,-1,-1)

opt <- constrOptim(c(0.02,0.02,0.05,0.9,0.01),RF,NULL,A,b)
opt$par


