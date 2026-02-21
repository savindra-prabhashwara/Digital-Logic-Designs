🖥️ Project Overview

This project implements a hardware-based Sobel Filter engine for real-time edge detection using Verilog. Developed in Xilinx Vivado, the system processes a grayscale image matrix to identify high-contrast boundaries, a fundamental step in computer vision and ADAS applications.

⚙️ Technical Specifications

Algorithm: 2D Convolution using dual 3×3 Sobel kernels for horizontal (Gx​) and vertical (Gy​) gradients.

Resolution: Optimized to handle a 740x415 grayscale image matrix.

Logic Type: Behavioral Verilog modeling for efficient pixel-stream processing.

Verification: Validated using a custom testbench that loads image data and outputs a processed edge-magnitude matrix.

Here are the results of an image of an elk
    
<img width="990" height="556" alt="Screenshot 2026-02-21 122920" src="https://github.com/user-attachments/assets/6ebcd3c8-88c4-4164-b6f8-20ea8301d257" />
    
<img width="1043" height="582" alt="image" src="https://github.com/user-attachments/assets/bb11c499-b1ec-44c0-aa94-18481278b87d" />
    
