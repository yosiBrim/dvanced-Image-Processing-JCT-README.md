# Advanced Image Processing - Final Project 🎓

**Jerusalem College of Technology (JCT)**

This repository contains the final semester project for the Advanced Image Processing course. The project focuses on frequency domain analysis (2D-DFT), image restoration, and automated License Plate Recognition (OCR).

## 👥 Authors
* **Yosi Brim**
* **Elad Asbag** 

## 📑 Project Overview

The project is divided into two main parts:

### Part 1: The Frequency Domain & Deconvolution
* **Vectorized 2D-DFT:** A highly efficient, loop-free MATLAB implementation of the 2D Discrete Fourier Transform using bilinear matrix multiplication. Validated against native `fft2` for accuracy and speed.
* **Satellite Deconvolution:** Frequency domain inverse/Wiener filtering to restore blurred space and aerial images by extracting the optical Point Spread Function (PSF) from a point source.

### Part 2: Automated License Plate Recognition (OCR)
An end-to-end OCR pipeline designed to extract and recognize 7-digit registration numbers from unconstrained license plate images. The algorithmic stages include:
1. Preprocessing & Otsu Global Binarization
2. Morphological Noise Removal (Opening/Closing)
3. 8-Connected Components & Geometric Filtering (Aspect ratio and area rejection)
4. Spatial Left-to-Right Sorting
5. Template Matching Classification via Normalized Cross-Correlation (NCC)

## 📂 Repository Structure
* `src/` - Contains all MATLAB source code and scripts (`main_ocr_pipeline.m`, `my_vectorized_dft.m`, etc.).
* `data/` - Input images, templates, and testing datasets (e.g., `LP_STANDARD.jpg`).
* `docs/` - The final concise engineering report (PDF) and related visual assets.

## 🚀 How to Run (Instructions for Graders)

**Prerequisites:** MATLAB (with the Image Processing Toolbox installed).

**Running the OCR Pipeline:**
1. Clone or download this repository to your local machine.
2. Open MATLAB and navigate to the `src/` directory.
3. Run the main script: `main_ocr_pipeline.m`.
4. A UI file selection dialog will appear. Select a test image from the `data/` folder.
5. The algorithm will automatically process the image, display the segmentation figures, and print the final 7-digit string in the Command Window.
