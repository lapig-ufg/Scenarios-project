<h2 align="center">Dinamica EGO Models</h2>

This page contains the core scripts used throughout the spatial land-use and land-cover (LULC) simulation workflow of the project. These scripts form the methodological backbone of the modeling framework implemented in Dinamica EGO.

The scripts were consistently applied to all simulated regions, with only region-specific parameters being adjusted. While input datasets and spatial constraints may vary by region, the modeling logic, transition structure, and simulation procedures remain the same.

<h3 align="left">Scope of the scripts</h3>

    The scripts included in this page cover the main stages of the spatial simulation process, including:

  - **Transition Matrix:** Identification and quantification of land-use transitions from historical data to estimate transition rates between classes.
  - **Model calibration:** This have two steps= 
    - **Calculate weight of evidence:** estimation of the spatial influence of explanatory variables on land-use transitions.
    - **Correlation between the weights:** assessment of multicollinearity among explanatory variables to ensure model robustness.
  - **Initial Simulation:** Execution of the landscape through iterative allocation of land-use transitions, generating the final land-use and land-cover map.
  - **Model Validation:** Evaluation of simulated outputs against observed land-use patterns using spatial similarity metrics to assess model performance.
  - **Scenarios simulation:** Implementation of alternative land-use and conservation scenarios through modifications in transition rates, spatial constraints, and incentives, producing comparable future projections.

<h4 align="left">More information about the Dinamica EGO models and submodels is available at the official Dinamica EGO website: (https://csr.ufmg.br/dinamica/).</h4>


