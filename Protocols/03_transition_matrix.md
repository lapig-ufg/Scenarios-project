# Transition Matrix Estimation


### Scripts used: 
⮕ [**`EGO Script `**](Model_DinamicaEGO/01_TransitionMatrix.egomlx)

## Objective
This protocol describes the procedure used to estimate land use and land cover transition matrices based on observed changes between the maps originated from MapBiomas.

The transition matrix quantifies the rate of change between land use classes and serves as a key input for Dinamica EGO allocation and simulation modules.

---

## Conceptual Background
Transition matrices represent the observed dynamics of land use change by summarizing how land use classes evolve over time.

In Dinamica EGO, these matrices are used to:
- Define the quantity of change for each transition
- Control annual transition rates
- Support multi-step transition modeling for future scenarios

---

## Input Data

### Land Use and Land Cover Maps
- Source: MapBiomas Collection 9
- Format: raster
- Spatial resolution: 30 m
- Coordinate Reference System (CRS): ESRI:102033
- Time steps:
  - T0: 2018
  - T1: 2023


### Land Use Classes
| Class Code | Description |
|-----------|-------------|
| 1 | Native vegetation |
| 15 | Pasture |
| 21 | Mosaic and other uses |
| 39 | Soybean |

---

## Transition Mapping

### Pairwise Transition Calculation
Transitions were calculated for consecutive periods:
- 2018 → 2023

Transition values were converted to annual rates assuming constant change within the time interval.

The program computes all possible land-use transitions between classes. However, for the simulation, only transitions of specific interest were selected and used in the model, namely:

- Native vegetation (1) → Pasture (15)

- Native vegetation (1) → Soybean (39)

- Native vegetation (1) → Mosaic of uses (21)

- Pasture (15) → Native vegetation (1)

- Pasture (15) → Soybean (39)

- Mosaic of uses (21) → Native vegetation (1)

Mosaic of uses (21) → Soybean (39)
---

##  Time Steps

Single step and multiple step transition matrices were computed. The multiple step approach was used in the simulations because it provides annual transition rates required for yearly land use and land cover change modeling. 

---

## Outputs

- Single step Transition Matrix 
- Multiple step Transition Matrix (Annual Rates)

