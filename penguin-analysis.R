#Penguin data 

#This analysis takes the best from three analysis on the Penguin data.

#Showing mostly a PCA, and Simpson's paradox.

{r}
library(palmerpenguins)
library(dplyr)
library(tidyr)
data("penguins")
str(penguins)

https://allisonhorst.github.io/palmerpenguins/

{r}
penguins %>% 
  group_by(species) %>% 
  summarize(across(where(is.numeric), mean, na.rm = TRUE))

For this example:

shorten variable names (remove units) to simplify variable labels,

create factors for character variables (needed for MANOVA), and

remove NA observations (causes problems with PCA)

{r}
peng <- penguins %>%
    dplyr::rename(
         bill_length = bill_length_mm, 
         bill_depth = bill_depth_mm, 
         flipper_length = flipper_length_mm, 
         body_mass = body_mass_g)
peng <- peng %>% drop_na()
peng

{r}
library(car)
library(ggbiplot)
library(GGally)

{r}
scatterplotMatrix(~ bill_length + bill_depth + flipper_length + body_mass | species,
                  data=peng,
                  ellipse=list(levels=0.68),
                  col = scales::hue_pal()(3),
                  legend=list(coords="bottomright"))

 

{r}
ggpairs(peng, mapping = aes(color = species), 
        columns = c("bill_length", "bill_depth", 
                    "flipper_length", "body_mass",
                    "island", "sex"))

{r}
peng.pca <- prcomp (~ bill_length + bill_depth + flipper_length + body_mass,
                    data=peng,
                    scale. = TRUE)

peng.pca

{r}
screeplot(peng.pca, type = "line", lwd=3, cex=3, 
        main="Variances of PCA Components")

{r}
ggbiplot(peng.pca, obs.scale = 1, var.scale = 1,
         groups = peng$species, 
         ellipse = TRUE, circle = TRUE) +
  scale_color_discrete(name = 'Penguin Species') +
  theme_minimal() +
  theme(legend.direction = 'horizontal', legend.position = 'top') 

From this, we can see:

These two principal components account for 68.6 + 19.5 = 88.1 % of the total variance of these four size variables.

PC1 is largely determined by flipper length and body mass. We can interpret this as an overall measure of penguin size.

On this dimension, Gentoos are the largest, by quite a lot, compared with Adelie and Chinstrap.

PC2 is mainly determined by variation in the two beak variables: bill length and depth. Chinstrap are lower than the other two species on bill length and depth, but bill length further distinguishes the Gentoos. A penguin biologist could almost certainly provide an explanation, but I'll call this beak shape.

{r}

# Scatterplot example 2: penguin bill length versus bill depth
ggplot(data = peng, aes(x = bill_length, y = bill_depth)) +
  geom_point(aes(color = species, 
                 shape = species),
             size = 2)  +
  scale_color_manual(values = c("darkorange","darkorchid","cyan4")) +
  theme_minimal()

