# ⚡ 5-bit Flash ADC with Gray Code Output

This project implements a **high-speed 5-bit Flash Analog-to-Digital Converter (ADC)** using **Verilog HDL**, featuring 31 parallel comparators and a custom Gray code encoder. The design is intended for **ultra-fast and glitch-free digital conversions**, with simulation and verification performed in **ModelSim**.

---

## 🧠 Overview

Flash ADCs are the fastest type of analog-to-digital converters, leveraging parallel comparators to achieve single-clock-cycle conversion. This design improves output reliability by encoding the thermometer code into **Gray code**, which ensures only one bit changes per output level, thereby minimizing glitches and timing issues.

---

## 🚀 Features

- 🔹 **5-bit resolution**: 32 discrete digital levels  
- 🔹 **31 comparators**: for full-scale voltage slicing  
- 🔹 **Gray code output**: prevents digital noise and metastability  
- 🔹 **Verilog HDL**: modular and synthesizable  
- 🔹 **Simulated using ModelSim**: logic- and timing-level verification  
- 🔹 **Testbench included**: for validation and waveform analysis  

---


