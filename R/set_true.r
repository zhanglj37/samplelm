


set_true <- function(var = "X", nv, locv, ly_matrix, fix = "NO")
{
	varloc = c("X", "M", "Y")
	varloci = which(varloc == var)
	
	cat(
		var, " by \n\t\t",
		file = paste("sample.inp", sep = ''), append = T)

	if (fix == "NO" || fix == "variance")
	{
		for (vi in 1:nv)
		{

			if (vi < nv)
			{
				cat(
					paste0(tolower(var), vi, "*",
					ly_matrix[locv[vi], varloci]), "\n\t\t",
					file = paste("sample.inp", sep = ''), append = T)

			}else{
				cat(
					paste0(tolower(var), vi, "*",
					ly_matrix[locv[vi], varloci]), "; \n\t",
					file = paste("sample.inp", sep = ''), append = T)
			}
		}
	}else if (fix == "ly")
	{
		for (vi in 1:nv)
		{

			if (vi == 1)
			{
				cat(
					paste0(tolower(var), vi), "\n\t\t",
					file = paste("sample.inp", sep = ''), append = T)

			}else if(vi == nv){
				cat(
					paste0(tolower(var), vi, "*",
					ly_matrix[locv[vi], varloci]), "; \n\t",
					file = paste("sample.inp", sep = ''), append = T)
			}else{
				cat(
					paste0(tolower(var), vi, "*",
					ly_matrix[locv[vi], varloci]), "\n\t\t",
					file = paste("sample.inp", sep = ''), append = T)
					
			}
		}
	
	
	}


	if (fix == "variance")
	{
		cat(
			paste0(var, "@", 1), ";\n\t",
			file = paste("sample.inp", sep = ''), append = T)
	}else if (fix == "ly")
	{
		cat(
			paste0(var, "*", 1), ";\n\t",
			file = paste("sample.inp", sep = ''), append = T)	
	}

}


