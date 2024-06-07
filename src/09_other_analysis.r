### Interactive PCOA

# Preparing data
row.names(df_continuous) <- c(1:nrow(df_continuous))

dist_mat <- vegdist(df_continuous, method = "euclidean")

# Multidimensional scaling
D3_data_dist <- cmdscale(dist_mat, k = 3)
D3_data_dist <- data.frame(D3_data_dist)

# Extract species information
cols <- df_discrete$species

# PCOA
PCOA <- ggplot(D3_data_dist, aes(x = X1, y = X2, color = cols)) +
  geom_point() + ggtitle("Environmental conditions for Diplachnion serotinae") +
  theme_classic()

PCOA

# Converting to interactive 
interactive_pcao <- ggplotly(PCOA)
interactive_pcao

# Changing legend title to "Species"
interactive_pcao <- interactive_pcao %>% layout(legend = list(title = "Species"))
interactive_pcao


### 3D PCA, interactive

# Preparing data
df_continuous <- apply(df_continuous, 2, as.numeric)

pca <- princomp(df_continuous, scores = TRUE, cor = TRUE)

# Extracting scores
scores <- pca$scores
x <- scores[,1]
y <- scores[,2]
z <- scores[,3]

# Extracting loadings
loadings <- pca$loadings

# Naming loadings
load_names <- rownames(loadings)

# Scaling factor for loadings
scale_loads <- 5

# Creating the 3D plot
plot_3d <- plot_ly() %>%
  add_trace(x = x, y = y, z = z,
            type = "scatter3d", mode = "markers", color = df_discrete$species)

# Adding loadings to the plot
for (k in 1:nrow(loadings)) {
   x_load <- c(0, loadings[k,1]) * scale_loads
   y_load <- c(0, loadings[k,2]) * scale_loads
   z_load <- c(0, loadings[k,3]) * scale_loads
   plot_3d <- plot_3d %>% add_trace(x = x_load, y = y_load, z = z_load,
                                    type = "scatter3d", mode = "lines",
                                    line = list(width = 8),
                                    opacity = 1,
                                    name = load_names[k])
}

plot_3d


### Networking
df2 <- clean_matrix[,colnames(clean_matrix) %in% c("species","tmax","tmin","rain","elevation","ndvi","ph")]

aggregated_df2 <- aggregate(. ~ species, data = df2 , FUN = mean)

df2_hclust <- aggregated_df2[,colnames(aggregated_df2) %in% c("tmax","tmin","rain","elevation","ndvi","ph")]

# Defining function to scale values between 0 and 1
scale_values <- function(x){(x-min(x))/(max(x)-min(x))}

# Scaling values in 'sales' column to be between 0 and 1
df2_hclust_scaled <- apply(df2_hclust,2,scale_values)

row.names(df2_hclust_scaled) <- aggregated_df2$species

dist_df2 <- vegdist(df2_hclust_scaled, method = "bray")

g <- graph.adjacency(
  as.matrix(dist_df2),
  mode="undirected",
  weighted=TRUE,
  diag=FALSE
)

# Colouring negative correlation edges as blue
E(g)[which(E(g)$weight<0.5)]$color <- "darkblue"

# Colouring positive correlation edges as red
E(g)[which(E(g)$weight>0.5)]$color <- "darkred"

# Removing edges below absolute Pearson correlation 0.8
g <- delete_edges(g, E(g)[which(E(g)$weight<0.1)])

# Assigning names to the graph vertices (optional)
V(g)$name <- V(g)$name

# Changing shape of graph vertices
V(g)$shape <- "sphere"

# Changing colour of graph vertices
V(g)$color <- "skyblue"

# Changing colour of vertex frames
V(g)$vertex.frame.color <- "white"

# Amplifying or decreasing the width of the edges
edgeweights <- E(g)$weight * 2.0

# Converting the graph adjacency object into a minimum spanning tree based on Prim's algorithm
mst <- mst(g, algorithm="prim")

# Plotting the tree object
plot(
  mst,
  layout=layout.fruchterman.reingold,
  edge.curved=TRUE,
  vertex.label.dist=-0.5,
  vertex.label.color="black",
  asp=FALSE,
  vertex.label.cex=0.6,
  edge.width=edgeweights,
  edge.arrow.mode=0,
  main="Species networking with all environmental variables"
)


### Basic plots

# Comparing species and pH 
pph <- ggplot(data = clean_matrix, aes(y = ph, fill = species)) +
  geom_boxplot() +
  scale_fill_manual(values = c("darkgreen", "darkred", "darkblue", "orange", "brown", "darkkhaki", "darkslategrey")) +
  labs(y = "Soil pH (0-5 cm)") +
  theme(axis.text.x = element_blank()) +
  guides(fill = guide_legend(title = "Species"))

# Comparing species and elevation 
ppe <- ggplot(data = clean_matrix, aes(y = elevation, fill = species)) +
  geom_boxplot() +
  scale_fill_manual(values = c("darkgreen", "darkred", "darkblue", "orange", "brown", "darkkhaki", "darkslategrey")) +
  labs(y = "Elevation") +
  theme(axis.text.x = element_blank()) +
  guides(fill = guide_legend(title = "Species"))


### Other histograms

