# files are large.
  #options(timeout = 120) #NOT NEEDED IN PYTHON, PYTHON DOES NOT HAVE A TIMEOUT
  temp <- tempfile()
  utils::download.file(url, temp, quiet = T)
  #options(timeout = 60) # back to default

  # Read in data
  raw_file <- readr::read_fwf(unzip(temp), layout)

  # Drop empty fields
  raw_file <- raw_file %>%
  df[df.columns.drop(list(df.filter(regex='Drop')))] # https://stackoverflow.com/questions/56754831/drop-columns-if-rows-contain-a-specific-value-in-pandas

  # Subset suicides
  # Suicide codes: X60 - X84, U03, Y870
  suicide_code <- c(stringr::str_c("X", 60:84), "U03", "Y870")