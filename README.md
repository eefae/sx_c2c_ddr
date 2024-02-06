# Chip to Chip Example Design with DDR R/W (HAPS-SX + SMF)
This is an example design to be used as a starter template for projects between 2 FPGA chips.
The design includes bi-directional AXI master/slave pathways, and is built on the logiCORE AXI Chip2Chip IP core with 64b/66b serialization.

The FPGA fabric of HAPS-SX is made available to the FPGA of the SMF. 
The 16GB SODIMM is therefore accessible to the PS of the SMF.
A simple test program is included that writes & readbacks a short skipping sequence, to demonstrate functionality of the C2C link.

The diagram below illustrates a simplified design structure:
![image](https://github.com/eefae/sx_c2c_ddr/assets/126219401/fd157d26-2087-4691-912a-7842cf226094)


## Requirements
* Vitis Unified Software Platform 2022.2
  - Vivado 2022.2
  - Vitis IDE 2022.2
* E-Elements HAPS-SX
  - FPGA part xcvu19p-fsva3824-2-e
* E-Elements SMF Daughter Card
  - FGPA part xczu4eg-fbvb900-2-e
* FireFly Connector Cable x1


## Getting Started
* Run ```create_prj.sh``` to create a workable Vivado project directory.  
* Run ```clean_prj.sh``` to clean project and delete all generated files.  


## Hardware Setup
1. Seat the SMF on the JX12 HT3 port of the HAPS-SX.  
2. Connect the FireFly cable from J11(topmost) on the SMF to Q220 on the HAPS-SX.  
<img src="https://github.com/eefae/sx_c2c_ddr/assets/126219401/dd18820f-6304-4fb9-a4da-667f72ed7ad5" width="50%" heigh="50%">


## Quick Deployment
Prebuilt deployables are included under the ```prebuilt``` folder.  

### HAPS-SX Side
* Program your HAPS-SX with ```haps_sx.bit```. This can be done using HAPS-SX Configuration Tool, or Vivado Hardware Manager.
  * Ensure that MGT_REFCLK_220 is configured to 100MHz:
   ![image](https://github.com/eefae/sx_c2c_ddr/assets/126219401/18e382c4-1cb9-4745-ba8f-c2dedad86a56)

### SMF Side
You may choose either method below:
* JTAG Boot
  -
  
* SD Card Boot
  - Prepare an SD card. See [SD Card Setup](##-SD-Card-Setup) for details on SD card partition requirements.
  - Copy ```BOOT.BIN``` into the 1st partition (vfat) of your SD card.
  - Insert SD card into SMF, and flip the boot mode switches into SD boot mode:
  
     <img src="https://github.com/eefae/sx_c2c_ddr/assets/126219401/e4dd9b60-6141-4781-a951-fe44a4447c13" width="50%" heigh="50%">
  - Power on the SMF. The bitstream and test software should automatically load into the SMF. If a serial UART terminal is connected, it will display the output of the DDR sweep test:
  
     <img src="https://github.com/eefae/sx_c2c_ddr/assets/126219401/28f4e231-c7fa-4ffb-87e7-3bf3b2da4414" width="50%" heigh="50%">


  
  
## SD Card Setup

