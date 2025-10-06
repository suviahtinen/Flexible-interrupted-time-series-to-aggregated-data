# Flexible interrupted time series by using lmeSplines





This repository contains code and resources for analyzing flexible interrupted time series models, specifically segmented mixed-effects models, using aggregated data. These models are particularly useful for evaluating the impact of interventions or policy changes over time when individual-level data is not available or difficult to use. By incorporating spline-based random effects and segmented trends, the approach allows for flexible modeling of time-dependent changes and discontinuities. 





The included scripts demonstrate how to interpret results using R packages nlme and lmeSplines. There are two folders, where are specify model structures to aggregated data by using modes of remote working/studying (remote work) and different sociodemographic groups (strata). 



In strata folder, there are algorithm to merge groups by using agglomerative hierarchical clustering and average linkage. The number of algorithmically combined strata was determined by the maximum of the average Silhouette index score. This was used to identify the main change profiles, as well as outlying change profiles from different sociodemographic groups.





For an example, lmeSplines extends the functionality of the nlme package by enabling the inclusion of smoothing spline terms in linear and nonlinear mixed-effects models:





```R



library(lmeSplines)

library(nlme)



\#Load a data



load(example\_data)



\#Data includes:



@param "y" Continuous response variable

@param "elapsed\_time" Continuous elapsed time variable (the trend term)

@param "interrup" Binary interruption variable (0= time before the interruption point, 1= time after the interruption point.

@param "time\_after\_interrup" Continuous time variable (the slope term after the interruption point)

@param "strata" Categorical group variable (for instance, population strata)







\# Generate spline Z-matrix (using as random effects):



example\_data$Zt <- smspline(~ elapsed\_time, data = example\_data)





\# Fit the model

fit <- lme(y ~ elapsed\_time + interrup + time\_after\_interrup + elapsed\_time:strata + interrup:strata + time\_after\_interrup:strata, data=example\_data,

random=list(~1|strata,strata=pdIdent(~Zt0)))





\# Summarize results

summary(fit)



```





\## References



Ball, R. D. (2003) Experiences with LME, smooth-

ing splines, and application to Pinus radiata

wood density. New Zealand Statistical Asso-

ciation Annual Conference, Massey University,

Palmerston North



Pinheiro, J. C. and Bates, D. M. (2000) Mixed-Effects

Models in S and S-PLUS Springer-Verlag, New

York.



Verbyla, A., Cullis, B. R., Kenward, M. G., and Welham, S. J. (1999) 

The analysis of designed experiments and longitudinal data by using smoothing splines. 

Appl. Statist. 48(3) 269–311.





\## Authors



\- \[@suviahtinen](https://www.github.com/suviahtinen)





\## Licence



\[!\[MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/)

