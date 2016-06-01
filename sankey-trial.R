#throat-clearing

require(dplyr)
require(rCharts)
setwd("~/datacourse/small projects")
filepath <- "incident-metrics/"
direction <- 'to-its'

#data-obtaining
d <- ""
file.names <- dir(filepath, pattern =".csv")
for(i in 1:length(file.names)){
     file <- read.csv(paste(filepath,file.names[i],sep = ''), stringsAsFactors=FALSE)
     d <- rbind(d, file)
}
file = ""
sps <- read.csv('service-providers.csv',stringsAsFactors = FALSE)

##data-tidying
# we don't wholly trust the SP data coming in the data because it 
# doesn't reflect some post-Toolkit realities.  So in addition to looking
# up the 'from' SP, we drop and rebuild the 'to' SP with the corrected data in
# the 'sps' table.

# rename the SP columns
names(sps) = c('from_ag', 'from_sp')

#strip out unneeded columns, rename, and retrieve the from_sp
d <- select(d,mi_value,inc_assignment_group)
names(d) = c('from_ag', 'to_ag')
d <- merge(d, sps, by = 'from_ag') #get the from_sp

#now set up the 'to' AG and SP 
names(sps) = c('to_ag', 'to_sp')
d <- merge(d, sps, by = 'to_ag')

## Filters!

# 12/15 KGW pulled all the filters for a bigger dt table
dt <- data.frame(table(d$from_sp, d$to_sp)) #cross-tabulate all

#d <- filter(d, (from_sp != to_sp)) #drop the intra-org
#if(direction == 'to-its'){
#      d <- filter(d, (from_sp != 'ITS')) #drop the ITS froms (TO graphic)
#      dt <- data.frame(table(d$from_sp, d$to_ag)) #cross-tabulate (for the TO graphic)
# }    else  {
#      d <- filter(d, (from_sp == 'ITS')) #select the ITS froms (FROM graphic)
#      dt <- data.frame(table(d$from_ag, d$to_ag)) #cross-tabulate (for the FROM graphic)
# }

# build the table for reporting
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
     height = 1500,
     title = "Transferred Calls"
)

#publish

#sankeyPlot$save('its-transfers.html', cdn=FALSE)
#sankeyPlot
# sankeyPlot$publish('Transfers From ITS', id = '443ba09cff11d561b1d1')
# sankeyPlot$publish('Transfers To ITS', id = 'c4adbcf6c24d183f363d')

#http://rcharts.github.io/viewer/?c4adbcf6c24d183f363d # to ITS chart
#http://rcharts.github.io/viewer/?443ba09cff11d561b1d1 # from ITS chart
