
growthform: a versioned lookup table for the growth form of vascular plants
===========================================================================

[![Build Status](https://travis-ci.org/traitecoevo/growthform.png?branch=master)](https://travis-ci.org/traitecoevo/taxonlookup) [![codecov.io](https://codecov.io/github/traitecoevo/growthform/coverage.svg?branch=master)](https://codecov.io/github/traitecoevo/growthform?branch=master) [![DOI](https://zenodo.org/badge/161406874.svg)](https://zenodo.org/badge/latestdoi/161406874)

**Problem:** You have a list of species from anywhere in the world. You've fixed the names, but you'd like to know something about the species' growth forms.

**Solution:** We've put together a growing list of growth forms, currently (&gt;140,000 species). This list lives in this github repository. If you want the whole list, head to [our github releases tab and download the whole thing](https://github.com/traitecoevo/growthform/releases). If you want the ones that correspond to your list, load your list into R and follow the steps below. This package combines three separate giant database assembly efforts to build large lists of plant growth forms (see sources below).

How to use this package
-----------------------

### Install the required packages

``` r
#install.packages("devtools") # if necessary
devtools::install_github("ropenscilabs/datastorr")
devtools::install_github("traitecoevo/growthform")
```

### Load the growthform package

``` r
library(growthform)
```

### Find the growth form for your species list

Once the package is installed, this can be done with one line of code, making sure you have nice clean and standard species names with proper capitalization and no extra spaces. Words that are not a valid species name will currently return nothing. Species that are in one of the databases but not the others will reture `NA` for that column.

``` r
growth_form_lookup_table(c("Acacia longifolia","Quercus agrifolia",
                           "Clematis lasiantha","Hedera helix",
                          "Ficus tremula","Najas flexilis", "Not a species"))
```

    ##                   sp support woodiness nfixing
    ## 1  Acacia longifolia       F         W     Yes
    ## 2 Clematis lasiantha       C         W      No
    ## 3      Ficus tremula       H         W    <NA>
    ## 4       Hedera helix       C         W      No
    ## 5     Najas flexilis       A         H    <NA>
    ## 6  Quercus agrifolia       F         W      No

For the `support` column,: "F" is for free standing; "C" is for climber; "E" is for epiphyte, "P" is for parasite; "M" is for (holo)-mycoheterotroph; "A" is for aquatic; and "H" is for hemiepiphyte.

For the `woodiness` column,: "W" is for woody; "H" is for herbaceous.

For the `nfixing` column,: "yes" is for yes it forms n-fixing nodules; "no" is for no it doesn't. There are many species that presumably do not form N-fixing nodules based on their phylogentic position, but if no one has checked, they will show up as NA in this database.

If you want a tree versus shrub split, [others have tackled that difficult problem](https://www.bbc.com/news/science-environment-39492977).

That's it, really. Below is information about the data sources and the versioned data distribution system (which we think is really cool), feel free to check it out, but you don't need to read the rest of this to use the package.

### Citing these data

For the `support` column please cite:

**Taseski, G. , Beloe, C. J., Gallagher, R. V., Chan, J. Y., Dalrymple, R. L. and Cornwell, W. K.** (2019), A global growth form database for 143,616 vascular plant species. *Ecology*. Accepted Author Manuscript. <https://doi.org/10.1002/ecy.2614>

For the `woodiness` column please cite:

**Zanne AE, Tank DC, Cornwell WK, Eastman JM, Smith SA, FitzJohn RG, McGlinn DJ, O'Meara BC, Moles AT, Reich PB, Royer DL, Soltis DE, Stevens PF, Westoby M, Wright IJ, Aarssen L, Bertin RI, Calaminus A, Govaerts R, Hemmings F, Leishman MR, Oleksyn J, Soltis PS, Swenson NG, Warman L, Beaulieu JM, Ordonez A** (2014) Three keys to the radiation of angiosperms into freezing environments. *Nature* 506(7486): 89–92. <https://doi.org/10.1038/nature12872>

For the `nfixing` column please cite:

**Werner GDA, Cornwell WK, Sprent JI, Kattge J, Kiers ET** (2014) A single evolutionary innovation drives the deep evolution of symbiotic N2-fixation in angiosperms. *Nature Communications* 5: 4087. <https://doi.org/10.1038/ncomms5087>

### Errors and more data

If you find something to correct or a new amazing dataset to add to this, please raise an [issue](https://github.com/traitecoevo/growthform/issues). We'd like this to keep growing and getting better with time and use.

### Reproducing a specific version

If you are publishing a paper with this library, or you want the results of your analysis to be reproducible for any other reason, include the version number in your call to lookup table. This will always pull the specific version of the taxonomy lookup that you used. If you leave this out, on a new machine the library will download the most recent version of the database rather than the specific one that you used.

``` r
growth_form_lookup_table(c("Acacia longifolia", "Quercus agrifolia"),version="0.2.3")
```

    ##                  sp support woodiness nfixing
    ## 1 Acacia longifolia       F         W     Yes
    ## 2 Quercus agrifolia       F         W      No

------------------------------------------------------------------------

Data sources
------------

All this relies on the botanists that orginially classified these species in the field, but unfortunately they are too many to list here. Check [here](https://github.com/traitecoevo/growthform/tree/master/database_assembly_information/original_references) for a complete list of where these data come from.

Details about the data distribution system
------------------------------------------

This is designed to be a living database--it will update as taxonomy and data changes (which they always will). These updates will correspond with changes to the version number of this resource, and each version of the database will be available via [Github Releases](http://docs.travis-ci.com/user/deployment/releases/). If you use this resource for published analysis, please note the version number in your publication. This will allow anyone in the future to go back and find **exactly** the same version of the data that you used.

Because Releases can be altered after the fact, we use [zenodo-github integration](https://guides.github.com/activities/citable-code/) to mint a DOI for each release. This will both give a citable DOI and help with the longevity of each version of the database. (Read more about this [here](https://www.software.ac.uk/blog/2016-09-26-making-code-citable-zenodo-and-github).)

### Details about the data distribution system

You can download and load the data into `R` using the `growth_form()` function:

``` r
head(growth_form())
```

    ##               sp support woodiness nfixing
    ## 1  Aa achalensis       F      <NA>    <NA>
    ## 2 Aa argyrolepis       F      <NA>    <NA>
    ## 3  Aa aurantiaca       F      <NA>    <NA>
    ## 4    Aa calceata       F      <NA>    <NA>
    ## 5  Aa colombiana       F      <NA>    <NA>
    ## 6 Aa denticulata       F      <NA>    <NA>

To get the version number of the dataset run:

``` r
growth_form_version_current_local()
```

    ## [1] "0.2.3"

For the most current version on Github run:

``` r
growth_form_version_current_github()
```

    ## [1] "0.2.3"

For most uses, the latest release should be sufficient, and this is all that is necessary to use the data.

Living database
===============

Development version
-------------------

We will periodically release development versions of the database using github releases. We'll check these automatically using [travis-ci](http://travis-ci.org). As taxonomy is a moving target, we expect that the lookup to change with time.

Notes for making a release using this *living dataset* design
=============================================================

-   Update the `DESCRIPTION` file to **increase** the version number. Now that we are past version 1.0.0, we will use [semantic versioning](http://semver.org/) so be aware of when to change what number.
-   Rebuild datafile
-   Commit code changes and `DESCRIPTION` and push to GitHub
-   With R in the package directory, run

``` r
growthform:::growth_form_release("<description>")
```

where `"<description>"` is a brief description of new features of the release.

-   Check that it works by running `growthform::growth_form()`
-   Update the Zenodo badge on the readme
