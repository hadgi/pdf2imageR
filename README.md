# pdf2imageR

__RStudio Addin__

A Shiny gadget to render pdf files as images in RStudio.

Intended for staying inside RStudio when consulting academic papers or manuals. 
Because running the Shiny process takes over the R session, it is not possible to run code while reading, which is a serious limitation to authoring in RMarkdown.

To install nevertheless:  

``` r
if(!require(devtools)) install.packages("devtools")
library("devtools")
install_github(repo = "hlageek/pdf2imageR")
```

![alt text](https://github.com/hadgi/pdf2imageR/blob/master/img/pdf2imageR_printscreen.png "Example RStudio screen")

