if(!require("data.table")) install.packages("data.table")
library("data.table")
data<-fread("data.txt",header = TRUE)
if(!require("dplyr")) install.packages("dplyr")
library(dplyr)
loy_userid<-unique(data$user_id[duplicated(data$user_id)])
loy_data<-data%>%filter(data$user_id%in%loy_userid)
loy_data_book<-loy_data[loy_data$is_booking==1,]

# loy_data is the data frame for loyal user

loy_userid<-names(sort(table(loy_data_book$user_id))[sort(table(loy_data_book$user_id))<=15&sort(table(loy_data_book$user_id))>=3])
loy_data<-data%>%filter(data$user_id%in%loy_userid)

# userid for customers who booked 1~2 times
normal_userid<-names(sort(table(loy_data_book$user_id))[sort(table(loy_data_book$user_id))<3])
click_userid<-data$user_id[data$is_booking==0]
