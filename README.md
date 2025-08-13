# Tree-georeferencing

This repository provides an R script, `calculate_tree_coords.R`, that
georeferences trees from field measurements. The script:

- Reads a table of trees with an identifier, azimuth, distance and the
  identifier of a reference point.
- Reads a table of reference points with metric `x` and `y` coordinates.
- Converts azimuths to quadrantal angles, computes north–south and
east–west offsets and iteratively calculates coordinates for each tree.
- Adds newly calculated tree coordinates to the reference table so that
  subsequent trees can reference previously calculated trees.

## Usage

1. Prepare a CSV or tab-delimited file with columns `ID`, `azimuth`,
   `distance` and `ref_point`.
2. Prepare a CSV or tab-delimited file of reference points with columns
   `ref_id`, `ref_x` and `ref_y`.
3. Edit the file paths at the top of `calculate_tree_coords.R` to point
   to your data files.
4. Run the script:

   ```bash
   Rscript calculate_tree_coords.R
   ```

   The resulting `ref.df` data frame will include coordinates for all
   trees together with the original reference points.

The script depends on the `REdaS` package for trigonometric helper
functions.

