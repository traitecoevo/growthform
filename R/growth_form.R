##' Lookup table for plant growth form
##'
##' 
##' These data are then currated--please flag any errors or potential additions on github
##' are at https://github.com/wcornwell/growthformdatabase
##'
##' @title Plant growthform lookup table
##'
##' @param version Version number.  The default will load the most
##'   recent version on your computer or the most recent version known
##'   to the package if you have never downloaded the data before.
##'   With \code{growth_form_del}, specifying \code{version=NULL}
##'   will delete \emph{all} data sets.
##'
##'
##'
##' @export
##' @import storr
##' @examples
##' #
##' # see the format of the resource
##' #
##' head(growth_form())
##' 

growth_form <- function(version=NULL) {
  d <- growth_form_get(version)
  return(d)
}

## This one is the important part; it defines the three core bits of
## information we need;
##   1. the repository name (wcornwell/taxonlookup)
##   2. the file to download growth_form.csv)
##   3. the function to read the file, given a filename (read_csv)
growth_form_info <- function() {
  github_release_storr_info("cornwell-lab-unsw/growthformdatabase",
                            "growth_form.csv",
                            read_csv)
}

## Below here are wrappers around the storr functions but with our
## information object.  We could actually save growth_form_info() as
## an *object* in the package, but I prefer this approach.
growth_form_get <- function(version=NULL) {
  github_release_storr_get(growth_form_info(), version)
}

##' @export
##' @rdname growth_form
##' @param type Type of version to return: options are "local"
##'   (versions installed locally) or "github" (versions available on
##'   github).  With any luck, "github" is a superset of "local".  For
##'   \code{growth_form_version_current}, if "local" is given, but there
##'   are no local versions, then we do check for the most recent
##'   github version.
growth_form_versions <- function(type="local") {
  github_release_storr_versions(growth_form_info(), type)
}

##' @export
##' @rdname growth_form
growth_form_version_current <- function(type="local") {
  github_release_storr_version_current(growth_form_info(), type)
}

##' @export
##' @rdname growth_form
growth_form_del <- function(version) {
  github_release_storr_del(growth_form_info(), version)
}

read_csv <- function(...) {
  read.csv(..., stringsAsFactors=FALSE)
}
