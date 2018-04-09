
<!-- README.md is generated from README.Rmd. Please edit that file -->

**This is highly experimental**

![](https://img.shields.io/badge/lifecycle-experimental-orange.svg)

# namespaces

The goal of namespaces is to find minimal versions of dependencies of a
package by inspecting `NAMESPACE` and `DESCRIPTION` files of those
dependencies from the [r-pkg.org CRAN mirror](https://github.com/cran).
The method hence does not ensure the minimal version found is enough to
make the code work, it just ensures that functions imported from
dependencies were exported in those package versions indicated in
`DESCRIPTION`.

## Example

You can find out in which release an object was exported for the first
time.

``` r
library("namespaces")
find_first_release("dplyr", "mutate")
#> [1] "0.1"
```

You can collect all minimal dependencies of a package by inspecting
masked function calls (`pkg::fun()`) in your source code and the
`NAMESPACE` of the package

``` r
library("dplyr")
collect_minimal_dependencies() %>%
  group_by(package) %>%
  summarize(min(first_release))
#> # A tibble: 8 x 2
#>   package   `min(first_release)`
#>   <chr>     <chr>               
#> 1 base64enc 0.1-0               
#> 2 desc      1.0.0               
#> 3 enc       0.1                 
#> 4 gh        1.0.1               
#> 5 magrittr  1.0.0               
#> 6 purrr     0.1.0               
#> 7 rlang     0.1                 
#> 8 tibble    1.4.2
```

If you want to do namespaces analysis, you can also parse any namespace
from any package from CRAN.

``` r
parse_cran_namespace("xgboost")
#> # A tibble: 77 x 2
#>    type     object                      
#>    <chr>    <chr>                       
#>  1 S3method "\"[\",xgb.DMatrix"         
#>  2 S3method "\"dimnames<-\",xgb.DMatrix"
#>  3 S3method dim,xgb.DMatrix             
#>  4 S3method dimnames,xgb.DMatrix        
#>  5 S3method getinfo,xgb.DMatrix         
#>  6 S3method predict,xgb.Booster         
#>  7 S3method predict,xgb.Booster.handle  
#>  8 S3method print,xgb.Booster           
#>  9 S3method print,xgb.DMatrix           
#> 10 S3method print,xgb.cv.synchronous    
#> # ... with 67 more rows
```

Or a local name space:

``` r
parse_local_namespace(here::here())
#> # A tibble: 22 x 2
#>    type       object                      
#>    <chr>      <chr>                       
#>  1 export     collect_minimal_dependencies
#>  2 export     find_first_release          
#>  3 export     parse_cran_namespace        
#>  4 export     parse_local_namespace       
#>  5 export     write_minimal_dependencies  
#>  6 import     gh                          
#>  7 import     tibble                      
#>  8 importFrom desc,desc_set_dep           
#>  9 importFrom desc,description            
#> 10 importFrom "magrittr,\"%>%\""          
#> # ... with 12 more rows
```

You can update all `DESCRIPTION` entries to match the minimal versions
required found with the above function.

``` r
# write_minimal_dependencies() # does not yet work.
```
