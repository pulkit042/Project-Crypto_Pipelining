# 🔐 Crypto Pipeline Verilog (3-Stage Encrypted Hardware System)

This project implements a 3-stage pipelined cryptographic transformation system using Verilog, simulating a real-world asynchronous hardware pipeline with multi-clock domains. It includes:

✅ Input transformation  
✅ FSM-driven state logic  
✅ Cleanup and post-processing  
✅ Reverse module to restore original input  
✅ GTKWave trace of full pipeline and FSM  

---

## 🚀 Features

- 🔄 **16-bit input processing** through 3 modular stages
- 🔑 6-bit compact control key used to drive transformations
- ⏱️ Three independent clocks (`clk1`, `clk2`, `clk3`)
- 🧠 FSM with 4 states (logic, parity, sign-ext, transitions)
- 📦 Handshake-controlled buffers between each stage
- ♻️ **Reverse pipeline** included to recover original input
- 📊 GTKWave waveform analysis (`gtkwave.png`)

---

## 📐 Architecture Overview

![architecture_overview](./images/arch.png)


---

## 🔁 Reverse Module

The `cryptoveril_reverse.v` module performs a **step-by-step undo** of all pipeline transformations. It receives the encrypted output and same `key_bits`, then:

1. **Stage 3 Reverse**: Removes padding/parity/sign-extension
2. **Stage 2 Reverse**: Runs the FSM transitions in reverse
3. **Stage 1 Reverse**: Reverses the left-shift and subtraction

> The reverse design ensures end-to-end testability and functional correctness in cryptographic pipelines — ideal for embedded and secure hardware systems.

---

## 📸 Waveform Snapshot

![GTKWave Screenshot](./images/gtkwave.png)

This screenshot from GTKWave (`gtkwave.png`) shows:

- 🟢 All 3 clocks (`clk1`, `clk2`, `clk3`) running with correct frequency ratios
- 🟢 Input and key updates at intervals
- ✅ Output reflecting valid transformations with pipeline delay
- 🟨 Output changes roughly every 150–200ns after new input — confirming 3-stage latency
- 📈 Proven pipeline correctness and timing

---

## 🧪 Testbench

Testbench (`cryptoveril_tb.v`) includes:

- 3+ input-key combinations
- Reset and clock generation
- Output validation and FSM tracing via `$display`
- Waveform generation using `$dumpfile("fsm_trace.vcd")`

---

## 🔧 Compilation & Simulation

### Used Verilator Simulator
