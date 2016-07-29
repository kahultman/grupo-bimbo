
cname <- function(x) {
  flag <- 0
  tokens <- strsplit(as.character(x), " ")[[1]]
  #print(tokens)
  y <- length(tokens)
  for ( i in 1:y) {
    if (tokens[i] %in% topnames) {
      flag <- 1
      key <- tokens[i]
    }
  }
  if (flag == 1) {
    return(key)
  } else {
    return("dummy")
  }
  # if (x %in% topnames) {
  #   print(x)
  # } else {
  #   print(0)
  # }
}


clients$topclient <- unlist(lapply(as.character(clients$client_name), cname))
head(clients)

clients_r <- clients %>%
  mutate(yesno = 1) %>%
  distinct %>%
  spread(topclient, yesno, fill = 0)

#deleted the dummy variable
clients_r$dummy <- NULL

save(clients_r, file = "clients_r.RData")
