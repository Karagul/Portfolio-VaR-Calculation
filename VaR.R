
"
portfolio.csv has 8 stocks, time series ranging from 2010-12-17 to 2017-12-17

PerformanceAnalytics package:
https://cran.r-project.org/web/packages/PerformanceAnalytics/PerformanceAnalytics.pdf

Details:
http://braverock.com/brian/R/PerformanceAnalytics/html/VaR.html
"

rm(list = ls())
par(mfrow=c(1,1))

# Install packages
install.packages("data.table") # fast df readin for large data set
install.packageS("zoo") # r time series objects read in
install.packages("PerformanceAnalytics") # R Econometric tools

# Load libraries
library(data.table) #fast df readin
library(zoo) # time series object
library(PerformanceAnalytics)

setwd("C:/Users/Patrick/Desktop/Thesis In/VaR")

# Read in data frame
df <- fread("portfolio.csv") # read-in raw data
df_ts <- read.zoo(df) # convert raw data df to time series object

# Dimensions of matrix
n = dim(df_ts)[1] # n = time series length
cols = dim(df_ts)[2] # columns of time series

df_log <- diff(log(df_ts), lag = 1) # price to log-returns

#############################
# VaR calculations p = 0.95 #
#############################

### HISTORICAL ###
# Single asset VaR and ES Calculation
VaR(df_log, p = 0.95, method = "historical", portfolio_method = "single") 
ETL(df_log, p = 0.95, method = "historical", portfolio_method = "single") # Expected Shortfall

# Portfolio VaR, equal weigh portfolio
VaR(df_log, p = 0.95, method = "historical", portfolio_method = "component",
    weights = c(1/cols, 1/cols, 1/cols, 1/cols, 
                1/cols, 1/cols, 1/cols, 1/cols))

### PARAMETRIC / VARIANCE-COVARIANCE VaR ###
VaR(df_log, p = 0.95, method = "gaussian", portfolio_method = "single") 

VaR(df_log, p = 0.95, method = "gaussian", portfolio_method = "component", weights = c(1/cols, 1/cols, 1/cols, 1/cols, 
                                                                                       1/cols, 1/cols, 1/cols, 1/cols)) 


### one-day vs n-days parametric / Variance-Covariance VaR ###

# portfolio return calculations with equal weigh
portfolio_r <- Return.portfolio(df_log, weights = c(1/cols, 1/cols, 1/cols, 1/cols, 1/cols, 1/cols, 1/cols, 1/cols))
df_portfolio <- merge(portfolio_r, df_log)

# One-day VaR (time series resolution)
sigma <- var(df_portfolio)
var_ratio <- -colMeans(df_portfolio) - sqrt(sigma)*qnorm(0.95)
diag(var_ratio)

# 20 trading day (one-month) VaR (sigma * sqrt(T))
t_days <- 20
sigma_2 <- var(df_portfolio)*sqrt(t_days)
var_ratio_2 <- -colMeans(df_portfolio) - sqrt(sigma_2)*qnorm(0.95)
diag(var_ratio_2)

