#' Calculate Confidence Intervals for lmesplines Models
#'
#' @param model A fitted model object from lmer() using lmesplines.
#' @param level Confidence level (default is 0.95).
#'
#' @return A data frame with estimates and confidence intervals.


calculate_ci_lmesplines <- function(model, level = 0.95) {
  coefs <- lme4::fixef(model)
  se <- sqrt(diag(vcov(model)))
  
  alpha <- 1 - level
  z <- qnorm((alpha/2)+level)
  
  lower <- coefs - z * se
  upper <- coefs + z * se
  
  ci_df <- data.frame(
    Term = names(coefs),
    Estimate = coefs,
    Lower = lower,
    Upper = upper,
    row.names = NULL
  )
  
  return(ci_df)
}
