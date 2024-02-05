
################################################################
# This is a generated script based on design: c2c
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2022.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source c2c_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcvu19p-fsva3824-2-e
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name sx_c2c_haps

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:axi_traffic_gen:3.0\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:ddr4:2.2\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:smartconnect:1.0\
xilinx.com:ip:system_ila:1.1\
xilinx.com:ip:util_vector_logic:2.0\
xilinx.com:ip:aurora_64b66b:12.0\
xilinx.com:ip:axi_chip2chip:5.0\
xilinx.com:ip:xlconstant:1.1\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: c2c_block
proc create_hier_cell_c2c_block { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_c2c_block() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:display_aurora:GT_Serial_Transceiver_Pins_RX_rtl:1.0 GT_AURORA_MASTER_RX

  create_bd_intf_pin -mode Master -vlnv xilinx.com:display_aurora:GT_Serial_Transceiver_Pins_TX_rtl:1.0 GT_AURORA_MASTER_TX

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 GT_AURORA_REFCLK

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:display_aurora:GT_Serial_Transceiver_Pins_RX_rtl:1.0 GT_AURORA_SLAVE_RX

  create_bd_intf_pin -mode Master -vlnv xilinx.com:display_aurora:GT_Serial_Transceiver_Pins_TX_rtl:1.0 GT_AURORA_SLAVE_TX

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_lite

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi


  # Create pins
  create_bd_pin -dir O axi_c2c_link_status_out
  create_bd_pin -dir O axi_c2c_link_status_out1
  create_bd_pin -dir O channel_up
  create_bd_pin -dir O channel_up1
  create_bd_pin -dir I -type clk init_clk
  create_bd_pin -dir O -from 0 -to 1 lane_up
  create_bd_pin -dir O -from 0 -to 1 lane_up1
  create_bd_pin -dir I -type clk s_aclk
  create_bd_pin -dir I -type rst s_aresetn

  # Create instance: aurora_master, and set properties
  set aurora_master [ create_bd_cell -type ip -vlnv xilinx.com:ip:aurora_64b66b:12.0 aurora_master ]
  set_property -dict [list \
    CONFIG.C_AURORA_LANES {2} \
    CONFIG.C_LINE_RATE {5} \
    CONFIG.C_REFCLK_FREQUENCY {100} \
    CONFIG.C_REFCLK_SOURCE {MGTREFCLK1_of_Quad_X0Y1} \
    CONFIG.C_START_LANE {X0Y6} \
    CONFIG.C_USE_BYTESWAP {true} \
    CONFIG.drp_mode {Disabled} \
    CONFIG.interface_mode {Streaming} \
  ] $aurora_master


  # Create instance: aurora_slave, and set properties
  set aurora_slave [ create_bd_cell -type ip -vlnv xilinx.com:ip:aurora_64b66b:12.0 aurora_slave ]
  set_property -dict [list \
    CONFIG.C_AURORA_LANES {2} \
    CONFIG.C_LINE_RATE {5} \
    CONFIG.C_REFCLK_FREQUENCY {100} \
    CONFIG.C_REFCLK_SOURCE {MGTREFCLK1_of_Quad_X0Y1} \
    CONFIG.C_USE_BYTESWAP {true} \
    CONFIG.SupportLevel {1} \
    CONFIG.drp_mode {Disabled} \
    CONFIG.interface_mode {Streaming} \
  ] $aurora_slave


  # Create instance: c2c_master, and set properties
  set c2c_master [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_chip2chip:5.0 c2c_master ]
  set_property -dict [list \
    CONFIG.C_AXI_ADDR_WIDTH {49} \
    CONFIG.C_AXI_DATA_WIDTH {64} \
    CONFIG.C_INTERFACE_MODE {0} \
    CONFIG.C_INTERFACE_TYPE {2} \
    CONFIG.C_SUPPORT_NARROWBURST {true} \
  ] $c2c_master


  # Create instance: c2c_slave, and set properties
  set c2c_slave [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_chip2chip:5.0 c2c_slave ]
  set_property -dict [list \
    CONFIG.C_AXI_ADDR_WIDTH {40} \
    CONFIG.C_AXI_DATA_WIDTH {64} \
    CONFIG.C_INCLUDE_AXILITE {2} \
    CONFIG.C_INTERFACE_MODE {0} \
    CONFIG.C_INTERFACE_TYPE {2} \
    CONFIG.C_MASTER_FPGA {0} \
    CONFIG.C_M_AXI_ID_WIDTH {0} \
    CONFIG.C_M_AXI_WUSER_WIDTH {0} \
    CONFIG.C_SUPPORT_NARROWBURST {true} \
  ] $c2c_slave


  # Create instance: zero, and set properties
  set zero [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 zero ]
  set_property CONFIG.CONST_VAL {0} $zero


  # Create interface connections
  connect_bd_intf_net -intf_net GT_DIFF_REFCLK1_0_1 [get_bd_intf_pins GT_AURORA_REFCLK] [get_bd_intf_pins aurora_slave/GT_DIFF_REFCLK1]
  connect_bd_intf_net -intf_net GT_SERIAL_RX_0_1 [get_bd_intf_pins GT_AURORA_SLAVE_RX] [get_bd_intf_pins aurora_slave/GT_SERIAL_RX]
  connect_bd_intf_net -intf_net GT_SERIAL_RX_1_1 [get_bd_intf_pins GT_AURORA_MASTER_RX] [get_bd_intf_pins aurora_master/GT_SERIAL_RX]
  connect_bd_intf_net -intf_net aurora_master_GT_SERIAL_TX [get_bd_intf_pins GT_AURORA_MASTER_TX] [get_bd_intf_pins aurora_master/GT_SERIAL_TX]
  connect_bd_intf_net -intf_net aurora_master_USER_DATA_M_AXIS_RX [get_bd_intf_pins aurora_master/USER_DATA_M_AXIS_RX] [get_bd_intf_pins c2c_master/AXIS_RX]
  connect_bd_intf_net -intf_net aurora_slave_GT_SERIAL_TX [get_bd_intf_pins GT_AURORA_SLAVE_TX] [get_bd_intf_pins aurora_slave/GT_SERIAL_TX]
  connect_bd_intf_net -intf_net aurora_slave_USER_DATA_M_AXIS_RX [get_bd_intf_pins aurora_slave/USER_DATA_M_AXIS_RX] [get_bd_intf_pins c2c_slave/AXIS_RX]
  connect_bd_intf_net -intf_net axi_traffic_gen_0_M_AXI [get_bd_intf_pins s_axi] [get_bd_intf_pins c2c_master/s_axi]
  connect_bd_intf_net -intf_net c2c_master_AXIS_TX [get_bd_intf_pins aurora_master/USER_DATA_S_AXIS_TX] [get_bd_intf_pins c2c_master/AXIS_TX]
  connect_bd_intf_net -intf_net c2c_slave_AXIS_TX [get_bd_intf_pins aurora_slave/USER_DATA_S_AXIS_TX] [get_bd_intf_pins c2c_slave/AXIS_TX]
  connect_bd_intf_net -intf_net c2c_slave_m_axi [get_bd_intf_pins m_axi] [get_bd_intf_pins c2c_slave/m_axi]
  connect_bd_intf_net -intf_net c2c_slave_m_axi_lite [get_bd_intf_pins m_axi_lite] [get_bd_intf_pins c2c_slave/m_axi_lite]

  # Create port connections
  connect_bd_net -net aurora_master_channel_up [get_bd_pins channel_up1] [get_bd_pins aurora_master/channel_up] [get_bd_pins c2c_master/axi_c2c_aurora_channel_up]
  connect_bd_net -net aurora_master_lane_up [get_bd_pins lane_up1] [get_bd_pins aurora_master/lane_up]
  connect_bd_net -net aurora_slave_channel_up [get_bd_pins channel_up] [get_bd_pins aurora_slave/channel_up] [get_bd_pins c2c_slave/axi_c2c_aurora_channel_up]
  connect_bd_net -net aurora_slave_gt_refclk1_out [get_bd_pins aurora_master/refclk1_in] [get_bd_pins aurora_slave/gt_refclk1_out]
  connect_bd_net -net aurora_slave_lane_up [get_bd_pins lane_up] [get_bd_pins aurora_slave/lane_up]
  connect_bd_net -net aurora_slave_mmcm_not_locked_out [get_bd_pins aurora_slave/mmcm_not_locked_out] [get_bd_pins c2c_master/aurora_mmcm_not_locked] [get_bd_pins c2c_slave/aurora_mmcm_not_locked]
  connect_bd_net -net aurora_slave_sync_clk_out [get_bd_pins aurora_master/sync_clk] [get_bd_pins aurora_slave/sync_clk_out]
  connect_bd_net -net aurora_slave_user_clk_out [get_bd_pins aurora_master/user_clk] [get_bd_pins aurora_slave/user_clk_out] [get_bd_pins c2c_master/axi_c2c_phy_clk] [get_bd_pins c2c_slave/axi_c2c_phy_clk]
  connect_bd_net -net c2c_master_aurora_pma_init_out [get_bd_pins aurora_master/pma_init] [get_bd_pins c2c_master/aurora_pma_init_out]
  connect_bd_net -net c2c_master_aurora_reset_pb [get_bd_pins aurora_master/reset_pb] [get_bd_pins c2c_master/aurora_reset_pb]
  connect_bd_net -net c2c_master_axi_c2c_link_status_out [get_bd_pins axi_c2c_link_status_out1] [get_bd_pins c2c_master/axi_c2c_link_status_out]
  connect_bd_net -net c2c_slave_aurora_pma_init_out [get_bd_pins aurora_slave/pma_init] [get_bd_pins c2c_slave/aurora_pma_init_out]
  connect_bd_net -net c2c_slave_aurora_reset_pb [get_bd_pins aurora_slave/reset_pb] [get_bd_pins c2c_slave/aurora_reset_pb]
  connect_bd_net -net c2c_slave_axi_c2c_link_status_out [get_bd_pins axi_c2c_link_status_out] [get_bd_pins c2c_slave/axi_c2c_link_status_out]
  connect_bd_net -net clk_wiz_0_clk_100M [get_bd_pins s_aclk] [get_bd_pins c2c_master/s_aclk] [get_bd_pins c2c_slave/m_aclk] [get_bd_pins c2c_slave/m_axi_lite_aclk]
  connect_bd_net -net clk_wiz_0_clk_50M [get_bd_pins init_clk] [get_bd_pins aurora_master/init_clk] [get_bd_pins aurora_slave/init_clk] [get_bd_pins c2c_master/aurora_init_clk] [get_bd_pins c2c_slave/aurora_init_clk]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins s_aresetn] [get_bd_pins c2c_master/s_aresetn] [get_bd_pins c2c_slave/m_aresetn]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins c2c_master/aurora_pma_init_in] [get_bd_pins c2c_slave/aurora_pma_init_in] [get_bd_pins zero/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set C0_DDR4_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 C0_DDR4_0 ]

  set DDR_REFCLK [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 DDR_REFCLK ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {300000000} \
   ] $DDR_REFCLK

  set GCLK3 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 GCLK3 ]

  set GT_AURORA_MASTER_RX [ create_bd_intf_port -mode Slave -vlnv xilinx.com:display_aurora:GT_Serial_Transceiver_Pins_RX_rtl:1.0 GT_AURORA_MASTER_RX ]

  set GT_AURORA_MASTER_TX [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_aurora:GT_Serial_Transceiver_Pins_TX_rtl:1.0 GT_AURORA_MASTER_TX ]

  set GT_AURORA_REFCLK [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 GT_AURORA_REFCLK ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {100000000} \
   ] $GT_AURORA_REFCLK

  set GT_AURORA_SLAVE_RX [ create_bd_intf_port -mode Slave -vlnv xilinx.com:display_aurora:GT_Serial_Transceiver_Pins_RX_rtl:1.0 GT_AURORA_SLAVE_RX ]

  set GT_AURORA_SLAVE_TX [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_aurora:GT_Serial_Transceiver_Pins_TX_rtl:1.0 GT_AURORA_SLAVE_TX ]


  # Create ports
  set RST_BTN [ create_bd_port -dir I -type rst RST_BTN ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] $RST_BTN

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [list \
    CONFIG.NUM_MI {1} \
    CONFIG.NUM_SI {1} \
  ] $axi_interconnect_0


  # Create instance: axi_traffic_gen_0, and set properties
  set axi_traffic_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_traffic_gen:3.0 axi_traffic_gen_0 ]
  set_property -dict [list \
    CONFIG.ATG_OPTIONS {Custom} \
    CONFIG.C_ATG_MODE {AXI4} \
    CONFIG.C_ATG_MODE_L2 {Basic} \
    CONFIG.C_EXTENDED_ADDRESS_WIDTH {49} \
    CONFIG.C_M_AXI_DATA_WIDTH {64} \
    CONFIG.C_S_AXI_DATA_WIDTH {64} \
  ] $axi_traffic_gen_0


  # Create instance: c2c_block
  create_hier_cell_c2c_block [current_bd_instance .] c2c_block

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [list \
    CONFIG.CLKOUT1_JITTER {353.718} \
    CONFIG.CLKOUT1_PHASE_ERROR {545.974} \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {78.125} \
    CONFIG.CLKOUT2_JITTER {342.109} \
    CONFIG.CLKOUT2_PHASE_ERROR {545.974} \
    CONFIG.CLKOUT2_USED {true} \
    CONFIG.CLK_OUT1_PORT {clk_78_125M} \
    CONFIG.CLK_OUT2_PORT {clk_100M} \
    CONFIG.MMCM_CLKFBOUT_MULT_F {71.875} \
    CONFIG.MMCM_CLKOUT0_DIVIDE_F {11.500} \
    CONFIG.MMCM_CLKOUT1_DIVIDE {9} \
    CONFIG.MMCM_DIVCLK_DIVIDE {8} \
    CONFIG.NUM_OUT_CLKS {2} \
    CONFIG.PRIM_SOURCE {Differential_clock_capable_pin} \
    CONFIG.USE_LOCKED {false} \
    CONFIG.USE_RESET {false} \
  ] $clk_wiz_0


  # Create instance: ddr4_0, and set properties
  set ddr4_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ddr4:2.2 ddr4_0 ]
  set_property -dict [list \
    CONFIG.C0.DDR4_CasWriteLatency {11} \
    CONFIG.C0.DDR4_InputClockPeriod {3335} \
    CONFIG.C0.DDR4_MemoryPart {MTA16ATF2G64HZ-2G3} \
    CONFIG.C0.DDR4_MemoryType {SODIMMs} \
    CONFIG.C0.DDR4_TimePeriod {938} \
  ] $ddr4_0


  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: proc_sys_reset_1, and set properties
  set proc_sys_reset_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_1 ]

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property CONFIG.NUM_SI {1} $smartconnect_0


  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [list \
    CONFIG.C_DATA_DEPTH {16384} \
    CONFIG.C_MON_TYPE {NATIVE} \
    CONFIG.C_NUM_OF_PROBES {6} \
  ] $system_ila_0


  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property CONFIG.C_OPERATION {not} $util_vector_logic_0


  # Create interface connections
  connect_bd_intf_net -intf_net C0_SYS_CLK_0_1 [get_bd_intf_ports DDR_REFCLK] [get_bd_intf_pins ddr4_0/C0_SYS_CLK]
  connect_bd_intf_net -intf_net CLK_IN1_D_0_1 [get_bd_intf_ports GCLK3] [get_bd_intf_pins clk_wiz_0/CLK_IN1_D]
  connect_bd_intf_net -intf_net GT_DIFF_REFCLK1_0_1 [get_bd_intf_ports GT_AURORA_REFCLK] [get_bd_intf_pins c2c_block/GT_AURORA_REFCLK]
  connect_bd_intf_net -intf_net GT_SERIAL_RX_0_1 [get_bd_intf_ports GT_AURORA_SLAVE_RX] [get_bd_intf_pins c2c_block/GT_AURORA_SLAVE_RX]
  connect_bd_intf_net -intf_net GT_SERIAL_RX_1_1 [get_bd_intf_ports GT_AURORA_MASTER_RX] [get_bd_intf_pins c2c_block/GT_AURORA_MASTER_RX]
  connect_bd_intf_net -intf_net aurora_master_GT_SERIAL_TX [get_bd_intf_ports GT_AURORA_MASTER_TX] [get_bd_intf_pins c2c_block/GT_AURORA_MASTER_TX]
  connect_bd_intf_net -intf_net aurora_slave_GT_SERIAL_TX [get_bd_intf_ports GT_AURORA_SLAVE_TX] [get_bd_intf_pins c2c_block/GT_AURORA_SLAVE_TX]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins ddr4_0/C0_DDR4_S_AXI]
  connect_bd_intf_net -intf_net axi_traffic_gen_0_M_AXI [get_bd_intf_pins axi_traffic_gen_0/M_AXI] [get_bd_intf_pins c2c_block/s_axi]
  connect_bd_intf_net -intf_net c2c_slave_m_axi [get_bd_intf_pins axi_interconnect_0/S00_AXI] [get_bd_intf_pins c2c_block/m_axi]
  connect_bd_intf_net -intf_net c2c_slave_m_axi_lite [get_bd_intf_pins c2c_block/m_axi_lite] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net ddr4_0_C0_DDR4 [get_bd_intf_ports C0_DDR4_0] [get_bd_intf_pins ddr4_0/C0_DDR4]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins axi_traffic_gen_0/S_AXI] [get_bd_intf_pins smartconnect_0/M00_AXI]

  # Create port connections
  connect_bd_net -net aurora_master_channel_up [get_bd_pins c2c_block/channel_up1] [get_bd_pins system_ila_0/probe3]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets aurora_master_channel_up]
  connect_bd_net -net aurora_master_lane_up [get_bd_pins c2c_block/lane_up1] [get_bd_pins system_ila_0/probe4]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets aurora_master_lane_up]
  connect_bd_net -net aurora_slave_channel_up [get_bd_pins c2c_block/channel_up] [get_bd_pins system_ila_0/probe0]
  connect_bd_net -net aurora_slave_lane_up [get_bd_pins c2c_block/lane_up] [get_bd_pins system_ila_0/probe1]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets aurora_slave_lane_up]
  connect_bd_net -net c2c_master_axi_c2c_link_status_out [get_bd_pins c2c_block/axi_c2c_link_status_out1] [get_bd_pins system_ila_0/probe5]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets c2c_master_axi_c2c_link_status_out]
  connect_bd_net -net c2c_slave_axi_c2c_link_status_out [get_bd_pins c2c_block/axi_c2c_link_status_out] [get_bd_pins system_ila_0/probe2]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets c2c_slave_axi_c2c_link_status_out]
  connect_bd_net -net clk_wiz_0_clk_100M [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins axi_traffic_gen_0/s_axi_aclk] [get_bd_pins c2c_block/s_aclk] [get_bd_pins clk_wiz_0/clk_100M] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins smartconnect_0/aclk] [get_bd_pins system_ila_0/clk]
  connect_bd_net -net clk_wiz_0_clk_50M [get_bd_pins c2c_block/init_clk] [get_bd_pins clk_wiz_0/clk_78_125M]
  connect_bd_net -net ddr4_0_c0_ddr4_ui_clk [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins ddr4_0/c0_ddr4_ui_clk] [get_bd_pins proc_sys_reset_1/slowest_sync_clk]
  connect_bd_net -net ddr4_0_c0_ddr4_ui_clk_sync_rst [get_bd_pins ddr4_0/c0_ddr4_ui_clk_sync_rst] [get_bd_pins proc_sys_reset_1/ext_reset_in]
  connect_bd_net -net ext_reset_in_0_1 [get_bd_ports RST_BTN] [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins axi_traffic_gen_0/s_axi_aresetn] [get_bd_pins c2c_block/s_aresetn] [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins smartconnect_0/aresetn]
  connect_bd_net -net proc_sys_reset_1_peripheral_aresetn [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins ddr4_0/c0_ddr4_aresetn] [get_bd_pins proc_sys_reset_1/peripheral_aresetn]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins ddr4_0/sys_rst] [get_bd_pins util_vector_logic_0/Res]

  # Create address segments
  assign_bd_address -offset 0x76000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_traffic_gen_0/Data] [get_bd_addr_segs c2c_block/c2c_master/s_axi/Mem0] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces c2c_block/c2c_slave/MAXI-Lite] [get_bd_addr_segs axi_traffic_gen_0/S_AXI/Reg0] -force
  assign_bd_address -offset 0x001000000000 -range 0x000400000000 -target_address_space [get_bd_addr_spaces c2c_block/c2c_slave/MAXI] [get_bd_addr_segs ddr4_0/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   "ActiveEmotionalView":"Default View",
   "Default View_ScaleFactor":"0.384747",
   "Default View_TopLeft":"-185,-16",
   "ExpandedHierarchyInLayout":"",
   "guistr":"# # String gsaved with Nlview 7.0r4  2019-12-20 bk=1.5203 VDI=41 GEI=36 GUI=JA:10.0 TLS
#  -string -flagsOSRD
preplace port GT_AURORA_MASTER_RX -pg 1 -lvl 0 -x -70 -y 140 -defaultsOSRD
preplace port GT_AURORA_MASTER_TX -pg 1 -lvl 7 -x 2610 -y 0 -defaultsOSRD
preplace port GT_AURORA_SLAVE_RX -pg 1 -lvl 0 -x -70 -y 100 -defaultsOSRD
preplace port GT_AURORA_SLAVE_TX -pg 1 -lvl 7 -x 2610 -y 40 -defaultsOSRD
preplace port GT_AURORA_REFCLK -pg 1 -lvl 0 -x -70 -y 0 -defaultsOSRD
preplace port GCLK3 -pg 1 -lvl 0 -x -70 -y 570 -defaultsOSRD
preplace port C0_DDR4_0 -pg 1 -lvl 7 -x 2610 -y 350 -defaultsOSRD
preplace port DDR_REFCLK -pg 1 -lvl 0 -x -70 -y -50 -defaultsOSRD
preplace port port-id_RST_BTN -pg 1 -lvl 0 -x -70 -y 450 -defaultsOSRD
preplace inst axi_interconnect_0 -pg 1 -lvl 5 -x 1910 -y 300 -defaultsOSRD
preplace inst clk_wiz_0 -pg 1 -lvl 1 -x 90 -y 570 -defaultsOSRD
preplace inst proc_sys_reset_0 -pg 1 -lvl 2 -x 420 -y 470 -defaultsOSRD
preplace inst system_ila_0 -pg 1 -lvl 6 -x 2370 -y 70 -defaultsOSRD
preplace inst ddr4_0 -pg 1 -lvl 6 -x 2370 -y 400 -defaultsOSRD
preplace inst util_vector_logic_0 -pg 1 -lvl 3 -x 920 -y 430 -defaultsOSRD
preplace inst proc_sys_reset_1 -pg 1 -lvl 4 -x 1370 -y 360 -defaultsOSRD
preplace inst axi_traffic_gen_0 -pg 1 -lvl 3 -x 920 -y 230 -defaultsOSRD
preplace inst smartconnect_0 -pg 1 -lvl 5 -x 1910 -y 480 -defaultsOSRD
preplace inst c2c_block -pg 1 -lvl 4 -x 1370 -y 140 -defaultsOSRD
preplace netloc aurora_master_channel_up 1 4 2 1710 90 N
preplace netloc aurora_master_lane_up 1 4 2 1720 110 N
preplace netloc aurora_slave_channel_up 1 4 2 1670 30 N
preplace netloc aurora_slave_lane_up 1 4 2 1690 50 N
preplace netloc c2c_master_axi_c2c_link_status_out 1 4 2 1730 130 N
preplace netloc c2c_slave_axi_c2c_link_status_out 1 4 2 N 150 2100
preplace netloc clk_wiz_0_clk_100M 1 1 5 230 220 600 120 1100 -60 1630 10 N
preplace netloc clk_wiz_0_clk_50M 1 1 3 220J 110 NJ 110 1070
preplace netloc ddr4_0_c0_ddr4_ui_clk 1 3 4 1140 -10 1700 170 2100J 190 2550
preplace netloc ddr4_0_c0_ddr4_ui_clk_sync_rst 1 3 4 1130 -40 NJ -40 2110J -50 2560
preplace netloc ext_reset_in_0_1 1 0 3 NJ 450 240 370 600J
preplace netloc proc_sys_reset_0_peripheral_aresetn 1 2 3 610 130 1120 -20 1660
preplace netloc proc_sys_reset_1_peripheral_aresetn 1 4 2 1740 180 2080
preplace netloc util_vector_logic_0_Res 1 3 3 1080 -70 1610 -50 2090
preplace netloc C0_SYS_CLK_0_1 1 0 6 NJ -50 NJ -50 NJ -50 N -50 1600J 100 2110J
preplace netloc CLK_IN1_D_0_1 1 0 1 NJ 570
preplace netloc GT_DIFF_REFCLK1_0_1 1 0 4 NJ 0 NJ 0 NJ 0 1090
preplace netloc GT_SERIAL_RX_0_1 1 0 4 NJ 100 NJ 100 NJ 100 N
preplace netloc GT_SERIAL_RX_1_1 1 0 4 NJ 140 NJ 140 NJ 140 N
preplace netloc aurora_master_GT_SERIAL_TX 1 4 3 1620J -70 NJ -70 2580J
preplace netloc aurora_slave_GT_SERIAL_TX 1 4 3 1640J -60 NJ -60 2570J
preplace netloc axi_interconnect_0_M00_AXI 1 5 1 2070 300n
preplace netloc axi_traffic_gen_0_M_AXI 1 3 1 1110 120n
preplace netloc c2c_slave_m_axi 1 4 1 1680 50n
preplace netloc c2c_slave_m_axi_lite 1 4 1 1650 70n
preplace netloc ddr4_0_C0_DDR4 1 6 1 NJ 350
preplace netloc smartconnect_0_M00_AXI 1 2 4 620 -30 N -30 N -30 2060
levelinfo -pg 1 -70 90 420 920 1370 1910 2370 2610
pagesize -pg 1 -db -bbox -sgen -310 -240 2840 1110
"
}

  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


