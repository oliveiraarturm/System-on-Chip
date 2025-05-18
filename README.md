# JPEG Compression on Xilinx Cora Z7 SoC

## Overview

This project implements a **JPEG compression scheme** on a **System-on-Chip (SoC)** platform, specifically the **Xilinx Cora Z7 Dual Core** board from Digilent. The design splits tasks between the hardware-programmable logic and the ARM processing system, leveraging the platform's capabilities for both performance and flexibility.

## Features Implemented

- ✅ **Pipelined DCT Algorithm**  
  Implemented in the hardware-configurable (PL) section of the SoC using VHDL.

- ✅ **AXI-based BRAM Interface**  
  Efficient memory access through the AXI protocol to communicate between the DCT core and BRAM.

- ✅ **Huffman Coding in C**  
  Executed on the ARM Cortex-A9 core (PS), handling entropy coding of quantized DCT coefficients.

- ✅ **Terminal Output**  
  Final compression results are printed to the terminal for validation and debugging.

## Platform

- 🔧 **Hardware**: Xilinx Cora Z7-10 Dual Core (Zynq-7000 SoC)  
- 💻 **Software**: Xilinx Vivado, Vitis (or SDK), C for ARM side  

## Documentation

- 📄 **Full technical report**: `report.pdf`  
- 🧩 **System architecture**: available in the **block diagram** included in the documentation
