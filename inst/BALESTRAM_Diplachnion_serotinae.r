###########################################################################

#####   SCRIPT INTRODUCTION
### Author:   Martino Balestra, MSc in Biodiversity Conservation
### Course:   Biodiversity Data Analysis (Emmanuel Defossez)
### Date:     07.06.2024

#####   SCOPE
### This script is designed to analyze the distribution and pedoclimatic characteristics of the priority habitat Diplachnion serotinae, focusing on its characteristic and structural vegetation. The scientific consensus regarding this phytosociological alliance is still under debate.

####    SELECTION CRITERIA
### The observations and distribution of the following species will be considered for the analysis:
# - Bromus condensatus      Hack.
# - Chrysopogon gryllus     (L.) Trin.
# - Cleistogenes serotina   (L.) Keng
# - Danthonia alpina        Vest
# - Heteropogon contortus   (L.) P.Beauv. ex Roem. & Schult.                
# - Thliphthisa purpurea    (L.) P.Caputo & Del Guacchio

###########################################################################

### Installing all libraries
source("src/00_all_libraries.r")


### Importing observations from GBIF, iNaturalist, and InfoFlora
source("src/01_import_data.r")
# print(matrix_full)        # View all 3313 observations
# print(p1)                 # Visualize them on a map of Switzerland


### Mining environmental variables
source("src/02_elevation_data.r")
source("src/03_ecosystem_data.r")
source("src/04_climatic_data.r")
source("src/05_satellite_ndvi.r")
source("src/06_soil_data.r")
# print(clean_matrix)       # View all 2869 observations with the extracted environmental data
# print(p6)                 # Visualize them on a map of Switzerland


### Further mapping (partial results and 3D)
source("src/07_mapping.r")


### Main data analysis and statistics, with comments (for some reason, formatting doesn't work when calling charts from here)
source("08_statistical_analysis.r")
# circ                      # For a discrete tree between species ecological niches
# print(pca_var)            # For the PCA with all variables and species
# print(plot_kde)           # For Kernel density estimation
# print(quart_kde)          # For the quantile retained for further analysis
# plot(h_tmax)             # For a histogram of the habitat ecological niche, related to maximal temperature
# plot(h_tmin)             # For a histogram of the habitat ecological niche, related to minimal temperature
# plot(h_rain)             # For a histogram of the habitat ecological niche, related to precipitations
# plot(h_elev)             # For a histogram of the habitat ecological niche, related to elevation
# plot(h_ph)               # For a histogram of the habitat ecological niche, related to soil pH


### Other data analysis, for exploration
source("09_other_analysis.r")
# plot_3d                   # For an interactive 3D PCOA
# plot(g)                   # For species networking with all environmental variables
# print(pph)                # Comparing species and pH 
# print(ppe)                # Comparing species and elevation 
# print(ptmin)              # Plot with minimal mean temperature and species
# print(ptmax)              # Plot with maximal mean temperature and species
# print(prain)              # Plot with mean precipitations and species
# print(rte)                # Regression between maximal temperatures and elevations
# plot(mat_corrplot)        # For a correlation matrix between variables
# plot(hcover)              # For a landcover heatmap
# ggplotly(P_fact)          # For an interactive factor analysis
# print(aggr_sp)            # For aggregated species data between pH and precipitation
# ggplotly(pfac)            # For species composition by ecosystem, interactive

###########################################################################

##### SCRIPT CONCLUSION
# Loved it. To be more precise, focusing solely on data from Ticino (excluding Valais and Grisons) could have been a better idea. Additionally, comparing ecological niches with Italian data would provide valuable insights (but didn't have enough time, sorry). Next steps could involve on-field measurements and phytosociological surveys. I just have to find the money for it ;)

###########################################################################
