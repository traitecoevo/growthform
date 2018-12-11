
add.family.order<-function(gf){
  require(taxonlookup)
  lookUp<-plant_lookup()
  gf$family<-lookUp$family[match(gf$genus,lookUp$genus)]
  gf$order<-lookUp$order[match(gf$genus,lookUp$genus)]
  gf$group<-lookUp$group[match(gf$genus,lookUp$genus)]
  return(gf)
}

loadData<-function(){
  library(dplyr)
  pl<-read.csv("rawdata/uniqueSpeciesGFData.csv",stringsAsFactors=FALSE)
  return(filter(pl,plant.list.accepted))
}

get_pl_species_by_genus_counts<-function(){
  require(taxonlookup)
  pl_names<-get_good_names()
  out<-data.frame(genus=taxonlookup:::split_genus(pl_names),species=pl_names,stringsAsFactors = FALSE)
  num.of.species.by.genus<-summarize(group_by(out,genus),N=length(species))
  return(num.of.species.by.genus)
}

get_good_names<-function(){
  read.csv("taxonomicResources/goodnames.csv",as.is=TRUE,header=FALSE)$V1
}

count.growth.form<-function(gf=gf,growth.form.code){
  gf$climber.logical<-gf$support==growth.form.code
  gf.climber<-summarize(group_by(gf,genus),n1=sum(climber.logical),n0=sum(!climber.logical))
}

get.traitfill.format<-function(plant.list.names,growthFormCode){
  require(taxonlookup)
  gf<-data.frame(genus=taxonlookup:::split_genus(plant.list.names$sp),plant.list.names,stringsAsFactors = FALSE)
  gf.growth.form.count<-count.growth.form(gf,growthFormCode)
  merged_pl_gf<-merge(get_pl_species_by_genus_counts(),gf.growth.form.count,by="genus",all.x=T)
  merged_pl_gf$n1[is.na(merged_pl_gf$n1)]<-0
  merged_pl_gf$n0[is.na(merged_pl_gf$n0)]<-0
  merged_pl_gf$n0[merged_pl_gf$genus=="Angiopteris"]<-1
  gf_with_fam_order<-add.family.order(merged_pl_gf)
  gf_without_mosses<-filter(gf_with_fam_order,group!="Bryophytes")
  #gf_without_mosses$order[gf_without_mosses$order==""]<-paste0("Unplaced",gf_without_mosses$family[gf_without_mosses$order==""])
  return(gf_without_mosses)
}

set.up.and.run.traitfill<-function(growthFormCode,nrep,plant.list.names){
  gf_without_mosses<-get.traitfill.format(plant.list.names,growthFormCode)  
  results<-traitfill(gf_without_mosses,nrep,with_replacement = T)
  results.F<-traitfill(gf_without_mosses,nrep,with_replacement = F)
  return(rbind(cbind(results$overall,gf=growthFormCode),
               cbind(results.F$overall,gf=growthFormCode)))
}

#THIS FUNCTION NEEDS SOME GENERALIZING
run.traitfill<-function(plant.list.names,nrep=5){
  library(traitfill)
  #gf<-unique(plant.list.names$support)
  outC<-set.up.and.run.traitfill("C",nrep,plant.list.names)
  print(outC)
  outA<-set.up.and.run.traitfill("A",nrep,plant.list.names)
  outM<-set.up.and.run.traitfill("M",nrep,plant.list.names)
  outP<-set.up.and.run.traitfill("P",nrep,plant.list.names)
  outE<-set.up.and.run.traitfill("E",nrep,plant.list.names)
  outF<-set.up.and.run.traitfill("F",nrep,plant.list.names)
  outH<-set.up.and.run.traitfill("H",nrep,plant.list.names)
  out<-rbind(outC,outA,outM,outP,outE,outF,outH)
  print(out)
  write.csv(out,"output/traitfillResults.csv",row.names=FALSE,quote=FALSE)
}

