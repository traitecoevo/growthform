##' Build a lookup table for a set of species, connecting the species names to growth form
##'
##'
##' @title Build a lookup table for a set of species, connecting the species names to growth form
##' @param species_list Character vector of species bionomials  Genus and species may be seperated by  " "
##' or "_"
##' @param lookup_table Any growth form lookup table, but by default \code{\link{growth_form}}
##' @param genus_column The column within \code{lookup_table} that
##' corresponds to genus.  By default this is \code{"genus"}, which is
##' the correct name for \code{\link{plant_lookup}}.
##' @param missing_action How to behave when there are species in the
##' \code{species_list} that are not found in the lookup table.
##' \code{"drop"} (the default) generates a table without these
##' genera, \code{"NA"} will leave the species as
##' missing values and \code{error} will throw an error.
##' @export

growth_form_lookup_table <- function(species_list, lookup_table=NULL,
                                     genus_column="genus",
                                     missing_action=c("drop", "NA", "error")
) {
  if (is.null(lookup_table)) {
    lookup_table <- growth_form()
  }
  
  missing_action <- match.arg(missing_action)
  
  genus_list <- split_genus(species_list)
  genera <- unique(genus_list)
  i <- match(genera, lookup_table[[genus_column]])
  
  if (any(is.na(i))) {
    if (missing_action == "drop") {
      genera <- genera[!is.na(i)]
      i <- i[!is.na(i)]
    } else if (missing_action == "error") {
      stop("Missing genera: ", pastec(genera[is.na(i)]))
    }
  }
  
  ret <- lookup_table[i, ]
  if (any(is.na(i)) && missing_action == "NA") {
    ret[[genus_column]][is.na(i)] <- genera[is.na(i)]
  }
  
  rownames(ret) <- NULL
  
  ret
}
