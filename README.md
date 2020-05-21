
# samplelm

update: May 22, 2020

[![Build Status](https://travis-ci.org/zhanglj37/samplelm.svg)](https://travis-ci.org/zhanglj37/samplelm)
[![Downloads from the RStudio CRAN mirror](http://cranlogs.r-pkg.org/badges/samplelm)](https://cran.r-project.org/package=samplelm)
[![](https://cranlogs.r-pkg.org/badges/grand-total/samplelm)](https://cran.r-project.org/package=samplelm)

## Description

Using Monte Carlo simulation studies, this "samplelm" (Sample size determination for Latent Mediation analysis) package can explore the least sample size for your model.

![1590078098412](C:\Users\Lijin Zhang\AppData\Roaming\Typora\typora-user-images\1590078098412.png)

The least sample size is chosen based on the following criteria:

For mediation effect  $a*b$ :

1. power is no less than 0.8;

2. bias of the standard error estimates should not exceed 5%;

For all the parameters except for intercepts and residual variances:

3. biases of point and standard error estimates do not exceed 10% for any parameter in the model; 

4. coverage rates of the frequentist confidence intervals or the Bayesian credible intervals is large than 0.91.



## Installation

You can install it  from github using Hadley Wickham's 'devtools' package. 

```r
install.packages("devtools")
library(devtools)

install_github("zhanglj37/samplelm")
```


## Example

```r
library(samplelm)

# the effect size you should provide: loadings, structural coefficients
ly_matrix = matrix(c(
  1,0,0,
  0.8,0,0,
  0.8,0,0,
  0,1,0,
  0,0.8,0,
  0,0.8,0,
  0,0,1,
  0,0,0.8,
  0,0,0.8,
  0,0,0.8
),ncol=3,byr=T)
# the loading matrix
# the first-third column: the loadings for X, M, Y
# if you define the first loading of latent variable as 1, the fixed loading method would be used for model identification. Otherwise, the fixed variance method would be applied.

a=0.3  # M on X
b=0.3  # Y on M
c=0.2  # Y on X

estimator = "ML" # or Bayes


samplelm(ly_matrix, a, b, c, estimator, n0 = 150)

# n0: the least sample size this function return

# or choose the sample just base on the power criteria (criteria 1)
samplelm_power(ly_matrix, a, b, c, estimator, n0 = 150)
```

Running process:

(1) Increase the sample size by 5 at a time, and check whether the increased sample size meets the power criteria. If it meets the criteria, terminate the increase: 

```r
Running model: sample.inp 
System command: C:\WINDOWS\system32\cmd.exe /c cd "." && "Mplus" "sample.inp" 
Reading model:  sample.out 
[1] "This model needs at least 150 samples to reach a power of 0.598"

Running model: sample.inp 
System command: C:\WINDOWS\system32\cmd.exe /c cd "." && "Mplus" "sample.inp" 
Reading model:  sample.out 
[1] "This model needs at least 155 samples to reach a power of 0.652"

......

Running model: sample.inp 
System command: C:\WINDOWS\system32\cmd.exe /c cd "." && "Mplus" "sample.inp" 
Reading model:  sample.out 
[1] "This model needs at least 190 samples to reach a power of 0.804"
[1] "try the sample size: 190"
```

(2) Increase the sample size by 5 at a time, and check whether the increased sample size meets the criteria 2 - 4 

```r
[1] "try the sample size: 190"

Running model: sample.inp 
System command: C:\WINDOWS\system32\cmd.exe /c cd "." && "Mplus" "sample.inp" 
Reading model:  sample.out 
$bias_violation
integer(0)

$se_violation
integer(0)

$se_ab
[1] TRUE

$coverage_violation
integer(0)

## Interpretation:
## criteria 2 & 3 & 4 are satisfied
## the least sample size is 190

```



Example of Mplus input file:

```
TITLE: Simulation for sample size determination
MONTECARLO: 
	 NAMES = x1 - x3 	 m1 - m3 	 y1 - y4 ;
	 NOBSERVATIONS =  190 ; 
	 NREPS = 500; 
	 SEED = 1234; 

 MODEL POPULATION: 
	X  by 
		x1*1 
		x2*0.8 
		x3*0.8 ; 
	M  by 
		m1*1 
		m2*0.8 
		m3*0.8 ; 
	Y  by 
		y1*1 
		y2*0.8 
		y3*0.8 
		y4*0.8 ; 
	M ON X*0.3 ;
	Y ON M*0.3 ;
	Y ON X*0.2 ;
	X*1; 
	M*1; 
	Y*1; 
	x1 - x3*0.36 	 m1 - m3*0.36 	 y1 - y4*0.36 ;
	
 ANALYSIS:
	ESTIMATOR = ML 

 MODEL: 
	X  by 
		x1 
		x2*0.8 
		x3*0.8 ; 
	X*1 ;
	M  by 
		m1 
		m2*0.8 
		m3*0.8 ; 
	M*1 ;
	Y  by 
		y1 
		y2*0.8 
		y3*0.8 
		y4*0.8 ; 
	Y*1 ;
	M ON X*0.3(a) ;
	Y ON M*0.3(b) ;
	Y ON X*0.2(c) ;
	x1 - x3*0.36 	 m1 - m3*0.36 	 y1 - y4*0.36 ;
	
 MODEL CONSTRAINT: 
	 NEW(indirect*0.09); 
	 indirect = a*b; 
	
 OUTPUT: TECH9;

```

## BugsReports

https://github.com/zhanglj37/blcfa/issues

or contact with us: sunrq@link.cuhk.edu.hk, zhanglj37@mail2.sysu.edu.cn.


