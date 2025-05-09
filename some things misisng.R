```{r Tree Pruning and Data Subsetting}
#import the tree from the all_species_data object
tree <- all_species_data$tree

#prune the phylogenetic tree
pruned_tree <- keep.tip(tree, intervertebral_distances_species$species_name)

##add count data (including body aspect ratios) to the vertebral aspect ratio subsetted data
#define count_data dataframe
count_data <- as.data.frame(all_species_data$matrix_data)
#inherit species_name from rownames (originally a matrix)
count_data <- count_data %>%
  mutate(species_name = rownames(count_data))

#subset count data to species for which we have IVD data and present in pruned tree
filtered_count_data <- 
  count_data %>%
  filter(species_name %in% intervertebral_distances_species$species_name)

#merge aspect ratio and count data based on 'species_name' column
combined_data <- merge(filtered_count_data, intervertebral_distances_species, by='species_name')

#reorder the new damn dataframe to match order of tips in phylogeny
combined_data <- 
  combined_data %>%
  arrange(match(species_name, pruned_tree$tip.label))

#add rownames to make downstream analysis easier
rownames(combined_data) <- combined_data$species_name
```


## loading trees
```{r}
#import all species data
tree <- all_species_data$tree

#sort out species names to match phylogeny
combined_data$species_name <- gsub('_', " ", combined_data$species_name)

#filter out hybrids and Astatotilapia sp. 'Ruaha blue'
combineddata_species_filtered <- 
  combined_data %>%
  filter(!species_name %in% c('Astatotilapia sp', 'M zebra', 'Aulonocara nyassae', 'Stigmatochromis macrorhynchos', 'Tramitichromis brevis'))
tree$tip.label <- gsub("Astatotilapia sp. Ruaha Blue", "Astatotilapia sp Ruaha Blue", tree$tip.label)

combineddata_species_filtered$species_name <- trimws(combineddata_species_filtered$species_name)
tree$tip.label <- trimws(tree$tip.label)
combineddata_species_filtered <- combineddata_species_filtered[combineddata_species_filtered$species_name %in% tree$tip.label, ]

#prune the phylogenetic tree
pruned_tree <- keep.tip(tree, combineddata_species_filtered$species_name)
```