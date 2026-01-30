## Model Calibration and Validation


### Scripts used:

⮕ [**`BAU scenario `**](Model_DinamicaEGO/06_BAU.egomlx)

⮕ [**`TNC-1 scenario `**](Model_DinamicaEGO/07_TNC1.egomlx)

⮕ [**`TNC-2 scenario `**](Model_DinamicaEGO/08_TNC2.egomlx)

### Scenario Design

Future scenarios were simulated using **the same calibrated model adopted in Protocol 5**, preserving the overall model structure, spatial resolution, explanatory variables, and allocation rules. Scenario differentiation was achieved exclusively through targeted modifications applied to key model components.

Future scenarios were modeled by applying targeted modifications to:
- The transition matrix;
- Weights of Evidence associated with regulatory and environmental constraints;
- Allocation parameters, particularly the balance between Expander and Patcher processes.

This approach ensures internal consistency across simulations, allowing differences between scenarios to be attributed solely to changes in assumptions and policy constraints rather than structural model adjustments.

### Operational Criteria of the Scenarios

**1) BAU – Inertial Governance (Business-as-Usual)**  
This scenario assumes the continuation of current land-use dynamics.

- All transitions maintained;
- Weights of Evidence applied as:
  - Permanent Protect Area (APP) = 2  
  - Legal Reserve (RL) = 1  
  - Strictly Protected Areas and Indigenous Lands (UCPI and TI) = 2  

         These weights were applied to increase the level of protection of legally protected areas, reinforcing their restrictive role in land-use transitions by reducing the probability of change within these zones.
---

**2) TNC-1 – Controlled Expansion**  
This scenario represents stricter land-use regulation.

- Transition Native vegetation (1) → Pasture (15) removed;
- Remaining transitions maintained;
- Weights of Evidence adjusted to:
  - APP = 4  
  - Legal Reserve (RL) = 2  
  - UCPI and TI = 4  

---

**3) TNC-2 – Pasture Intensification and Optimization**  
This scenario builds upon TNC-1 by incorporating pasture intensification.

- Same transition rules as TNC-1;
- Inclusion of an intensification layer; For this layer, all transitions set to zero, except:
    - Pasture (15) → Native vegetation (1), assigned a value of -1.5.
  
            Negative weights were used to discourage restoration transitions, reflecting a pasture intensification strategy.
---

### Scenario Outputs

For each simulated scenario (BAU, TNC-1, and TNC-2), the following outputs were generated:

- **Annual simulated land-use and land-cover maps**, generated for each simulation year;
- **Annual spatial probability maps**, generated from the calibrated Weights of Evidence for each modeled transition.

