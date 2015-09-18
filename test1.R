gen_hist = function(x, title){ 
hist(x, breaks = 20, main = title, xlab = 'Total Number of Steps', col = 'grey', cex.main = .9)    
#calculate mean and median 
mean_value = round(mean(x), 1) 
median_value = round(median(x), 1) 
#place lines for mean and median on histogram 
abline(v=mean_value, lwd = 3, col = 'blue') 
abline(v=median_value, lwd = 3, col = 'red') 
#create legend 
legend('topright', lty = 1, lwd = 3, col = c("blue", "red"), 
cex = .8,  
legend = c(paste('Mean: ', mean_value), 
paste('Median: ', median_value)) ) 
} 
 
gen_hist(dat_tbl_summary$total_steps, 'Number of Steps Taken Per Day') 
