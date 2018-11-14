# MarkerDB
This R package was made to have an easy access through R to our cell type marker database (created by Nils).

## Installation
The easiest way to install the package is using `devtools`.

```r
devtools::install_github()
```

## How to use

First, we access the MarkerDB and see what species are already available:

```r
getSpecies()
```
```
[1] "mouse" "human"
```
Next, we can get some informations what celltypes are already annotated in a specific species:

```r
getSpeciesInfo("mouse")

```
```
$celltypes
  [1] "neural_stem_cell"                     "GABAergic_interneurons"               "glial_progenitor"                     "undifferentiated_spermatogonia"       "stem_cell"                           
  [6] "spermatogonial_stem_cell"             "GABAergic_progenitors"                "hematopoietic_stem_cells"             "differentiating_neurons"              "newly_born_neurons"                  
 [11] "medulloblastomas"                     "spermatogonia"                        "quiescent_hematopoietic_stem_cells"   "Astrocytes"                           "Oligodendrocytes"                    
 [16] "neuronal_progenitors"                 "primordial_germ_cells"                "sertoli_cells"                        "leydig_cells"                         "spermatocytes"                       
 [21] "round_spermatids"                     "condensing_spermatids"                "condensed_spermatids"                 "elongating_spermatids"                "adipose-derived_stem_cell"           
 [26] "white_fat_cell"                       "cancer_stem_cell"                     "alveolar_macrophage"                  "tumor_endothelial_cell"               "anterior_foregut_endoderm_cell"      
 [31] "cd4+_t_follicular_helper_cell"        "hematopoietic_stem_cell"              "dendritic_cell"                       "mesenchymal_stem_cell"                "endothelial_progenitor_cell"         
 [36] "m2_macrophage"                        "rod_photoreceptor_precursor_cell"     "pluripotent_stem_cell"                "peripheral_monocyte"                  "rhombic_lip_cell"                    
 [41] "prostate_stem_cell"                   "prostate_progenitor_cell"             "enteroendocrine_cell"                 "epithelial_cell"                      "endothelial_cell"                    
 [46] "endometrial_precursor_cell"           "beta_cell"                            "neuron"                               "oligodendrocyte"                      "astrocyte"                           
 [51] "microglial_cell"                      "amacrine_cell"                        "retinal_ganglion_cell"                "hematopoietic_cell"                   "tympanic_border_cell"                
 [56] "oogonial_stem_cell"                   "sinoatrial_node_cell"                 "intestinal_stem_cell"                 "colonic_stem_cell"                    "neutrophil"                          
 [61] "macrophage"                           "monocyte"                             "submandibular_gland_stem_cell"        "side-population_cell"                 "paneth_cell"                         
 [66] "hematopoietic_progenitor_cell"        "small_intestinal_stem_cell"           "testicular_stem_cell"                 "skeletal_muscle_stem_cell"            "heart_muscle_stem_cell"              
 [71] "mesenchymal_progenitor_cell"          "ng2-glia_cell"                        "outer_pillar_cell"                    "stromal_cell"                         "luminal_epithelial_cell"             
 [76] "basal_epithelial_cell"                "cd4+_t_cell"                          "brown_fat_cell"                       "beige_fat_cell"                       "cardiac_progenitor_cell"             
 [81] "chondrocyte-derived_bone_cell"        "liver_progenitor_cell"                "pancreatic_progenitor_cell"           "atrial_cell"                          "ventricular_compact_cell"            
 [86] "ventricular_trabecular_cell"          "epithelial_progenitor_cell"           "progenitor_cell"                      "tumor-propagating_cell"               "erythroid_progenitor"                
 [91] "clara_cell"                           "leukocyte"                            "pancreatic_stem_cell"                 "quiescent_small_intestinal_stem_cell" "ito_cell_(hepatic_stellate_cell)"    
 [96] "eosinophil"                           "dermal_fibroblast"                    "ventricular_cardiomyocyte"            "airway_dendritic_cell"                "hair_cell"                           
[101] "pericyte"                             "naive_thymic_nkt17_cell"              "liver_stem_cell"                      "myofibroblast"                        "stem_leydig_cell"                    
[106] "glomus_cell"                          "olfactory_sensory_neuron"             "vomeronasal_sensory_neuron"           "cancer_cell"                          "lipofibroblast"                      
[111] "mesothelial_cell"                     "goblet_cell"                          "type_ii_pneumocyte"                   "neuroendocrine_cell"                  "germ_cell"                           
[116] "embryonic_stem_cell"                  "cardiomyocyte"                        "lymphatic_endothelial_cell"           "inflammatory_cell"                    "muscle_satellite_cell"               
[121] "alpha_cell"                           "b_cell"                               "t_cell"                               "basophil"                             "megakaryocyte"                       
[126] "mesenchymal_stromal_cell"             "m1_macrophage"                        "fat_cell_(adipocyte)"                 "immature_neuron"                      "radial_glial_cell"                   
[131] "neuroblast"                           "basal_cell"                           "osteocyte"                            "osteogenic_cell"                      "osteoclast"                          
[136] "mesenchymal_cell"                     "erythroid_precursor"                  "hair_follicle_cell"                   "myeloid_cell"                         "platelet"                            
[141] "fibroblast"                           "smooth_muscle_cell"                   "matrix_fibroblast"                    "immune_cell"                          "lymphocyte"                          
[146] "cxcr6+_t_cell"                        "granulocyte"                          "natural_killer_cell"                  "cd8+_t_cell"                          "hormone_sensing_progenitor"          
[151] "hormone_sensing_differentiated_cell"  "luminal_progenitor"                   "differentiated_alveolar_cell"         "alveolar_progenitor_cell"             "myoepithelial_cell"                  
[156] "procr+_basal_cell"                    "early_enterocyte_precursor_cell"      "transit_amplifying_(ta)_cell"         "late_enterocyte_precursor_cell"       "enterocyte"                          
[161] "enteroendocrine_precursor_cell"       "brush_cell_(tuft_cell)"               "oligodendrocyte_precursor_cell"       "mural_cell"                           "plasmacytoid_dendritic_cell"         
[166] "erythroid_cell"                       "hepatocyte"                          

$ensembl
[1] "mmusculus_gene_ensembl"

$latin
[1] "Mus musculus"

$name
[1] "mouse"
``` 

