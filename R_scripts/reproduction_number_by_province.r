## R script to estimate the Instantaneous Reproduction Number by Province
##
## Incidence datasource
##   Ministry of health population and hospital reform (coronavirus 2019 page): http://www.sante.gov.dz/coronavirus/coronavirus-2019.html
##   Ministry of health population and hospital reform (epidemiological map): http://covid19.sante.gov.dz/carte/
##
## Package required 'EpiEStim'
##   Anne Cori (2020). EpiEstim: Estimate Time Varying Reproduction
##   Numbers from Epidemic Curves. R package version 2.2-3.
##   https://CRAN.R-project.org/package=EpiEstim
##
## Method
##   Estimating R on sliding weekly windows, with a parametric serial interval
##
## serial interval parameters
##   mean : 4.2
##   standard deviation : 2.9
##   source: 
##       Nishiura, H., Linton, N. M., & Akhmetzhanov, A. R. (2020). 
##       Serial interval of novel coronavirus (COVID-19) infections. 
##       International journal of infectious diseases : IJID : official publication of the International Society for Infectious Diseases, 93, 284.

##import data
data=read.csv(
	"https://raw.githubusercontent.com/EpidemiologieSantePublique/COVID19-ALGERIA/master/covid_19_data/daily_cases_by_provinces.csv",
	encoding="UTF-8"
)

##split data by province code
incidenceData=split(
	data.frame(dates=as.Date(data$Day),I=data$New.Cases),
	data$ISO_code
)

##load EpiEstim Package
library(EpiEstim)

##estimate R by province
##estimation from the first to the last non-zero incidence value
R_estimates=lapply(incidenceData,function(subData){
	try(estimate_R(
		subData[which.min(subData$I==0):(1+length(subData$I)-which.min(rev(subData$I)==0)),], 
		method="parametric_si",
		config = make_config(list(mean_si = 4.2, std_si = 2.9))
	),silent=TRUE)
})

##plot estimated R
##plot(R_estimates$"<ISO_code>"
##example
##for national data
##plot(R_estimates$"DZ") 
##for Algiers data
##plot(R_estimates$"DZ-16")
