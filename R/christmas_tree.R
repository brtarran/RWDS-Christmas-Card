library(ggplot2)
library(ggforce)
library(sf)
library(png)
library(patchwork) 

# sky
s1 <- ggplot() +
  theme_void() +
  theme(
    plot.background = element_rect(fill = "#939bc9", color = "#939bc9")
  )
s1

# add snowflakes
set.seed(20231225)
n <- 100
snowflakes <- data.frame(
  x = runif(n),
  y = runif(n)
)
s2 <- s1 +
  geom_point(
    data = snowflakes,
    mapping = aes(
      x = x,
      y = y
    ),
    colour = "white",
    pch = 8
  )
s2

# snow on ground
s3 <- s2 +
  annotate(
    geom = "rect",
    xmin = 0, xmax = 1,
    ymin = 0, ymax = 0.2,
    fill = "#f0eeeb", colour = "#f0eeeb"
  ) +
  xlim(0, 1) +
  ylim(0, 1) +
  coord_fixed(expand = FALSE)
s3

# coordinates for tree base
tree_pts1 <- matrix(
  c(
    0.2, 0.3,
    0.5, 0.6,
    0.8, 0.3,
    0.2, 0.3
  ),
  ncol = 2,
  byrow = TRUE
)

# coordinates for tree middle
tree_pts2 <- matrix(
  c(
    0.3, 0.5,
    0.5, 0.7,
    0.7, 0.5,
    0.3, 0.5
  ),
  ncol = 2,
  byrow = TRUE
)

# coordinates for tree top
tree_pts3 <- matrix(
  c(
    0.4, 0.65,
    0.5, 0.75,
    0.6, 0.65,
    0.4, 0.65
  ),
  ncol = 2,
  byrow = TRUE
)

# put tree together
tree <- st_multipolygon(list(list(tree_pts1),
                             list(tree_pts2),
                             list(tree_pts3)))
s4 <- s3 +
  geom_sf(
    data = tree,
    fill = "chartreuse4",
    colour = "chartreuse4"
  ) +
  coord_sf(expand = FALSE)
s4

# add trunk
s5 <- s4+
  annotate(
    geom = "rect",
    xmin = 0.45,
    xmax = 0.55,
    ymin = 0.2,
    ymax = 0.3,
    fill = "brown"
  )
s5

# add gold baubles
s6 <- s5 +
  geom_point(colour = "gold",
             data = data.frame(
               x = c(0.3, 0.4, 0.5, 0.6, 0.57, 0.62, 0.45, 0.5),
               y = c(0.325, 0.4, 0.45, 0.35, 0.57, 0.52, 0.6, 0.7),
               size = runif(8, 2, 4.5)
             ),
             mapping = aes(x = x, y = y, size = size)
  ) +
  scale_size_identity()
s6

# add red baubles
s7 <- s6 +
  geom_point(colour = "red3",
             data = data.frame(
               x = c(0.7, 0.6, 0.5, 0.525, 0.43, 0.38, 0.55, 0.5),
               y = c(0.375, 0.4, 0.55, 0.65, 0.43, 0.48, 0.5, 0.375),
               size = runif(8, 2, 4.5)
             ),
             mapping = aes(x = x, y = y, size = size)
  ) +
  scale_size_identity()
s7

# add text
s8 <- s7 +
  annotate(
    geom = "text",
    x = 0.5,
    y = 0.875,
    label = "Merry Christmas",
    colour = "red3",
    fontface = "bold",
    size = 18
  )
s8

# add logo 
path <- "images/rwds-logo-150px.png"
img <- readPNG(path, native = TRUE) 
s9 <- s8 +                   
  inset_element(p = img, 
                left = 0.3265, 
                bottom = 0.0, 
                right = 0.6735, 
                top = 0.2
  ) 
s9

ggsave(
  filename = "rwds-christmas-card.png",
  path = "images",
  plot = s9,
  width = 600,
  height = 600,
  units = c("px"),
  dpi = 72
)
