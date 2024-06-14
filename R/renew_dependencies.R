

#' Get dependencies
#'
#' This function takes the path to the current labs folder of raukr repository
#' as input, searches all qmd files for the word "library(*)" where * can be any string
#' and returns all unique strings that are found in the files.
#'
#' @param path The path to the labs folder of raukr repository
#' @return A character vector of unique strings that are found in the files
#' @examples
#' get_dependencies("C:/Users/username/Documents/raukr/labs")
#' @export
get_dependencies <- function(path) {
  # Get all files in the folder
  files <- list.files(path, recursive = TRUE, full.names = TRUE)
  # Only look in .qmd files
  files <- files[grep(".qmd$", files)]
  # Read all files
  text <- sapply(files, readLines, warn = FALSE)
  #Unlist
  text <- unlist(text)
  # Find all library calls
  matches <- grep("library\\(", text, value = TRUE)
  # clean up the matches
  cleaned_text <- gsub(".*?(library\\([^)]+\\)).*?|.", "\\1", matches, perl = TRUE)
  # Get only the strings that are inside the parentheses
  matches <- gsub("library\\((.*?)\\)", "\\1", cleaned_text)
  # Remove the quotes
  libraries <- gsub("\'", "", matches)
  # Remove the leading and trailing whitespaces
  libraries <- trimws(libraries)
  # Get only unique libraries
  libraries <- unique(libraries)
  # Remove empty strings
  libraries <- libraries[libraries != ""]

  return(libraries)
}

#libraries <- get_dependencies("~/Library/CloudStorage/Box-Box/Work/Courses/raukr-2024/labs")

# A function that removes all dependencies from the DESCRIPTION file
#' Remove dependencies
#'
#' This function takes the path to the DESCRIPTION file as input, reads the file,
#' removes all lines that start with "Depends:" and writes the remaining lines back
#' to the DESCRIPTION file.
#' @param path The path to the DESCRIPTION file
#' @examples
#' remove_dependencies("C:/Users/username/Documents/raukr/DESCRIPTION")
#' @export
remove_dependencies <- function(path) {
  # Read the DESCRIPTION file
  text <- readLines(path)
  # Remove all lines after and including "Imports:"
  text <- text[1:grep("^Imports:",text)-1]
  # Write the remaining lines back to the DESCRIPTION file
  writeLines(text, path)
}

# remove_dependencies("./DESCRIPTION")

# Add dependencies to the DESCRIPTION file based on the output libraries from get_dependencies
#' Add dependencies
#' This function takes the path to the DESCRIPTION file and the libraries that are found
#' in the files as input, reads the DESCRIPTION file, adds the libraries to the "Imports:"
#' field and writes the updated DESCRIPTION file back.
#' @param path The path to the DESCRIPTION file
#' @param libraries A character vector of libraries that are found in the files
#' @examples
#' add_dependencies("C:/Users/username/Documents/raukr/DESCRIPTION", c("dplyr", "ggplot2"))
#' @export
add_dependencies <- function(path, libraries) {
  # Read the DESCRIPTION file
  text <- readLines(path)
  # Find the line where the "Imports:" field starts
  imports_line <- grep("^Imports:", text)
  # If the "Imports:" field is not found, add it to the end of the file
  if (length(imports_line) == 0) {
    text <- c(text, "Imports:")
    imports_line <- length(text)
  }
  # Add the libraries to the "Imports:" field
  text <- c(text[1:imports_line], paste0("  ", paste(libraries, collapse = ",\n\t")))
  # Write the updated DESCRIPTION file back
  writeLines(text, path)
}
