library(ggplot2)
library(ggforce)
library(sf)
library("png") 
library("patchwork") 

# sky
s1 <- ggplot() +
  theme_void() +
  theme(
    plot.background = element_rect(fill = "#939bc9")
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

# add tree base
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
tree1 <- st_polygon(list(tree_pts1))
plot(tree1)
s4 <- s3 +
  geom_sf(
    data = tree1,
    fill = "chartreuse4",
    colour = "chartreuse4"
  ) +
  coord_sf(expand = FALSE)
s4

# add tree middle
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
tree2 <- st_polygon(list(tree_pts2))
plot(tree2)
s5 <- s4 +
  geom_sf(
    data = tree2,
    fill = "chartreuse4",
    colour = "chartreuse4"
  ) +
  coord_sf(expand = FALSE)
s5

# add tree top
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
tree3 <- st_polygon(list(tree_pts3))
plot(tree3)
s6 <- s5 +
  geom_sf(
    data = tree3,
    fill = "chartreuse4",
    colour = "chartreuse4"
  ) +
  coord_sf(expand = FALSE)
s6

# add trunk
s7 <- s6+
  annotate(
    geom = "rect",
    xmin = 0.45,
    xmax = 0.55,
    ymin = 0.2,
    ymax = 0.3,
    fill = "brown"
  )
s7

# add baubels
s8 <- s7 +
  geom_point(colour = "gold",
             data = data.frame(
               x = c(0.3, 0.4, 0.5, 0.6, 0.57, 0.62, 0.45, 0.5),
               y = c(0.325, 0.4, 0.45, 0.35, 0.57, 0.52, 0.6, 0.7),
               size = runif(8, 2, 4.5)
             ),
             mapping = aes(x = x, y = y, size = size)
  ) +
  scale_size_identity()
s8

# add text
s9 <- s8 +
  annotate(
    geom = "text",
    x = 0.5,
    y = 0.875,
    label = "Merry Christmas",
    colour = "red3",
    fontface = "bold",
    size = 18
  )
s9

# add logo 
path <- "images/rwds-logo-150px.png"
img <- readPNG(path, native = TRUE) 
s10 <- s9 +                   
  inset_element(p = img, 
                left = 0.3265, 
                bottom = 0.0, 
                right = 0.6735, 
                top = 0.2
  ) 
s10

ggsave(
  filename = "rwds-christmas-card.png",
  path = "images",
  plot = s10,
  width = 563,
  height = 563,
  units = c("px"),
  dpi = 72
)
