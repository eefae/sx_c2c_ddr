# Chip2Chip Example Design (HAPS-SX + SMF)
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
  - Petalinux Tools 2022.2
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
  - a
  - b
  - c
* SD Card Boot
  - Prepare an SD card. See [SD Card Setup](#sd-card-setup) for details on SD card partition requirements.
  - Copy ```BOOT.BIN``` into the 1st partition (vfat) of your SD card.
  - Insert SD card into SMF, and flip the boot mode switches into SD boot mode:
  
     <img src="https://github.com/eefae/sx_c2c_ddr/assets/126219401/e4dd9b60-6141-4781-a951-fe44a4447c13" width="50%" heigh="50%">
  - Power on the SMF. The bitstream and test software should automatically load into the SMF. If a serial UART terminal is connected, it will display the output of the DDR sweep test:
  
     <img src="https://github.com/eefae/sx_c2c_ddr/assets/126219401/28f4e231-c7fa-4ffb-87e7-3bf3b2da4414" width="50%" heigh="50%">


  
  
## SD Card Setup
Zynq/PetaLinux requires a specific configuration of partitions and filesystems on the boot SD card.
This section will guide you through the process of setting up the SD card.

View the current partition schemes using `sudo fdisk -l`.

![image](https://user-images.githubusercontent.com/65555647/202134189-1bc00bf1-c3d1-46b6-bf5c-c16048b5525b.png) 

/dev/sdb is our SD card, and 1 partition (sdb1) is listed.


Unmount the SD card partitions using `umount /dev/sdb1`.


Use `sudo fdisk /dev/sdb` to start configuring partitions.

![image](https://user-images.githubusercontent.com/65555647/202135125-960edd1e-59fd-4859-a241-0d8b0f02b56a.png)

Delete all partitions on the SD card.

![image](https://user-images.githubusercontent.com/65555647/202136239-a5e38cbc-f744-42eb-a994-8d329b469907.png)


Petalinux requires 2 partitions, **VFAT for boot**, and **EXT4 for rootfs**. For this guide, we allocated 1 GB to the boot partition, and the rest of the space will go to the rootfs partition.

![image](https://user-images.githubusercontent.com/65555647/202137099-ff2d2009-4f0c-41d8-829a-820eab09b23d.png)
![image](https://user-images.githubusercontent.com/65555647/202137142-ea56cbb2-990e-4db6-ac62-348212d48374.png)

After partitioning, enter `w` to write all changes. `fdisk` should exit after writing.

![image](https://user-images.githubusercontent.com/65555647/202137429-3972b0b8-5e6d-47a1-92ff-acaf45044302.png)


To configure the filesystem type for the partitions:

`sudo mkfs.vfat /dev/sdb1`

`sudo mkfs.ext4 /dev/sdb2`

You may also want to name the partitions with

`sudo fatlabel /dev/sdb1 BOOT`

`sudo e2label /dev/sdb2 ROOT`


Re-mount the SD card and verify that the partitions have been correctly with `df -T`

![image](https://user-images.githubusercontent.com/65555647/202139812-fe8016c8-a943-4d14-8a68-26c7399a89c3.png)

The SD card is now ready to be loaded.



## Petalinux
The C2C link may also be demonstrated under a running OS (Petalinux), although devices need to manually defined in a handwritten device tree. This is due to control endpoints on the HAPS-SX effectively appearing as a black box to the petalinux build tools, as they lie physically on a separate chip.


### Project Creation
To start, create a new Petalinux project:
```petalinux-create -t project -n plnx --template zynqMP```  

```cd plnx``` into the newly created project directory and import the hw description provided in the ```prebuilt``` folder:
```petalinux-config --get-hw-decription sx_c2c_smf.xsa```

This will bring up a configuration screen:  
![image](https://github.com/eefae/sx_c2c_ddr/assets/126219401/6adc96ef-37c0-48ce-bad5-a3c6d109f3db)

Config the root filesystem to EXT4 under Image Packing Configuration --> Root filesystem type
![image](https://github.com/eefae/sx_c2c_ddr/assets/126219401/4d8f5ded-e347-4b0a-807f-ec67c57dba53)

Make sure to save and exit.


### Device Tree
The finalized device tree for Petalinux is a compilation of multiple layers of tree bindings. The file
```plnx/project-spec/meta-user/recipes-bsp/device-tree/files/system-user.dtsi``` is a user-layer device tree that will be addended on top of the auto-generated device tree bindings from your .xsa hardware description.

This is where we will define all the available but 'invisible' devices on the HAPS-SX. In this case, we only have a memory block, so we will create a new memory node as so:
```
/include/ "system-conf.dtsi"
/{  
    memory@1000000000{
        device_type = "memory";
        reg = <0x10 0x00000000 0x04 0x00000000>;
    };
};
```

This will now mark the specified memory region to be available at the OS-level.


### Building and Packaging
To build the Petalinux image, simple use  
```petalinux-build```  

Note that this process may be quite lengthy on a first time build, and may take up to an hour.  
After the build is complete, package the boot binaries and image using  
```petalinux-package --boot --u-boot --force```

