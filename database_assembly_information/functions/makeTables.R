
make.source.table<-function(data.out){
  out<-sort(table(data.out$source),decreasing = TRUE)
  write.csv(out,"output/source.table.csv",quote=FALSE)
}








