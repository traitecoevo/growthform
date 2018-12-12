##' Build a lookup table for a set of species, connecting the species names to growth form
##'
##'
##' @title Build a lookup table for a set of species, connecting the species names to growth form
##' @param species_list Character vector of species bionomials  Genus and species may be seperated by  " "
##' or "_"
##' @param lookup_table Any growth form lookup table, but by default \code{\link{growth_form}}

##' @export

growth_form_lookup_table <- function(species_list, lookup_table=NULL){
  if (is.null(lookup_table)) {
    lookup_table <- growth_form()
  }
  species_list <- gsub("_"," ",species_list)
     
  out<-lookup_table[lookup_table$sp %in% species_list,]
  return(out)
}
