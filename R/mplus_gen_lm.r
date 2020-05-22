


mplus_gen<-function(ly_matrix, a, b, c, estimator, nsize)
{

locx = which(ly_matrix[,1]!=0)
nx = length(locx)
locm = which(ly_matrix[,2]!=0)
nm = length(locm)
locy = which(ly_matrix[,3]!=0)
ny = length(locy)


if(file.exists("sample.inp"))
{
 file.remove("sample.inp")
}


cat(
	"TITLE: Simulation for sample size determination\n", #_fix211_
	file = paste("sample.inp", sep = ''), append = T)

##### MONTECARLO
cat(
	"MONTECARLO: \n\t",
	"NAMES = x1 -", paste0("x", nx),
	"\t m1 -", paste0("m", nm),
	"\t y1 -", paste0("y", ny), ";\n\t",
	file = paste("sample.inp", sep = ''), append = T)


cat(
	"NOBSERVATIONS = ", nsize, "; \n\t",
	"NREPS = 500; \n\t",
	"SEED = 1234; \n",	
	file = paste("sample.inp", sep = ''), append = T)


##### MODEL POPULATION
cat(
	"\n",
	"MODEL POPULATION: \n\t",
	file = paste("sample.inp", sep = ''), append = T)

set_true(var = "X", nx, locx, ly_matrix)
set_true(var = "M", nm, locm, ly_matrix)
set_true(var = "Y", ny, locy, ly_matrix)

cat(
	paste0("M ON X*", a), ";\n\t",
	paste0("Y ON M*", b), ";\n\t",
	paste0("Y ON X*", c), ";\n\t",
	"X*1; \n\t",
	"M*1; \n\t",
	"Y*1; \n\t",
	file = paste("sample.inp", sep = ''), append = T)

cat(
	"x1 -", paste0("x", nx, "*0.36"),
	"\t m1 -", paste0("m", nm, "*0.36"),
	"\t y1 -", paste0("y", ny, "*0.36"), ";\n\t",
	file = paste("sample.inp", sep = ''), append = T)


##### ANALYSIS
cat(
	"\n",
	"ANALYSIS:\n\t",
	file = paste("sample.inp", sep = ''), append = T)
if (tolower(substr(estimator,1,1)) == "b")
{
	cat(
		"ESTIMATOR = BAYES;\n\t",
		"PROCESS = 2; \n\t",
		"BITERATIONS = 50000(2000); \n",
		file = paste("sample.inp", sep = ''), append = T)
}else{
	cat(
		paste0("ESTIMATOR = ", estimator), "\n",
		file = paste("sample.inp", sep = ''), append = T)
}


##### MODEL
cat(
	"\n",
	"MODEL: \n\t",
	file = paste("sample.inp", sep = ''), append = T)

	fix = "variance"
	if(ly_matrix[locx[1],1] == 1){
		fix = "ly"
	}
	set_true(var = "X", nx, locx, ly_matrix, fix)

	fix = "variance"
	if(ly_matrix[locm[1],2] == 1){
		fix = "ly"
	}
	set_true(var = "M", nm, locm, ly_matrix, fix)

	fix = "variance"
	if(ly_matrix[locy[1],3] == 1){
		fix = "ly"
	}
	set_true(var = "Y", ny, locy, ly_matrix, fix)

cat(
	paste0("M ON X*", a, "(a)"), ";\n\t",
	paste0("Y ON M*", b, "(b)"), ";\n\t",
	paste0("Y ON X*", c, "(c)"), ";\n\t",
	file = paste("sample.inp", sep = ''), append = T)

cat(
	"x1 -", paste0("x", nx, "*0.36"),
	"\t m1 -", paste0("m", nm, "*0.36"),
	"\t y1 -", paste0("y", ny, "*0.36"), ";\n\t",
	file = paste("sample.inp", sep = ''), append = T)

cat(
	"\n",
	"MODEL CONSTRAINT: \n\t",
	paste0("NEW(indirect*", a*b, ");"), "\n\t",
    "indirect = a*b; \n\t",
	file = paste("sample.inp", sep = ''), append = T)


cat(
	"\n",
	"OUTPUT: TECH9;\n",
	file = paste("sample.inp", sep = ''), append = T)
 
## run
runModels("sample.inp")

if(file.exists("Mplus Run Models.log"))
{
 file.remove("Mplus Run Models.log")
}

}
