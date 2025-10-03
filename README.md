# Demonstration of Sparse Hadamard Single-Pixel Imaging Using the \( H_{64} \) Basis

## Overview

This repository presents a comprehensive framework for **Sparse Hadamard Single-Pixel Imaging (SHSI)** utilizing the \( H_{64} \) Hadamard basis. The implementation encompasses:

- Generation of randomized positive and negative sparse Hadamard speckle patterns derived from the \( H_{64} \) matrix.
- Simulation of single-pixel imaging data acquisition employing these speckle patterns.
- High-fidelity image reconstruction via the SHSI algorithm.
- Evaluation of noise robustness through additive white Gaussian noise (AWGN) simulations.
- Quantitative assessment of reconstruction quality using Peak Signal-to-Noise Ratio (PSNR) metrics.

## Repository Contents

- `Generate_hadamard_matrix_random_64_H.m`  
  Script to generate randomized sparse Hadamard speckle patterns based on the \( H_{64} \) matrix. The patterns are saved as PNG images along with the corresponding row and column indices required for SHSI reconstruction, as outlined in **Algorithm 1**:

<div style="text-align:center">
  <img src="Images/Algorithm 1.png" alt="Algorithm 1" />
</div>

- `Natural_Hadamard_Transform.m`  
  Function to generate Hadamard matrices of order \( 2^n \) via Sylvester's construction, yielding matrices in natural order.

- `SHSI.m`  
  Main demonstration script that:
  - Loads the generated speckle patterns and associated indices.
  - Loads and preprocesses a test image (e.g., Cameraman).
  - Simulates single-pixel measurements using the speckle patterns.
  - Performs image reconstruction via SHSI.
  - Assesses noise robustness by adding AWGN and comparing noisy and noise-free reconstructions.
  - Computes and displays PSNR values for quantitative evaluation.

<div style="text-align:center">
  <img src="Images/Algorithm 2.png" alt="Algorithm 2" />
</div>

## Usage Instructions

1. **Generate Hadamard Speckle Patterns**  
   Run `Generate_hadamard_matrix_random_64_H.m` to generate and save the positive and negative sparse Hadamard speckle patterns based on the \( H_{64} \) basis. The patterns and corresponding reconstruction indices will be stored under `./data/Random_Discrete_Hadamard_Postive_and_Negetive_matrix_64_H/`.

2. **Run the SHSI Reconstruction Demo**  
   Execute `SHSI.m` to simulate the single-pixel imaging acquisition and reconstruction process using the generated patterns.

## Experimental Results

(a) Experimental setup for active single-pixel imaging, featuring two ground glasses as occluders.  
(b) Target object: resolution testing board.  
(c–i) Reconstruction results obtained via ADMM-based CS, THSI, THSI combined with the CC, mode one using the \( H_8 \) basis, mode one using the \( H_{256} \) basis, and mode two utilizing the \( H_{256} \) basis combined with the CC at varying sampling rates.

<div style="text-align:center">
  <img src="Images/Experimental results.png" alt="Experimental Results" />
</div>

## Contact

For inquiries or collaboration opportunities, please contact:

**Yuyuan Han**  
Email: hanyuyuan6@gmail.com

---

## Please cite

```bibtex
@article{Han:25,
  author = {Yuyuan Han and Peng Wu and Hanxiong Xu and Bin Li and Yuchen He and Jianbin Liu and Hui Chen and Huaibin Zheng},
  journal = {Opt. Express},
  keywords = {Computational imaging; Imaging systems; Real time imaging; Single pixel imaging; Speckle patterns; Three dimensional imaging},
  number = {20},
  pages = {43324--43341},
  publisher = {Optica Publishing Group},
  title = {Generalized sparse Hadamard single-pixel Imaging},
  volume = {33},
  month = {Oct},
  year = {2025},
  url = {https://opg.optica.org/oe/abstract.cfm?URI=oe-33-20-43324},
  doi = {10.1364/OE.576533},
  abstract = {Scattering presents significant challenges for practical imaging applications. Single-pixel imaging offers advantages over conventional approaches, yet further advances are still required. In this work, we introduce sparse Hadamard speckle patterns with tunable sparsity and propose sparse Hadamard single-pixel imaging (SHSI), a new framework built on these patterns. By integrating orthogonality, sparsity, and pseudo-randomness, the proposed patterns provide clear benefits over traditional Hadamard speckle patterns and their variants. SHSI improves noise robustness across a wide range of sampling rates by encoding sparse but spatially correlated information within each illumination pattern. It also achieves high-resolution imaging with low-order Hadamard matrices, which substantially reduces memory requirements. Moreover, SHSI operates without prior knowledge, training, or post-processing, thereby simplifying implementation. To further enhance performance, we introduce two operational modes and develop a complete theoretical framework that is validated through simulations and experiments. SHSI has the potential to advance computational imaging platforms based on sequential correlation measurements and to enable real-time reconstruction of occluded or embedded targets within scattering media.},
}