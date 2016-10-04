library(shiny)
require(ggmap)
require(maps)
require(sp)

rest<- read.csv("DOHMH_New_York_City_Restaurant_Inspection_Results.csv")  
rest <-na.omit(rest)

r <- rest %>% group_by(DBA, VIOLATION.CODE, RECORD.DATE) %>% summarise(x = n(), VIOLATION.DESCRIPTION = first(VIOLATION.DESCRIPTION))

r[grep(pattern='02', r$VIOLATION.CODE),]$VIOLATION.DESCRIPTION <- 'Food Temperature'
r[grep(pattern='03', r$VIOLATION.CODE),]$VIOLATION.DESCRIPTION <- 'Food Source'
r[grep(pattern='04', r$VIOLATION.CODE),]$VIOLATION.DESCRIPTION <- 'Food Protection'
r[grep(pattern='05', r$VIOLATION.CODE),]$VIOLATION.DESCRIPTION <- 'Working Environment Safety'
r[grep(pattern='06', r$VIOLATION.CODE),]$VIOLATION.DESCRIPTION <- 'Workers Cleanliness'
r[grep(pattern='07', r$VIOLATION.CODE),]$VIOLATION.DESCRIPTION <- 'Duties of Officer'
r[grep(pattern='08', r$VIOLATION.CODE),]$VIOLATION.DESCRIPTION <- 'Facility Issues'
r[grep(pattern='09', r$VIOLATION.CODE),]$VIOLATION.DESCRIPTION <- 'Food Storage'
r[grep(pattern='10', r$VIOLATION.CODE),]$VIOLATION.DESCRIPTION <- 'Utility Issues'
r[grep(pattern='15', r$VIOLATION.CODE),]$VIOLATION.DESCRIPTION <- 'Tabacco Issues'
r[grep(pattern='16', r$VIOLATION.CODE),]$VIOLATION.DESCRIPTION <- 'Food Nuitrition/Calories'
r[grep(pattern='18', r$VIOLATION.CODE),]$VIOLATION.DESCRIPTION <- 'Documents Not Present'
r[grep(pattern='20', r$VIOLATION.CODE),]$VIOLATION.DESCRIPTION <- 'Information Not Posted'
r[grep(pattern='22', r$VIOLATION.CODE),]$VIOLATION.DESCRIPTION <- 'Facility Issues 2'
r[grep(pattern='99', r$VIOLATION.CODE),]$VIOLATION.DESCRIPTION <- 'Other General Violation'


rest$ADDRESSS <- paste(as.character(rest$BUILDING), as.character(rest$STREET), as.character(rest$ZIPCODE), sep = " ")
restaurant <- rest %>% group_by(ADDRESSS) %>% summarise(name = first(DBA))

sub1 <- restaurant[1:4746,]
require(leaflet)


geocodelong<- function(address) {
  require(RJSONIO)
  url <- "http://maps.google.com/maps/api/geocode/json?address="
  url <- URLencode(paste(url, address, "&sensor=false", sep = ""))
  x <- fromJSON(url, simplify = FALSE)
  if (x$status == "OK") {
    out <- x$results[[1]]$geometry$location$lng
  } else {
    out <- NA
  }
  Sys.sleep(0.2)  # API only allows 5 requests per second
  out
}

geocodeAddress <- function(address) {
  require(RJSONIO)
  url <- "http://maps.google.com/maps/api/geocode/json?address="
  url <- URLencode(paste(url, address, "&sensor=false", sep = ""))
  x <- fromJSON(url, simplify = FALSE)
  if (x$status == "OK") {
    out <- c(x$results[[1]]$geometry$location$lng,
             x$results[[1]]$geometry$location$lat)
  } else {
    out <- NA
  }
  Sys.sleep(0.2)  # API only allows 5 requests per second
  out
}


rest %>% rowwise() %>% transmute(long = geocodelong(paste(as.character(rest$BUILDING), as.character(rest$STREET), sep = " ")))

rest %>% rowwise() %>% transmute(ll = geocodeAddress(paste(as.character(rest$BUILDING), as.character(rest$STREET), sep = " ")))

addresses = sub1$ADDRESSS

getGeoDetails <- function(address){   
  #use the gecode function to query google servers
  geo_reply = geocode(address, output='all', messaging=TRUE, override_limit=TRUE)
  #now extract the bits that we need from the returned list
  answer <- data.frame(lat=NA, long=NA, accuracy=NA, formatted_address=NA, address_type=NA, status=NA)
  answer$status <- geo_reply$status
  
  #if we are over the query limit - want to pause for an hour
  while(geo_reply$status == "OVER_QUERY_LIMIT"){
    print("OVER QUERY LIMIT - Pausing for 1 hour at:") 
    time <- Sys.time()
    print(as.character(time))
    Sys.sleep(60*60)
    geo_reply = geocode(address, output='all', messaging=TRUE, override_limit=TRUE)
    answer$status <- geo_reply$status
  }
  
  #return Na's if we didn't get a match:
  if (geo_reply$status != "OK"){
    return(answer)
  }   
  #else, extract what we need from the Google server reply into a dataframe:
  answer$lat <- geo_reply$results[[1]]$geometry$location$lat
  answer$long <- geo_reply$results[[1]]$geometry$location$lng   
  if (length(geo_reply$results[[1]]$types) > 0){
    answer$accuracy <- geo_reply$results[[1]]$types[[1]]
  }
  answer$address_type <- paste(geo_reply$results[[1]]$types, collapse=',')
  answer$formatted_address <- geo_reply$results[[1]]$formatted_address
  
  return(answer)
}

#initialise a dataframe to hold the results
geocoded <- data.frame()
# find out where to start in the address list (if the script was interrupted before):
startindex <- 1
#if a temp file exists - load it up and count the rows!
tempfilename <- paste0("input", '_temp_geocoded.rds')
if (file.exists(tempfilename)){
  print("Found temp file - resuming from index:")
  geocoded <- readRDS(tempfilename)
  startindex <- nrow(geocoded)
  print(startindex)
}

# Start the geocoding process - address by address. geocode() function takes care of query speed limit.
for (ii in seq(startindex, length(addresses))){
  print(paste("Working on index", ii, "of", length(addresses)))
  #query the google geocoder - this will pause here if we are over the limit.
  result = getGeoDetails(addresses[ii]) 
  print(result$status)     
  result$index <- ii
  #append the answer to the results file.
  geocoded <- rbind(geocoded, result)
  #save temporary results as we are going along
  saveRDS(geocoded, tempfilename)
}

#now we add the latitude and longitude to the main data

sub1$lat <- geocoded$lat
sub1$long <- geocoded$lat
sub1$accuracy <- geocoded$accuracy
sub1$format_address <- geocoded$formatted_address
