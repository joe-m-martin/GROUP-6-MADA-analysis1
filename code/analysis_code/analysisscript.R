###############################
# analysis script
#
#this script loads the processed, cleaned data, does a simple analysis
#and saves the results to the results folder

#load needed packages. make sure they are installed.
library(ggplot2) #for plotting
library(broom) #for cleaning up output from lm()
library(here) #for data loading/saving

#path to data
#note the use of the here() package and not absolute paths
data_location <- here::here("data","processed_data","processeddata.rds")

#load data. 
mydata <- readRDS(data_location)

######################################
#Data exploration/description
######################################
#I'm using basic R commands here.
#Lots of good packages exist to do more.
#For instance check out the tableone or skimr packages

#summarize data 
mysummary = summary(mydata)

#look at summary
print(mysummary)

#do the same, but with a bit of trickery to get things into the 
#shape of a data frame (for easier saving/showing in manuscript)
summary_df = data.frame(do.call(cbind, lapply(mydata, summary)))

#save data frame table to file for later use in manuscript
summarytable_file = here("results", "summarytable.rds")
saveRDS(summary_df, file = summarytable_file)


#creates a boxplot with the new categorical variable (Temperature) on the x-axis, and height on the y-axis.
#we also add a linear regression line to it
p1 <- ggplot(mydata, aes(x=Temperature, y=Height)) + geom_boxplot() + geom_smooth(method='lm')
#look at figure
plot(p1)
#save figure
figure_file1 = here("results","resultfigure1.png")
ggsave(filename = figure_file1, plot=p1)  

##create another scatterplot with weight on the x-axis and the new numerical variable (Temperature) on the y-axis
p2 <- ggplot(mydata, aes(x=Weight, y=Temperature, colour ="red")) + geom_point() + geom_smooth(method='lm')
#look at figure
plot(p2)
#save figure
figure_file2 = here("results","resultfigure2.png")
ggsave(filename = figure_file2, plot=p2) 
######################################
#Data fitting/statistical analysis
######################################

# fit linear model
lmfit <- lm(Weight ~ Height, mydata)  

# place results from fit into a data frame with the tidy function
lmtable <- broom::tidy(lmfit)

#look at fit results
print(lmtable)

# save fit results table  
table_file = here("results", "resulttable.rds")
saveRDS(lmtable, file = table_file)

  