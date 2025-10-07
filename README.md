# Flexible interrupted time series to aggregated data

This repository contains code and resources for analyzing flexible interrupted time series models (segmented mixed-effects models) using aggregated data. These models are particularly useful for evaluating the impact of interventions, policy changes or the effect of unplanned global crises over time when individual-level data is not available or reasonable to represent. By incorporating spline-based random effects and segmented trends, the approach allows for flexible modeling of time-dependent changes and discontinuities. 

The included scripts demonstrate how to analyze changes in food purchasing behavior across various sociodemographic groups, as well as, modes of remote work (study), and how to interpret results using R packages nlme and lmeSplines. There are two folders, where are specify model structures to aggregated data by using modes of remote working/studying (remote work) and different sociodemographic groups (strata). 


In strata folder, there is algorithm to merge groups by using agglomerative hierarchical clustering and average linkage. This was used to identify the main change profiles, as well as outlying change profiles from different sociodemographic groups. The number of algorithmically combined strata was determined by the maximum of the average Silhouette index score. 





For an example, lmeSplines extends the functionality of the nlme package by enabling the inclusion of smoothing spline terms in linear and nonlinear mixed-effects models:





```R

# Packages from CRAN:

library(lmeSplines)

library(nlme)

#Code to calculate 95 % confidence intervals:

source("calculate_ci_lmesplines.R")

#Load a data:

load(example_data)


#'Data includes:

#'@param "y" Continuous response variable

#'@param "elapsed_time" Continuous elapsed time variable (the trend term)

#'@param "interrup" Binary interruption variable (0= time before the interruption point, 1= time after the interruption point.

#'@param "time_after_interrup" Continuous time variable (the slope term after the interruption point)

#'@param "strata" Categorical group variable (for instance, population strata)



# Generate spline Z-matrix (using as random effects):



example_data$Zt <- smspline(~ elapsed_time, data = example_data)


# Fit the model

fit <- lme(y ~ elapsed_time + interrup + time_after_interrup + elapsed_time:strata + interrup:strata + time_after_interrup:strata, data=example_data,

random=list(~1|strata,strata=pdIdent(~Zt)))


# Summarize results:

calculate_ci_lmesplines(fit)

# Figure:

ggplot(example_data,aes(x=elapsed_time,y=y,colour=strata)) + geom_point() + geom_line(aes(y = fitted(fit))) + labs(y="Response",x="Time",colour="Strata") 


```


## References

Bernal JL, Cummins S, Gasparrini A. Interrupted time series regression for the evaluation of public health interventions: a tutorial. Int J Epidemiol. 2017;46:1: 348–355. doi: 10.1093/ije/dyw098. 

Durrleman S, Simon R. Flexible regression models with cubic splines. Stat Med. 1989;8:5: 551–561. doi: 10.1002/sim.4780080504. 

Pinheiro JC, Bates DM. Mixed-Effects Models in S and S-PLUS Springer-Verlag, New York 2000.

Rousseeuw PJ. Silhouettes: a graphical aid to the inter-pretation and validation of cluster analysis. J Comput Appl Math. 1987; 20:53–65. doi:10.1016/0377-0427(87)90125-7.

Roux MA. Comparative Study of Divisive and Agglomerative Hierarchical Clustering Algorithms. J Classif. 2018; 35:345–366. doi:10.1007/s00357-018-9259-9

Verbyla A, Cullis BR, Kenward MG, Welham SJ. The analysis of designed experiments and longitudinal data by using smoothing splines. Appl Statist. 1999;48(3): 269–311.



## Authors



[@suviahtinen](https://www.github.com/suviahtinen)



## Licence



[MIT](https://choosealicense.com/licenses/mit/)
