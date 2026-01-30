library(terra)
library(foreach)
library(doParallel)
library(dplyr)
library(landscapemetrics)
library(progressr)  # <-- package for progress bar
library(progress)

# ---- PARALLEL CONFIGURATION ----
no_cores <- detectCores() - 2
cl <- makeCluster(no_cores)
registerDoParallel(cl)

# ---- PROGRESS BAR CONFIGURATION ----
handlers(global = TRUE)
handlers("progress")   # or "txtprogressbar", "cli", etc.

# ---- LOAD RASTERS ----
lulc_2018_path <- "C:\\Users\\Student\\Desktop\\Scenario_Projects\\AMZCERR_2018_9.tif"
lulc_2023_path <- "C:\\Users\\Student\\Desktop\\Scenario_Projects\\AMZCERR_2023_9.tif"

lulc_2018 <- rast(lulc_2018_path)
lulc_2023 <- rast(lulc_2023_path)

# ---- DEFINE TRANSITIONS ----
transitions <- data.frame(
  from = c(15),
  to   = c(1)
)

# ---- PARALLEL LOOP WITH PROGRESS ----
results <- with_progress({
  p <- progressor(steps = nrow(transitions))

  foreach(i = 1:nrow(transitions),
          .combine = rbind,
          .packages = c("terra", "dplyr", "landscapemetrics")) %do% {

    p(sprintf("Processing transition %d of %d", i, nrow(transitions)))

    from_class <- transitions$from[i]
    to_class   <- transitions$to[i]

    # --- Isolate cells that underwent the transition ---
    trans_cells <- (lulc_2018 == from_class) * (lulc_2023 == to_class)

    # --- Initial and final patches ---
    to_class_yr1 <- lulc_2018 == to_class
    patches_yr1 <- patches(to_class_yr1, directions = 8, zeroAsNA = TRUE)
    reg9_1_2018patches <- patches_yr1
    writeRaster(reg9_1_2018patches, "C:\\Users\\Student\\Desktop\\Scenario_Projects\\reg9_1_2018patches.tif", overwrite=TRUE)

    to_class_yr2 <- lulc_2023 == to_class
    patches_yr2 <- patches(to_class_yr2, directions = 8, zeroAsNA = TRUE)
    reg9_1_2023patches <- patches_yr2
    writeRaster(reg9_1_2023patches, "C:\\Users\\Student\\Desktop\\Scenario_Projects\\reg9_1_2023patches.tif", overwrite=TRUE)

    # --- Expander vs Patcher ---
    expansion_mask <- (patches_yr2 > 0) & (to_class_yr1 > 0)
    patch_class_map <- zonal(expansion_mask, patches_yr2, "max")
    names(patch_class_map) <- c("ID", "is_expander")
    patch_class_map$classification <- ifelse(patch_class_map$is_expander == 1, 1, 0)
    patches_classified <- subst(patches_yr2, patch_class_map$ID, patch_class_map$classification)
    writeRaster(patches_classified, "C:\\Users\\Student\\Desktop\\Scenario_Projects\\expander_patcher_9_15_1.tif", overwrite=TRUE)

    total_trans_cells    <- sum(values(trans_cells), na.rm = TRUE)
    total_expander_cells <- sum(values(trans_cells * (patches_classified == 1)), na.rm = TRUE)
    total_patcher_cells  <- sum(values(trans_cells * (patches_classified == 0)), na.rm = TRUE)

    if (total_trans_cells > 0) {
      perc_expander <- (total_expander_cells / total_trans_cells) * 100
      perc_patcher  <- (total_patcher_cells / total_trans_cells) * 100
    } else {
      perc_expander <- 0
      perc_patcher  <- 0
    }

    # --- Area and shape metrics ---
    cl.data <- calculate_lsm(
      trans_cells,
      what = c("lsm_c_area_mn", "lsm_c_area_sd", "lsm_p_circle")
    )

    mpa <- cl.data %>% filter(metric == "area_mn") %>% pull(value)
    sda <- cl.data %>% filter(metric == "area_sd") %>% pull(value)
    mean_circle <- cl.data %>% filter(metric == "circle") %>% pull(value) %>% mean(na.rm = TRUE)
    iso <- (1 - mean_circle) * 2

    c(from_class, to_class, mpa, sda, iso, perc_expander, perc_patcher)
  }
})

stopCluster(cl)

# Organize results
results_df <- as.data.frame(results)
names(results_df) <- c("From", "To", "MeanPatchArea", "SDPatchArea", "Isometry",
                       "PercExpander", "PercPatcher")
print(results_df)
