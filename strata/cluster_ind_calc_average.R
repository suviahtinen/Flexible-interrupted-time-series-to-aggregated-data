#' Make agglomerative clustering and return solution matrix from cutree() -function from maximum number of strata to 2 combinated cluster.
#' 
#' This function makes agglomerative hierarchical clustering with average linkage, 
#' calculates and shows maximum of Silhouette index (with figure)
#' and return the cluster solution matrix from cutree() -function.
#' 
#' @param elapsed_time time variable on weeks
#' @param strata strata number in each week
#' @param fit_model Fitted values from fitted()-function made with lmeSpline
#' @param strata_num maximum number of strata
#' @param samples A numeric vector of sample sizes for each row.
#' @return A new strata table from cutree() -function.


cluster_ind_calc_average<-function(elapsed_time,strata,fit_model,strata_num,samples){
  
  if (length(elapsed_time) != length(strata) | length(elapsed_time) != length(fit_model) | length(fit_model) != length(strata)) {
    stop("Lengths of elapsed_time, strata and fit_model must match")
  }
  
  #Make a datasets from fitted values to each strata levels:
  
  fit_data2<-data.frame(elapsed_time=elapsed_time,strata=strata,fits=fit_model)
  
  fit_data_wide2<-spread(fit_data2,strata,fits)
  
  #Transpose from data:
  
  trans_fit_data_wide2<-data.frame(t(fit_data_wide2)[-1,])
  
  rownames(trans_fit_data_wide2)<-1:strata_num
  
  #weighted euclidean distance:
  
  source("weighted_dist.R")
  
  #average linkage hierarchical clustering (and silhouette scores):
  
  plot(hclust(weighted_dist(trans_fit_data_wide2,samples),method="average"))
  
  silhouette_scores<-rep(0,strata_num-2)
  
  k<-strata_num-1
  i<-1
  
  while(k>1 & i<strata_num-1){
    
    cluster_labels<-cutree(hclust(weighted_dist(trans_fit_data_wide2,samples),method="average"),k)
    sil<-silhouette(cluster_labels,weighted_dist(trans_fit_data_wide2,samples))
    silhouette_scores[i]<-mean(sil[,3])
  
    k<-k-1
    i<-i+1
  }
  
  indexes<-data.frame(Silhouette=silhouette_scores)
  rownames(indexes)<-c((strata_num-1):2)
  
  print(indexes)
  
  plot(c((strata_num-1):2),indexes$Silhouette,type="b",xlab="Number of cluster",ylab="Average Silhouette score")
  
  print(paste0("Number of clusters in maximum of average Silhouette score: ", rownames(indexes)[which.max(indexes$Silhouette)]))
  
  new_segs<-as.data.frame(cutree(hclust(weighted_dist(trans_fit_data_wide2,samples),method="average"),c((strata_num-1):2)))
  
  print("Combinated strata:")
  return(new_segs)  #showing combined groups
  
}