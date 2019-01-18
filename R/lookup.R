##' Build a lookup table for a set of species, connecting the species names to growth form
##'
##'
##' @title Build a lookup table for a set of species, connecting the species names to growth form
##' @param species_list Character vector of species bionomials  Genus and species may be seperated by  " "
##' or "_"
##' @param lookup_table Any growth form lookup table, but by default \code{\link{growth_form}}
##' @param version Version number.  The default will load the most
##'   recent version on your computer or the most recent version known
##'   to the package if you have never downloaded the data before.
##'   With \code{growth_form_del}, specifying \code{version=NULL}
##'   will delete \emph{all} data sets.
##' @export

growth_form_lookup_table <- function(species_list, lookup_table=NULL,version=NULL){
  if (is.null(lookup_table)) {
    lookup_table <- growth_form(version)
  }
  species_list <- gsub("_"," ",species_list)
     
  out<-lookup_table[lookup_table$sp %in% species_list,]
  row.names(out)<-NULL
  return(out)
}
