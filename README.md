
growthform: a versioned lookup table for the growth form of vascular plants
===========================================================================

How to use this package
-----------------------

### Install the required packages

``` r
#istall.packages("devtools") # if necessary
devtools::install_github("ropenscilabs/datastorr")
devtools::install_github("traitecoevo/growthform")
library(growthform)
```

### Find the growth form for your species list

``` r
growth_form_lookup_table(c("Pinus ponderosa","Quercus agrifolia","Clematis lasiantha","Hedera helix","Aechmea cylindrata","Ficus tremula","Amyema bifurcata","Sciaphila khasiana","Najas flexilis"))
```

    ##                        sp support plant.list.accepted
    ## 3272   Aechmea cylindrata       E                TRUE
    ## 8255     Amyema bifurcata       P                TRUE
    ## 32005  Clematis lasiantha       C                TRUE
    ## 61155       Ficus tremula       H                TRUE
    ## 69515        Hedera helix       C                TRUE
    ## 93956      Najas flexilis       A                TRUE
    ## 107375    Pinus ponderosa       F                TRUE
    ## 115069  Quercus agrifolia       F                TRUE
    ## 122217 Sciaphila khasiana       M                TRUE

"F"" is for free standing; "C" is for climber; "E" is for epiphyte, "P" is for parasite; "M" is for (holo)-mycoheterotroph; "A" is for aquatic; and "H" is for hemiepiphyte.

If you are looking for a woody versus non-woody split check [here](https://datadryad.org/resource/doi:10.5061/dryad.63q27).

If you want tree versus shrubs, we thought that was too tough to try, but other people have done some things on that.

That's it, really. Below is information about the data sources and the versioned data distribution system (which we think is really cool), feel free to check it out, but you don't need to read the rest of this to use the package.

### Reproducing a specific version

If you are publishing a paper with this library, or you want the results of your analysis to be reproducable for any other reason, include the version number in your call to lookup table. This will always pull the specific version of the taxonomy lookup that you used. If you leave this out, on a new machine the library will download the most recent version of the database rather than the specific one that you used.

``` r
growth_form_lookup_table(c("Pinus ponderosa", "Quercus agrifolia"))
```

    ##                       sp support plant.list.accepted
    ## 107375   Pinus ponderosa       F                TRUE
    ## 115069 Quercus agrifolia       F                TRUE

------------------------------------------------------------------------

Data sources
------------

Too many to list here. Check [here](https://github.com/traitecoevo/growthform/tree/master/database_assembly_information/original_references)

Details about the data distribution system
------------------------------------------

This is designed to be a living database--it will update as taxonomy and data changes (which they always will). These updates will correspond with changes to the version number of this resource, and each version of the database will be available via [Github Releases](http://docs.travis-ci.com/user/deployment/releases/). If you use this resource for published analysis, please note the version number in your publication. This will allow anyone in the future to go back and find **exactly** the same version of the data that you used.

Because Releases can be altered after the fact, we use [zenodo-github integration](https://guides.github.com/activities/citable-code/) to mint a DOI for each release. This will both give a citable DOI and help with the logevity of each version of the database. (Read more about this [here](https://www.software.ac.uk/blog/2016-09-26-making-code-citable-zenodo-and-github).)

### Details about the data distribution system

You can download and load the data into `R` using the `growth_form()` function:

``` r
head(growth_form())
```

    ##               sp support plant.list.accepted
    ## 1  Aa achalensis       F                TRUE
    ## 2 Aa argyrolepis       F                TRUE
    ## 3  Aa aurantiaca       F                TRUE
    ## 4    Aa calceata       F                TRUE
    ## 5  Aa colombiana       F                TRUE
    ## 6 Aa denticulata       F                TRUE

To get the version number of the dataset run:

``` r
growth_form_version_current_local()
```

    ## [1] "0.1.0"

For the most current version on Github run:

``` r
growth_form_version_current_github()
```

    ## [1] "0.1.0"

For most uses, the latest release should be sufficient, and this is all that is necessary to use the data.

Living database
===============

Development version
-------------------

We will periodically release development versions of the database using github releases. We'll check these automatically using [travis-ci](http://travis-ci.org). As taxonomy is a moving target, we expect that the lookup to change with time.

Notes for making a release using this *living dataset* design
=============================================================

-   Update the `DESCRIPTION` file to **increase** the version number. Now that we are past version 1.0.0, we will use [semantic versioning](http://semver.org/) so be aware of when to change what number.
-   Run `remake::make()` to rebuild `plant_lookup.csv`
-   Commit code changes and `DESCRIPTION` and push to GitHub
-   With R in the package directory, run

``` r
growthform:::growth_form_release("<description>")
```

where `"<description>"` is a brief description of new features of the release.

-   Check that it works by running `growthform::growth_form()`
-   Update the Zenodo badge on the readme