Let's say we then want to find all cell types in mouse cerebellum.
We can use the following to get a vector of cell types:

```r
getAllCelltypesInTissue("cerebellum", "mouse")
```
```
[1] "neural_stem_cell"       "GABAergic_interneurons" "glial_progenitor"       "GABAergic_progenitors"  "medulloblastomas"       "Astrocytes"             "Oligodendrocytes"       "neuronal_progenitors"   "rhombic_lip_cell" 
```

But here, all cell types throughout development are listed.
If we are only interested in cell types, already annotated in P7 cerebellum, we can extend the querry with a list:

```r
getAllCelltypesInTissue("cerebellum", "mouse", filter_list = list(stage  = "P7"))
```
```
[1] "neural_stem_cell"     "Astrocytes"           "Oligodendrocytes"     "neuronal_progenitors"
```

And finally, we can find marker genes for neural stem cells:

```r
getMarkerGenes("neural_stem_cell", "mouse")
```
```
[1] "ENSMUSG00000004891" "ENSMUSG00000029086" "ENSMUSG00000005320" "ENSMUSG00000030283" "ENSMUSG00000020122" "ENSMUSG00000074637"
```

And markers for stage neural stem cells at stage P7:
```r
getMarkerGenes("neural_stem_cell", "mouse", filter_list = list(stage="p7"))
```
```
[1] "ENSMUSG00000029086"
```

And whoever does not like ENSEMBL IDs can also get the gene symbols:

```r
getMarkerGenes("neural_stem_cell", "mouse", filter_list = list(stage="p7"), field = "marker_name")
```
```
[1] "Prom1"
```
