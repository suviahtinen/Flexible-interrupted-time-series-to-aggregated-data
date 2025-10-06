
#' Compute Weighted Euclidean Distance Matrix
#'
#' This function computes a weighted Euclidean distance matrix between rows of a data matrix,
#' using both inverse variance weights for columns and sample size weights for rows.
#' The function mimics the behavior of dist().
#'
#' @param data A data frame or matrix where rows represent observations and columns represent variables.
#' @param sample_sizes A numeric vector of sample sizes for each row.
#' @return A distance matrix of class 'dist'.

weighted_dist <- function(data, sample_sizes) {
  if (is.data.frame(data)) {
    data <- as.matrix(data)
  }
  
  if (length(sample_sizes) != nrow(data)) {
    stop("Length of sample_sizes must match the number of rows in data")
  }
  
  # Compute distance matrix
  n <- nrow(data)
  dist_matrix <- matrix(0, n, n)
  
  for (i in 1:(n - 1)) {
    for (j in (i + 1):n) {
      row_weight <- (sample_sizes[i] + sample_sizes[j]) / 2
      diff_sq <- (data[i, ] - data[j, ])^2
      weighted_diff <- row_weight * diff_sq
      dist_ij <- sqrt(sum(weighted_diff))
      dist_matrix[i, j] <- dist_ij
      dist_matrix[j, i] <- dist_ij
    }
  }
  
  return(as.dist(dist_matrix))
}
