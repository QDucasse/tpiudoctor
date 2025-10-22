## TPIU Doctor: ZynqMP setup and diagnosis for the CoreSight TPIU

This repository contains the sources and scripts to setup a Vivado project that simply instantiates the Zynq MPSoC PS/PL interface with trace signals present. It drives those signals into several interfaces and publishes them to AXI for inspection.

> The project uses [vivgit](https://github.com/QDucasse/vivgit) for reproducibility and versioning

### Usage

Possible projects:
- `tpiuvoid`: Basically does nothing, routes the signals to a blackhole inside PL. Is there to generate the corresponding `psu_init`, `pl.dtsi`, etc. for Petalinux.
- `tpiuaxi`: Routes the TPIU `tracedata` signal into AXI-DMA, which can be read using the example program in `src/tpiuax_test.c`

Simply clone the project and run Vivado (tested on 2024.2):

```bash
vivado -mode batch source/create_project.tcl -tclargs <project_name>
vivado -mode batch source/run_synth_impl.tcl -tclargs <project_name>
```
