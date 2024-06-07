### Installing all necessary packages
# install.packages("ape")               # For phylogenetic analysis
# install.packages("BiocManager")       # For accessing Bioconductor packages
# install.packages("corrplot")          # For matrix correlations
# install.packages("dplyr")             # For data manipulation
# install.packages("elevatr")           # For elevation data tools
# install.packages("emmeans")           # For estimated marginal means
# install.packages("fmsb")              # For creating radar charts
# install.packages("geodata")           # For geospatial data
# install.packages("ggcorrplot")        # For visualizing correlation matrices
# install.packages("ggfortify")         # For visualizing statistical results
# install.packages("ggplot2")           # For data visualization
# install.packages("here")              # For path management in R projects
# install.packages("igraph")            # For network analysis and visualization
# install.packages("magick")            # For image processing in R
# install.packages("MASS")              # For statistical functions and datasets
# install.packages("MODIStsp")          # To install MODIStsp from GitHub
# install.packages("pheatmap")          # For creating heatmaps
# install.packages("plotly")            # For interactive plots
# install.packages("png")               # For reading and writing PNG images
# install.packages("randomcoloR")       # For generating random colors
# install.packages("raster")            # For spatial operations
# install.packages("rayshader")         # For 3D visualization of geospatial data
# install.packages("remotes")           # For installing R packages from remote repositories
# install.packages("rgbif")             # For accessing GBIF occurrence data
# install.packages("rgdal")             # For geospatial data operations and transformations
# install.packages("rgeoboundaries")    # For accessing political boundaries data
# install.packages("rgl")               # For 3D visualization
# install.packages("rinat")             # For accessing iNaturalist occurrence data
# install.packages("rnaturalearth")     # For obtaining spatial data
# install.packages("sf")                # For handling and analyzing geospatial data
# install.packages("sp")                # For spatial data classes and methods
# install.packages("terra")             # For spatial data analysis
# install.packages("tidyverse")         # For data science tools
# install.packages("vegan")             # For ecological community analysis
# install.packages("viridis")           # For color palettes optimized for readability
# if (!require("BiocManager", quietly = TRUE))
#     install.packages("BiocManager")
# BiocManager::install("ggtree")        # For visualizing phylogenetic trees

### Loading all necessary libraries
library(ape)                            # For phylogenetic analysis
library(corrplot)                       # For matrix correlations
library(dplyr)                          # For data manipulation
library(elevatr)                        # For elevation data tools
library(emmeans)                        # For estimated marginal means
library(fmsb)                           # For creating radar charts
library(geodata)                        # For geospatial data
library(ggcorrplot)                     # For visualizing correlation matrices
library(ggfortify)                      # For visualizing statistical results
library(ggplot2)                        # For data visualization
library(ggtree)                         # For visualizing phylogenetic trees
library(here)                           # For path management in R projects
library(igraph)                         # For network analysis and visualization
library(magick)                         # For image processing in R
library(MASS)                           # For statistical functions and datasets
library(MODIStsp)                       # For downloading and processing MODIS Land Products
library(pheatmap)                       # For creating heatmaps
library(plotly)                         # For interactive plots
library(png)                            # For reading and writing PNG images
library(randomcoloR)                    # For generating random colors
library(raster)                         # For spatial operations
library(rayshader)                      # For 3D visualization of geospatial data
library(remotes)                        # For installing R packages from remote repositories
library(rgbif)                          # For accessing GBIF occurrence data
library(rgdal)                          # For geospatial data operations and transformations
library(rgeoboundaries)                 # For accessing political boundaries data
library(rgl)                            # For 3D visualization
library(rinat)                          # For accessing iNaturalist occurrence data
library(rnaturalearth)                  # For obtaining spatial data
library(sf)                             # For handling and analyzing geospatial data
library(sp)                             # For spatial data classes and methods
library(terra)                          # For spatial data analysis
library(tidyverse)                      # For data science tools
library(vegan)                          # For ecological community analysis
library(viridis)                        # For color palettes optimized for readability
