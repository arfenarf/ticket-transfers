---
title: "Transferred Calls"
author: "KGW"
date: "December 10, 2015"
output: html_document
---

WITHOUT FROM SD or TD, last 6 months = 109278.
WITH them, 200156



```r
#throat-clearing

require(dplyr)
require(rCharts)
require(knitr)

setwd("~/datacourse/small projects")
filepath <- "incident-metrics/"

#data-obtaining
d <- ""
file.names <- dir(filepath, pattern =".csv")
for(i in 1:length(file.names)){
     file <- read.csv(paste(filepath,file.names[i],sep = ''), stringsAsFactors=FALSE)
     d <- rbind(d, file)
}
sps <- read.csv('service-providers.csv',stringsAsFactors = FALSE)

#data-tidying

# we have to get the legacy units  out of ITS
names(sps) = c('from_ag', 'from_sp')
sps[grep("UNIT", sps$from_ag),2] <- sps[grep("UNIT", sps$from_ag),1]

#strip out unneeded columns, rename, and retrieve the from_sp
d <- select(d,mi_value,inc_assignment_group,inc_u_service_provider)
names(d) = c('from_ag', 'to_ag', 'to_sp')
d <- merge(d, sps, by = 'from_ag') #get the from_sp
d <- filter(d, (from_sp != 'ITS')) #drop the ITS froms
dt <- data.frame(table(d$from_sp, d$to_ag)) #cross-tabulate

names(dt) <- c('source', 'target', 'value')
dt$source <- as.character(dt$source)
dt$target <- as.character(dt$target)
dt <- filter(dt, value >0) #drop the zeroes
dt <- filter(dt, source != target) #make sure there are no loops

#Make the chart object
sankeyPlot <- rCharts$new()
sankeyPlot$setLib('http://timelyportfolio.github.io/rCharts_d3_sankey')
sankeyPlot$set(
     data = dt,
     nodeWidth = 15,
     nodePadding = 10,
     layout = 32,
     width = 900,
     height = 1200,
     title = "Transferred Calls"
)

# #publish
# 
# #sankeyPlot$save('sankeytrial.html', cdn=FALSE)
sankeyPlot
```

```
## <iframe src=' figure/unnamed-chunk-1-1.html ' scrolling='no' frameBorder='0' seamless class='rChart http://timelyportfolio.github.io/rCharts_d3_sankey ' id=iframe- chart6ae350f66776 ></iframe> <style>iframe.rChart{ width: 100%; height: 400px;}</style>
```

You can also embed plots, for example:

Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.
