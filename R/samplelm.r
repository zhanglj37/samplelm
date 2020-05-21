
samplelm <- function (ly_matrix, a, b, c, estimator, n0 = 150)
{
	samp_result = samplelm_power(ly_matrix, a, b, c, estimator, n0)
	
	if (samp_result$power >0.799)
	{
		ad_result = adjustment(ly_matrix, a, b, c, estimator, n0 = samp_result$sample_size) 
	}
	
	print(ad_result)
}


samplelm_power <- function(ly_matrix, a, b, c, estimator, n0 = 150) {
	for (i in seq(n0,n0+1000,5)) {
	mplus_gen(ly_matrix, a, b, c, estimator, i)
	result<-readModels("sample.out")
	pw<-result$parameters$unstandardized$pct_sig_coef[which(result$parameters$unstandardized$paramHeader=="New.Additional.Parameters")]
	print(paste('This model needs at least ', i , ' samples to reach a power of ', pw,sep = ''))
	if (pw > 0.79) {n = i; p = pw; break}
	}
	samp_result = list(sample_size = n, power = pw)
	return(samp_result)
}


##### Checking 3 Muthén conditions
checking_conds<-function(ly_matrix)
{
	result<-readModels("sample.out")
	##### check point estimate and standard error estimate biases and coverage rate
	loc_inter = which(result$parameters$unstandardized[,1] == "Intercepts")
	loc_res = which(result$parameters$unstandardized[,1] == " Residual.Variances")
	loc_all = c(loc_inter, loc_res)
	loc_new = which(result$parameters$unstandardized[,1] == "New.Additional.Parameters")
	
	param_avg<-result$parameters$unstandardized$average[-loc_all]
	param_pop<-result$parameters$unstandardized$population[-loc_all]
	se_avg<-result$parameters$unstandardized$average_se[-loc_all]
	se_pop<-result$parameters$unstandardized$population_sd[-loc_all]
	coverage<-result$parameters$unstandardized$cover_95[-loc_all]
	r1<-which(!(abs(param_avg - param_pop)/param_pop <= .1))
	r2<-which(!(abs(se_avg - se_pop)/se_pop <= .1))
	r3<-(abs(se_avg - se_pop)/se_pop)[loc_new] <= .05 #####21/22/33/34
	r4<-which(coverage < .91 )

	r = list(bias_violation = r1,se_violation = r2, se_ab = r3,coverage_violation=r4)
	return(r)
}


##### Adjusting sample size to meet bias and coverage criteria, if necessary 
adjustment<- function(ly_matrix, a, b, c, estimator, n0 = 300) 
{
	for (i in seq(n0,n0+500,5)) 
	{
		print(paste0("try the sample size: ", i))
		mplus_gen(ly_matrix, a, b, c, estimator, i)
		checking_result = checking_conds(ly_matrix)

		print(checking_result)
		if ((length(checking_result$bias_violation) == 0)
			&( length(checking_result$se_violation) == 0)
			&( checking_result$se_ab == TRUE)
			&( length(checking_result$coverage_violation) ==0)) {n = i; break}
	}
	ad_result = list(sample_size = n, checking_results = checking_result)
	return(ad_result)
}