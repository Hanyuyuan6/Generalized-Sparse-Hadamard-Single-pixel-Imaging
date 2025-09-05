# Sparse Hadamard Single-pixel Imaging Using \( H_{64} \) Basis

## Overview

This code demonstrates the generation and reconstruction framework for **Sparse Hadamard Single-pixel Imaging (SHSI)** using the \( H_{64} \) Hadamard basis. 

The implementation includes:

- Generation of randomized positive and negative sparse Hadamard speckle patterns derived from the \( H_{64} \) basis.
- Simulation of single-pixel imaging data acquisition using these patterns.
- Image reconstruction via SHSI.
- Demonstration of noise robustness through additive white Gaussian noise (AWGN) simulations.
- Quantitative evaluation of reconstruction quality with PSNR metrics.


## Repository Contents

- `Generate_hadamard_matrix_random_64_H.m`  
  Generates the randomized sparse Hadamard speckle patterns based on the \( H_{64} \) matrix, saves the patterns as PNG images, and stores accompanying row/column indices for SHSI.

- `Natural_Hadamard_Transform.m`  
  Generates the Hadamard matrix of order \( 2^n \) using the Sylvester construction (natural order).

- `SHSI.m`  
  Main demonstration script that:  
  - Loads the generated speckle patterns and indices.  
  - Loads and preprocesses a test image (e.g., Cameraman).  
  - Simulates single-pixel measurements using the speckle patterns.  
  - Reconstructs the image using the SHSI.  
  - Adds noise to demonstrate robustness and compares clean and noisy reconstructions.  
  - Calculates and displays PSNR values for quantitative assessment.

## Usage Instructions

1. **Generate Hadamard Speckle Patterns**  
   Run `Generate_hadamard_matrix_random_64_H.m` to create and save the positive and negative sparse Hadamard speckle patterns based on the \( H_{64} \) basis. The patterns and the required indices for reconstruction will be saved under `./data/Random_Discrete_Hadamard_Postive_and_Negetive_matrix_64_H/`.

2. **Run the SHSI Reconstruction Demo**  
   Execute `SHSI.m` to simulate the single-pixel imaging acquisition and reconstruction process using the generated patterns.  


## Future Work

This repository serves as a foundational demonstration of SHSI with \( H_{64} \) basis. After manuscript acceptance, the project will be further enriched.

## Contact

For questions or collaboration, please contact:

**Yuyuan Han**  
Email: hanyuyuan6@gmail.com
