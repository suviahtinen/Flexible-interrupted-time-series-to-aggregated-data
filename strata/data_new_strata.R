#' Function to make new strata data
#' 
#' This function makes the new weighted weekly means data to algoritmically combinated strata. 
#' 
#' @param data Raw data without weekly means 
#' @param new_strata The cluster solution made with cluster_ind_calc_average -function
#' @param strata_number Number of the chosen strata 
#' @return A new strata data with means every week and year.


data_new_strata<- function(new_strata,data,strata_number){


data2_t<-as.data.table(data)
i<-1
while(i<dim(new_strata)[1]+1){
  setDT(data2_t)[strata_SES==rownames(new_strata)[i], 
                                 new_strata_SES:=new_strata[i,(dim(new_strata)[2]+1)-strata_number]] 
  i<-i+1
}

data2<-as.data.frame(data2_t)

#New weekly means to new strata 

new_data_t<-as.data.table(data2)

new_data<-new_data_t[,.(energy_for_euro=weighted.mean(energy_for_euro,sample_weight)), by=list(weeknum,year,new_strata_SES)] 

new_data<-as.data.frame(new_data)

return(new_data)

}