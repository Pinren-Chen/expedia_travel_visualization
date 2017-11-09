dest$index=index_class

split=split(dest,f=dest$index)

cluster_mean=sapply(split,function(r) apply(r[,6:144],2,mean))

dest$label=colnames(dest)[apply(dest,1,function(r) which.max(r[6:144]))]

count_table=table(dest$label,dest$index)


feature=NULL
for(i in 1:4){
  feature[[i]]=rownames(count_table)[order(count_table[,i],decreasing =T)[1:5]]
}




clouddat1=data.frame(word=c("countryside","boating","sea","nature","tropical"),important=10*c(0.9,0.7,0.6,0.5,0.4))


clouddat2=data.frame(word=c("countryside","architecture","adventure","familyfriendly","dining"),important=10*c(0.9,0.7,0.6,0.5,0.4))

clouddat3=data.frame(word=c("countryside","sea","family","architecuture","dining"),important=10*c(0.9,0.7,0.6,0.5,0.4))


clouddat4=data.frame(word=c("architecture","countryside","family","boating","ruins"),important=10*c(0.9,0.7,0.6,0.5,0.4))

eWordcloud(clouddat1, namevar = ~word, datavar =~important,size = c(800, 800),title = "type I",rotationRange = c(-20, 20))
eWordcloud(clouddat2, namevar = ~word, datavar =~important,size = c(800, 800),title = "type II",rotationRange = c(-20, 20))
eWordcloud(clouddat3, namevar = ~word, datavar =~important,size = c(800, 800),title = "type III",rotationRange = c(-20, 20))
eWordcloud(clouddat4, namevar = ~word, datavar =~important,size = c(800, 800),title = "summer & Torridzone",rotationRange = c(-20, 20))



eWordcloud(wordFreqDf_chs, namevar = ~Word, datavar = ~Freq)