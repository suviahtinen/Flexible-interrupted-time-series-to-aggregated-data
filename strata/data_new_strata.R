#' Function to make new strata data
#' 
#' This function makes the new weighted weekly means data to algoritmically combinated strata. 
#' 
#' @param data Raw data without weekly means 
#' @param new_strata The cluster solution made with cluster_ind_calc_average -function
#' @param strata_number Number of the chosen strata 
#' @return A new strata data.


data_new_strata<- function(new_strata,data,strata_number){

new_strata<-new_strata
data<-data
strata_number<-strata_number


  
data2_t<-as.data.table(data)
i<-1
while(i<dim(new_strata)[1]+1){
  setDT(data2_t)[strata_SES==rownames(new_strata)[i], 
                                 new_strata_SES:=new_strata[i,(dim(new_strata)[2]+1)-strata_number]] 
  i<-i+1
}

data2<-as.data.frame(data2_t)

#New weekly means to new strata 

data2$energy_for_euro<-data2$energy_MJ/data2$fixed_euros_no_tobacco_uncat

new_data_t<-as.data.table(data2)

new_data<-new_data_t[,.(energy_for_euro=weighted.mean(energy_for_euro,sample_weight)), by=list(weeknum,year,new_strata_SES)] 

new_data<-as.data.frame(new_data)

#COVID-years and elapsed time variable:

new_data_t<-as.data.table(new_data)


setDT(new_data_t)[year==2019, elapsed_time:=weeknum-9] 
new_data_t[year==2020, elapsed_time:=(52+weeknum)-9] 
new_data_t[year==2021, elapsed_time:=(104+weeknum)-9] 

new_data<-as.data.frame(new_data_t)

#Interrupted-variable:

new_data$interrupted01<-ifelse(new_data$year<2020 | (new_data$weeknum<=11 & new_data$year==2020),0,1)
new_data$interrupted01<-factor(new_data$interrupted01,labels=c("Baseline (from the first week of March 2019 to second week of March 2020)","COVID year 1 (from the second week of March 2020 to the second week of May 2021)"))

#Making time variable after interrupted term:

new_data$weeks_after_preCOVID<-ifelse(new_data$year<2020 | (new_data$weeknum<=11 & new_data$year==2020),0,new_data$elapsed_time)

return(new_data)

}