# Install RaukR packages

Installs all the packages that are used for the RaukR labs.

To install Bioconductor packages, add repositories with setRepositories() before installing this package.

Install with
```{r}
devtools::install_github("https://github.com/Sebastian-D/raukr")
```

## How to update with new dependencies

1. Install this package
2. Fork this repo
3. clone your fork
4. Go to R
```
library(raukr)

# Find which libraries are used
libraries <- get_dependencies(path = "path/to/labs")

# Remove previous dependencies
remove_dependencies(path = "path/to/DESCRIPTION")

# Add dependencies to the description file
add_dependencies(path = "path/to/DESCRIPTION", libraries)
```

5. Commit your changes
6. Create pull request
