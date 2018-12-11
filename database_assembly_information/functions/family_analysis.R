
insert.family.names<-function(names.df){
  require(taxonlookup)
  lookUp<-plant_lookup()
  genera<-taxonlookup:::split_genus(as.character(names.df$sp))
  names.df<-data.frame(sp=names.df$sp,support=names.df$support,
                       plant.list.accepted=names.df$plant.list.accepted,
                       genus=genera,stringsAsFactors = FALSE)
  names.df$family<-lookUp$family[match(genera,lookUp$genus)]
  names.df$group<-lookUp$group[match(genera,lookUp$genus)]
  return(names.df)
}

major.clade.mapping<-function(unique.species.with.families){
  require(taxonlookup)
  ao<-add_higher_order()
  unique.species.with.families$genus<-taxonlookup:::split_genus(unique.species.with.families$sp)
  unique.species.with.families$group<-ao$group[match(unique.species.with.families$genus,ao$genus)]
  unique.species.with.families$family<-ao$family[match(unique.species.with.families$genus,ao$genus)]
  unique.species.with.families$Mono<-ao$Monocotyledoneae[match(unique.species.with.families$genus,ao$genus)]
  unique.species.with.families$Eud<-ao$Eudicotyledoneae[match(unique.species.with.families$genus,ao$genus)]
  unique.species.with.families$major.clade<-unique.species.with.families$group
  unique.species.with.families$major.clade[unique.species.with.families$Eud==""&unique.species.with.families$Mono==""&unique.species.with.families$group=="Angiosperms"]<-"BasalAngiosperms"
  unique.species.with.families$major.clade[unique.species.with.families$Eud=="Eudicotyledoneae"]<-"Eudicot"
  unique.species.with.families$major.clade[unique.species.with.families$Mono=="Monocotyledoneae"]<-"Monocot"
  out<-dplyr::select(unique.species.with.families,sp,support,genus,family,group,major.clade)
  return(out)
}

do.family.sampling.analysis<-function(names.df){
  good.names<-plant_lookup(include_counts = TRUE)
  plantList<-summarize(group_by(good.names,family),num.sp=sum(number.of.species))
  data<-summarize(group_by(names.df,family),num.sp=length(sp))
  out<-merge(plantList,data,by="family",all=TRUE)
  out$num.sp.y[is.na(out$num.sp.y)]<-0
  out$num.sp.x[is.na(out$num.sp.x)]<-0
  names(out)[2]<-"plant.list.species"
  names(out)[3]<-"data.set.species"
  out$percentage<-out$data.set.species/out$plant.list.species
  return(arrange(out,percentage))
}

do.family.gf.analysis<-function(unique.species.with.families,gf.code){
  require(dplyr)
  good.names<-plant_lookup(include_counts = TRUE)
  good.names<-dplyr::filter(good.names,group!="Bryophytes")
  plantList<-summarize(group_by(good.names,family),num.sp=sum(number.of.species))
  data<-summarize(group_by(unique.species.with.families,family),num.sp.yes=sum(support==gf.code),num.sp.no=sum(support!=gf.code),major.clade=major.clade[1])
  out<-merge(plantList,data,by="family",all=TRUE)
  out$num.sp.yes[is.na(out$num.sp.yes)]<-0
  out$num.sp.no[is.na(out$num.sp.no)]<-0
  out$percent<-out$num.sp.yes/(out$num.sp.yes+out$num.sp.no)
  return(out)
}


make.figures<-function(df){
  library(treemap)
  unique.species.with.families<-insert.family.names(df)
  unique.species.with.families<-major.clade.mapping(unique.species.with.families)
  climbers<-do.family.gf.analysis(unique.species.with.families,"C")

  pdf("figures/climbers_in_gf_database_by_family.pdf",width=8.5,height=11)
  treemap(climbers,
          index=c("major.clade","family"),
          vSize="num.sp",
          vColor="percent",
          type="manual",
          palette=brewer.pal(9,"PuBuGn"),
          range=c(0,1),
          title.legend="Proportion of species that are climbers",
          title="Distribution of climbers among clades of vascular plants")
  dev.off()

  epi<-do.family.gf.analysis(unique.species.with.families,"E")

  pdf("figures/epiphytes_in_gf_database_by_family.pdf",width=8.5,height=11)
  treemap(epi,
          index=c("major.clade","family"),
          vSize="num.sp",
          vColor="percent",
          type="manual",
          palette=brewer.pal(9,"PuBuGn"),
          range=c(0,1),
          title.legend="Proportion of species that are epiphytes",
          title="Distribution of epiphytes among clades of vascular plants")
  dev.off()

}

# climbers<-do.family.gf.analysis(unique.species.with.families,"C")
#
# pdf("climbers_in_gf_database_by_family.pdf",width=8.5,height=11)
# treemap(climbers,
#         index=c("family"),
#         vSize="num.sp",
#         vColor="percent",
#         type="manual",
#         palette=brewer.pal(9,"PuBuGn"),
#         range=c(0,1),
#         title="Proportion of climbers ")
# dev.off()
#
# epiphytes<-do.family.gf.analysis(unique.species.with.families,"E")
#
# pdf("epiphytes_in_gf_database_by_family.pdf",width=8.5,height=11)
# treemap(epiphytes,
#         index=c("family"),
#         vSize="num.sp",
#         vColor="percent",
#         type="manual",
#         palette=brewer.pal(9,"PuBuGn"),
#         range=c(0,1),
#         title="Proportion of epiphytes ")
# dev.off()




output.family.summary<-function(plant.list.names){
  plant.list.names$support<-as.factor(plant.list.names$support)
  table(plant.list.names$support)
  fam.ss<-tapply(plant.list.names$support,INDEX=plant.list.names$family,FUN=table)
  write.csv(do.call(rbind,fam.ss),"output/familySummary.csv",row.names=T)
}


output.major.clade.summary<-function(plant.list.names){
  library(Gmisc)
  plant.list.names<-major.clade.mapping(plant.list.names)
  out<-getDescriptionStatsBy(plant.list.names$support,plant.list.names$major.clade)
  print(htmlTable(out),"help.html")
  write.csv(out,"output/majorCladeSummary.csv",row.names=T)
}

