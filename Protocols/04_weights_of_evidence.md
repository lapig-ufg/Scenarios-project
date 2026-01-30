# Weights of Evidence (WoE) – Calculation, Calibration and Correlation 

## Overview

This step aims to quantify the relationship between land use and land cover change transitions and their associated explanatory variables using the **Weights of Evidence (WoE)** approach. The procedure follows the Bayesian framework implemented in **Dinamica EGO**, allowing the estimation, calibration, and validation of transition-specific spatial probabilities.

### Scripts used:

⮕ [**`Calculate Weight of Evidence `**](Model_DinamicaEGO/02_CalcWOE.egomlx)

⮕ [**`Calculate Correlation`**](Model_DinamicaEGO/03_CalcCorrelationWOE.egomlx)


---

## Inputs

### Land Use and Land Cover Maps
- Initial land use and land cover map: `2018`
- Final land use and land cover map: `2023`
- Transition rates derived from observed changes: `Transition Matrix`

### Explanatory Variables
Raster layers presented in the [**`Data Preparation Procotocol`**](Protocols/01_data_preparation.md)

All variables were previously processed to ensure:
- Same spatial resolution
- Same projection
- Spatial alignment
- Consistent NoData values

---

## Calculation of Weights of Evidence

Weights of Evidence were calculated separately for each modeled transition using the **Bayesian WoE method**. This method estimates the degree of association between the occurrence of a transition and the presence of specific ranges or categories of each explanatory variable.

For each variable, the following components were computed:
- **Positive weight (W⁺):** Indicates attraction to the transition
- **Negative weight (W⁻):** Indicates repulsion from the transition
- **Contrast (C = W⁺ − W⁻):** Overall strength of association

Continuous variables were discretized into intervals prior to WoE calculation.

---

## Calibration of Weights

The calibration stage aims to ensure that the Weights of Evidence (WoE) are statistically stable, interpretable, and consistent with the modeled transitions. This step is applied mainly to continuous variables, since Dinamica EGO requires explanatory variables to be represented in categorical form.

The WoE table contains all transitions of interest and the contribution of each explanatory variable. The definition of meaningful value intervals is performed by the modeler and refined through an iterative calibration process.

### Calibration Procedure

- WoE are calculated using distance maps, explanatory variables, and land use and land cover maps from the initial and final time steps.

- The behavior of WoE values is analyzed through visualization tools (e.g., Power BI) to identify unstable or non-informative intervals.

- Class interval limits (minimum and maximum values) are manually adjusted in Dinamica EGO based on statistical significance and model performance.

- The process is repeated as needed until the weights are considered satisfactory.

Only calibrated weights are used in subsequent modeling steps.

---

## Correlation Analysis Between Variables

A correlation analysis is performed after calibration to verify the independence assumption of the WoE method and to avoid redundancy among explanatory variables.

#### Correlation is evaluated using:
- Chi-square (χ²)

- Cramér’s V

 - Contingency coefficient

 - Entropy

- Joint uncertainty information

#### Correlation values range from:

- 0 → independence

- 1 → maximum association

Values greater than 0.50 are interpreted as high correlation (high dependency) between variables.

When high correlation is detected (**values > 0.50**), only the variable that best explains the transition, considering theoretical relevance, spatial interpretability, and stability of the weights, is retained for modeling.


---

## Outputs

This step generated the following outputs:

- Calibrated Weights of Evidence table for each transition ([`See an example here`](Protocols/01_data_preparation.md));
- Reports of excluded and adjusted variables;
- Correlation matrices based on WoE values;
- Final set of explanatory variables selected for each transition.

