
make.source.table<-function(data.out){
  out<-sort(table(data.out$source),decreasing = TRUE)
  write.csv(out,"output/source.table.csv",quote=FALSE)
}


output.good.data<-function(all.data){
  library(dplyr)
  number.of.levels<-summarize(group_by(all.data,sp),num.val=length(unique(support)))
  problems<-number.of.levels$sp[number.of.levels$num.val>1]
  no.prob<-number.of.levels$sp[number.of.levels$num.val==1]
  filter(all.data,sp%in%no.prob) %>%
    arrange(sp)->out
  return(out)
}

output.unique.species.dataset<-function(all.data){
  good.data<-output.good.data(all.data)
  dropped.source<-select(good.data,sp,support)
  unique.spp <- dropped.source[!duplicated(dropped.source),]
  return(unique.spp)
}





