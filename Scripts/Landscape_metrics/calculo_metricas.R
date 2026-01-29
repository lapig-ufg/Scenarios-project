library(terra)
library(foreach)
library(doParallel)
library(dplyr)
library(landscapemetrics)
library(progressr)  # <-- pacote para barra
library(progress)

# ---- CONFIGURAÇÃO DO PARALELISMO ----
no_cores <- detectCores() - 2
cl <- makeCluster(no_cores)
registerDoParallel(cl)

# ---- CONFIGURAÇÃO DA BARRA ----
handlers(global = TRUE)
handlers("progress")   # ou "txtprogressbar", "cli", etc.

# ---- CARREGAR RASTERS ----
lulc_2018_path <- "C:\\Users\\Aluno\\Desktop\\Projetos_Cenarios\\AMZCERR_2018_9.tif"
lulc_2023_path <- "C:\\Users\\Aluno\\Desktop\\Projetos_Cenarios\\AMZCERR_2023_9.tif"

lulc_2018 <- rast(lulc_2018_path)
lulc_2023 <- rast(lulc_2023_path)

# ---- DEFINIR AS TRANSIÇÕES ----
transitions <- data.frame(
  from = c(15),
  to   = c(1)
)

# ---- LOOP EM PARALELO COM BARRA ----
results <- with_progress({
  p <- progressor(steps = nrow(transitions))

  foreach(i = 1:nrow(transitions),
          .combine = rbind,
          .packages = c("terra", "dplyr", "landscapemetrics")) %do% {

    p(sprintf("Processando transição %d de %d", i, nrow(transitions)))

    from_class <- transitions$from[i]
    to_class   <- transitions$to[i]

    # --- Isolar células que sofreram a transição ---
    trans_cells <- (lulc_2018 == from_class) * (lulc_2023 == to_class)

    # --- Patches inicial e final ---
    to_class_yr1 <- lulc_2018 == to_class
    patches_yr1 <- patches(to_class_yr1, directions = 8, zeroAsNA = TRUE)
    reg9_1_2018patches <- patches_yr1
    writeRaster(reg9_1_2018patches, "C:\\Users\\Aluno\\Desktop\\Projetos_Cenarios\\reg9_1_2018patches.tif",overwrite=TRUE)

    to_class_yr2 <- lulc_2023 == to_class
    patches_yr2 <- patches(to_class_yr2, directions = 8, zeroAsNA = TRUE)
    reg9_1_2023patches <- patches_yr2
    writeRaster(reg9_1_2023patches, "C:\\Users\\Aluno\\Desktop\\Projetos_Cenarios\\reg9_1_2023patches.tif", overwrite=TRUE)

    # Final_yr1 <- patches_yr1; Final_yr1[patches_yr1 > 0] <- 1; Final_yr1[is.na(Final_yr1[])] <- 0
    # Final_yr2 <- patches_yr2; Final_yr2[patches_yr2 > 0] <- 10; Final_yr2[is.na(Final_yr2[])] <- 0
    # yr1_yr2_patches <- Final_yr1 + Final_yr2

    # --- Expander vs Patcher ---
    expansion_mask <- (patches_yr2 > 0) & (to_class_yr1 > 0)
    patch_class_map <- zonal(expansion_mask, patches_yr2, "max")
    names(patch_class_map) <- c("ID", "is_expander")
    patch_class_map$classification <- ifelse(patch_class_map$is_expander == 1, 1, 0)
    patches_classified <- subst(patches_yr2, patch_class_map$ID, patch_class_map$classification)
    writeRaster(patches_classified, "C:\\Users\\Aluno\\Desktop\\Projetos_Cenarios\\expander_patcher_9_15_1.tif", overwrite=TRUE)

    total_trans_cells   <- sum(values(trans_cells), na.rm = TRUE)
    total_expander_cells <- sum(values(trans_cells * (patches_classified == 1)), na.rm = TRUE)
    total_patcher_cells <- sum(values(trans_cells * (patches_classified == 0)), na.rm = TRUE)

    if (total_trans_cells > 0) {
      perc_expander <- (total_expander_cells / total_trans_cells) * 100
      perc_patcher  <- (total_patcher_cells / total_trans_cells) * 100
    } else {
      perc_expander <- 0
      perc_patcher  <- 0
    }

    # --- Métricas de área e forma ---
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

# Organizar resultados
results_df <- as.data.frame(results)
names(results_df) <- c("From", "To", "MeanPatchArea", "SDPatchArea", "Isometry",
                       "PercExpander", "PercPatcher")
print(results_df)
