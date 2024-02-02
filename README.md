# Chip to Chip Infastructure Template (HAPS-SX + SMF)
This is an example design to be used as a starter template for designs using 2 FPGA chips.
The design includes bi-directional AXI master/slave pathways, and is built on the logiCORE AXI Chip2Chip IP core with 64b/66b serialization.


## Requirements
* Vitis Unified Software Platform 2022.2
  - Vivado 2022.2
  - Vitis IDE 2022.2
* E-Elements HAPS-SX
  - FPGA part xcvu19p-fsva3824-2-e
* E-Elements SMF Daughter Card
  - FGPA part xczu4eg-fbvb900-2-e
* FireFly Connector Cable x1


## Hardware Setup
1. Seat the SMF on the JX12 HT3 port of the HAPS-SX.
2. Connect the FireFly cable from J11(topmost) on the SMF to Q220 on the HAPS-SX. 

<img src="https://github.com/eefae/sx_c2c_ddr/assets/126219401/dd18820f-6304-4fb9-a4da-667f72ed7ad5" width="50%" heigh="50%">


## Getting Started
