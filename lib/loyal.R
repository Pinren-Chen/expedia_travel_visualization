# Hotel and Package percentage plot
load("data.Rdata")
pack_per<-sum(data$is_package==1)/dim(data)[1]
hotel_per<-length(data$hotel_id[data$is_package==0])/dim(data)[1]
if(!require("plotly")) install.packages("plotly")
library("plotly")
dat<-data.frame(product=factor(c("Package","Hotel only"),levels = c("Package","Hotel only")),percentage=c(pack_per,hotel_per))
pack_hotel <- ggplot(data=dat, aes(x=product, y=percentage, fill=product),width=0.3) +
  geom_bar(stat="identity")
pack_hotel <- ggplotly(pack_hotel)

# Hotel and Package percentage sperated by mobile and website
per_pac_mobile<-nrow(data[data$is_mobile==1&data$is_package==1,])/sum(data$is_mobile==1)
per_hot_mobile<-nrow(data[data$is_mobile==1&data$is_package==0,])/sum(data$is_mobile==1)
per_pac_web<-nrow(data[data$is_mobile==0&data$is_package==1,])/sum(data$is_mobile==0)
per_hot_web<-nrow(data[data$is_mobile==0&data$is_package==0,])/sum(data$is_mobile==0)
dat1<-data.frame(product=factor(c("Package","Package","Hotel only","Hotel only")), method=factor(c("On mobile","Website","On mobile","Website"),levels = c("On mobile","Website")),percent=c(per_pac_mobile,per_pac_web,per_hot_mobile,per_hot_web))
hp_mobile_website <- ggplot(data=dat1, aes(x=method, y=percent, fill=product)) +
  geom_bar(stat="identity", position=position_dodge())
hp_mobile_website <- ggplotly(hp_mobile_website)


# load loy_data_book
load("loy_data_book.Rdata")
a<-table(table(loy_data_book$user_id))
name<-names(a)[1:20]
index<-as.numeric(name)
Cumulative_book<-cumsum(a)[1:20]
a<-data.frame(index,Cumulative_book)
library(plotly)
plot_loy <- ggplot(a, aes(x=index, y=Cumulative_book)) +
  geom_point(shape=2)+
  geom_vline(xintercept=3,color='red')+
  geom_vline(xintercept=15,color='red')

# plot hour in the day of booking
load("normalUser_data_book.Rdata")
hour <- as.numeric(substr(loy_data_book$date_time,start=12,stop=13))
hour_normalUser<-as.numeric(substr(normalUser_data_book$date_time,start=12,stop=13))


library(plotly)
hour_plot <- plot_ly(alpha = 0.6) %>%
  add_histogram(x = ~hour,name="Normal Customer") %>%
  add_histogram(x = ~hour_normalUser, name="Loyalty Customer") %>%
  layout(barmode = "overlay",xaxis=list(title="Hour",breaks=24),yaxis=list(title="Frequency of booking"))

# Map of loyal customer
load("loy_data_book_us.Rdata")
state_code<-as.factor(c("AL","AK","AZ","AR ","CA" ,"CO" ,"CT","DE" ,"FL","GA" ,"HI" ,"ID" ,"IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT","NE", "NV", "NH", "NJ","NM"," NY", "NC"," ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"))
number<-table(loy_data_book_us$user_location_region)
loy_book_us_dataframe<-data.frame(number)
loy_book_us_dataframe$perc<-round(loy_book_us_dataframe$Freq/nrow(loy_data_book_us),2)
colnames(loy_book_us_dataframe)[1]<-"code"


loy_book_us_dataframe$hover<-with(loy_book_us_dataframe,paste("Frequency","<br>",Freq))
l<-list(color=toRGB("white"),width=2)
g <- list(
  scope = 'usa',
  projection = list(type = 'albers usa'),
  showlakes = TRUE,
  lakecolor = toRGB('white')
)
map_loy <- plot_geo(loy_book_us_dataframe, locationmode = 'USA-states') %>%
  add_trace(
    z = ~perc, text = ~hover, locations = ~code,
    color = ~perc, colors = 'Purples'
  ) %>%
  colorbar(title = "Percentage") %>%
  layout(
    title = '2015 Expedia\'s loyalty customers distribution',
    geo = g
  )
