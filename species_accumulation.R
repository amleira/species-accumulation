# =======================================================
# Species Accumulation Model using Constant Species Curves
# Author: YOUR NAME
# Date: YYYY-MM-DD
# Description: 
# This script computes efficiency and species accumulation 
# based on the number of individuals counted. It models 
# constant species curves and visualizes them.
# =======================================================

# Load necessary package
library(ggplot2)

# --------------------------------------------------------
# Function to calculate efficiency
# Efficiency is defined as the probability of NOT encountering a new species
# Formula: Efficiency = (Number of individuals - Number of species) / Number of individuals
# --------------------------------------------------------
efficiency <- function(num_species, num_individuals) {
  if (num_individuals == 0) {
    return(NA)  # Avoid division by zero
  }
  eff <- (num_individuals - num_species) / num_individuals
  return(eff)
}

# --------------------------------------------------------
# Function for constant species accumulation curve
# The function is based on the logarithmic relationship:
# f(x) = a * ln(x - n) - b
# where a and b are constants, n is species count, and x is individual count.
# --------------------------------------------------------
constant_species_curve <- function(a, b, num_species, num_individuals) {
  if (num_individuals > num_species) {
    curve <- a * log(num_individuals - num_species) - b
  } else {
    curve <- NA  # Avoid log of negative numbers
  }
  return(curve)
}

# --------------------------------------------------------
# Simulation parameters
# Define a range of species counts and individual counts for the model
# --------------------------------------------------------
a <- 1       # Scaling constant for the curve
b <- 0       # Offset constant for the curve
species_counts <- seq(10, 500, by = 10)  # Example range of species counts
individual_counts <- seq(50, 1500, by = 50)  # Example range of individuals counted

# Create a data frame to store results
results <- data.frame()

# --------------------------------------------------------
# Compute efficiency and constant species curves for each combination
# --------------------------------------------------------
for (n in species_counts) {
  for (x in individual_counts) {
    if (x > n) {  # Ensure individuals counted > species to avoid log issues
      eff <- efficiency(n, x)
      curve_val <- constant_species_curve(a, b, n, x)
      results <- rbind(results, data.frame(Species = n, Individuals = x, Efficiency = eff, Curve = curve_val))
    }
  }
}

# --------------------------------------------------------
# Visualization of Efficiency vs. Number of Individuals
# The plot shows how efficiency changes with different numbers of individuals counted
# --------------------------------------------------------
ggplot(results[results$Species %in% c(10, 30, 50, 100, 200, 350, 500), ], 
       aes(x = Individuals, y = Efficiency, color = factor(Species))) +
  geom_line(size = 1) +
  labs(title = "Constant Species Curves",
       subtitle = "Efficiency vs. Number of Individuals Counted",
       x = "Number of Individuals Counted",
       y = "Efficiency",
       color = "Number of Species") +
  theme_minimal()
