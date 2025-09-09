## Overview

**Bit-Serial Processor Core** is a hardware design for efficient, modular, and distributed processing of serial data streams. Unlike traditional processors that require parallel data words, this core performs mathematical operations **directly on a serial bitstream**, eliminating the need for serial-to-parallel conversion and reducing hardware footprint.

## Key Features

*   **The functions** of synchronization, addition, subtraction, arithmetic shift and multiplication by a set of +-41 coefficients 0.05-1.3 through shifts and addition are implemented.
*   **Modular & Scalable Architecture:** The core consists of independent, self-contained processing modules. You can chain these modules into custom pipelines to create complex data processing flows.
*   **Distributed Execution:** Modules are designed to operate across multiple FPGAs or ASICs. Each module uses its own local clock domain, enabling large-scale, spatially distributed processing systems.
*   **Protocol-Agnostic Design:** While the provided examples and synchronization scheme are tailored for the I2S protocol (using BCLK and LRCLK equivalents), the core itself is not limited to audio. It can be adapted to **any serial data protocol** (e.g., TDM, LJ, custom serial streams) with any bit width.
*   **Hardware-Efficient:** By processing data bit-serially, the design minimizes logic resource usage, making it ideal for resource-constrained FPGA applications or high-core-count ASIC designs.
*   **Standard Synchronization:** Modules communicate and synchronize using two simple, global signals:
    *   **Bit Clock:** Coordinates the shift-in and shift-out of individual bits (e.g., Transmit on Falling Edge, Receive on Rising Edge).
    *   **Frame Sync:** Marks the boundary of a data word (e.g., a high or low pulse indicating the start of a new byte or sample).

## Architecture

The system is built from a network of identical or specialized processing units (`Modules`). Each module operates independently on its local clock (`clk`) but remains globally synchronized to the common Bit Clock and Frame Sync signals. Data flows serially from one module to the next, allowing for pipelined arithmetic and signal processing operations without any intermediate parallel registers.

## Use Cases

*   **Distributed Digital Signal Processing (DSP):** For implementing filters (FIR, IIR), arithmetic units, and custom operators across a multi-FPGA setup.
*   **Embedded Audio Processing:** A natural fit for I2S-based audio effects, mixers, and synthesizers due to the native serial interface.
*   **Custom Serial Protocol Processing:** Can be adapted to handle proprietary sensor data, telecommunications streams, or any other serialized data format.
*   **Teaching & Research:** Serves as a clear example of non-von Neumann, spatially-distributed computer architecture.

## Getting Started

This repository contains the SystemVerilog source code, example implementations targeting the I2S protocol, and testbenches for verification.
The modules are compatible with [basics-graphics-music](https://github.com/yuri-panchul/basics-graphics-music).