# Density plot with factor species - Minimal mean temperature
ptmin <- ggplot(clean_matrix, aes(x = tmin, fill = factor(species))) +
  geom_density(adjust = 3, alpha = 0.5) +
  labs(x = "Minimal mean temperature", y = "Density", fill = "Species") +
  theme_minimal() +
  theme(legend.position = "right")

# Density plot with factor species - Maximal mean temperature
ptmax <- ggplot(clean_matrix, aes(x = tmax, fill = factor(species))) +
  geom_density(adjust = 3, alpha = 0.5) +
  labs(x = "Maximal mean temperature", y = "Density", fill = "Species") +
  theme_minimal() +
  theme(legend.position = "right")

# Density plot with factor species - Yearly mean precipitations
prain <- ggplot(clean_matrix, aes(x = elevation, fill = factor(species))) +
  geom_density(adjust = 3, alpha = 0.5) +
  labs(x = "Mean precipitations", y = "Density", fill = "Species") +
  theme_minimal() +
  theme(legend.position = "right")


### Basic regression between elevation and minimal mean temperature
rte <- ggplot(clean_matrix, aes(x = tmin, y = rain, color = factor(species))) +
  geom_smooth(method = "lm", se = FALSE) +
  geom_point() +
  labs(x = "Minimal mean temperature", y = "Elevation", color = "Species") +
  theme_minimal() +
  theme(legend.position = "right")



### Creating a correlation matrix

# Loading and clean the dataset
df <- na.omit(clean_matrix)

# Separating continuous and discrete variables
continuous_vars <- c("tmin", "tmax", "elevation", "rain", "ph")
df_continuous <- df[, continuous_vars]
df_discrete <- df[, !colnames(df) %in% continuous_vars]

# Computing and the correlation matrix
corr_matrix <- cor(df_continuous)
mat_corrplot <- corrplot(corr_matrix, order = 'hclust', addrect = 3)



### Heat-mapping

# Preparing data for the heatmap
data <- scale(df_continuous)
row.names(data) <- 1:nrow(data)

# Generating a basic heatmap
heatmap(data)

# Annotating
landcover_annotation <- df_discrete["landcover"]
row.names(landcover_annotation) <- 1:nrow(landcover_annotation)

# Defining custom colors for the heatmap
custom_colors <- grDevices::colorRampPalette(c("black", "darkgreen", "white", "darkred"))

# Generating an advanced heatmap with annotations
hcover <- pheatmap(data,
         annotation_row = landcover_annotation,
         cutree_rows = 2,
         cutree_cols = 2,
         cellwidth = 100,
         cellheight = 0.2,
         color = custom_colors(10))



### Interactive factor analysis

data_stat <- clean_matrix

# Creating a boxplot for temperature by landcover type
P_fact <- ggplot(data = data_stat, aes(x = landcover, y = ph, fill = landcover)) +
  geom_boxplot(varwidth = TRUE, outlier.shape = NA) +
  geom_jitter(alpha = 0.2, size = 2, width = 0.1) +
  stat_summary(fun = mean, shape = 13, size = 1, colour = "darkgreen") +
  theme_classic()

print(P_fact)

# Converting ggplot to an interactive plotly plot
ggplotly(P_fact)

# Fitting a linear model with landcover as a factor
linear_model <- lm(ph ~ landcover, data = data_stat)

# Performing ANOVA on the linear model
anova_result <- anova(linear_model)
print(anova_result)

# Conducting post-hoc tests with Tukey adjustment
em <- emmeans(linear_model, list(pairwise ~ landcover), adjust = "tukey")
print(em)



### Data aggregation and formatting

data_stat <- clean_matrix

# Aggregating data by ecosystem
aggregated_data <- data_stat %>%
  group_by(ecosystem) %>%
  summarize(across(c(elevation, rain, tmin, tmax, ph), mean, na.rm = TRUE))

# Printing the aggregated data
print(aggregated_data)

# Extracting species and ecosystem columns
data_stat_discrete <- data_stat %>% dplyr::select(species, ecosystem)

# Merging
aggregated_data_final_species <- aggregated_data %>%
  left_join(data_stat_discrete, by = "ecosystem") %>%
  distinct()

# Printing the final aggregated data
print(aggregated_data_final_species)

# Plotting aggregated species data between pH and precipitation
aggr_sp <- ggplot(aggregated_data_final_species, aes(x = ph, y = rain, color = species)) +
  geom_point() +
  facet_grid(. ~ species) +
  theme_minimal() +
  labs(title = "Scatter Plot Matrix of Environmental Variables by Species", x = "pH", y = "Rain", color = "Species")



### Data preparation for species compostion by ecosystem
data_stat <- clean_matrix

# Create a table to count the occurrences of each species in each ecosystem
species_ecosystem_counts <- data_stat %>%
  group_by(ecosystem, species) %>%
  summarize(count = n(), .groups = 'drop')

### Combined plot using facets
pfac <- ggplot(species_ecosystem_counts, aes(x = species, y = count, fill = species)) +
  geom_bar(stat = "identity") +
  facet_wrap(~ ecosystem, scales = "free") +
  theme_classic() +
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        legend.position = "right") +
  labs(title = "Species Composition by Ecosystem",
       x = "Species",
       y = "Count",
       fill = "Species")

# Convert to interactive plot
ggplotly(pfac)
