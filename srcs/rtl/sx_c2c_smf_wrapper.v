//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2022.2 (lin64) Build 3671981 Fri Oct 14 04:59:54 MDT 2022
//Date        : Fri Feb  2 16:47:15 2024
//Host        : eda2 running 64-bit Ubuntu 20.04.6 LTS
//Command     : generate_target sx_c2c_smf_wrapper.bd
//Design      : sx_c2c_smf_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module sx_c2c_smf_wrapper
   (C2C_MASTER_STATUS_LED,
    C2C_SLAVE_STATUS_LED,
    CLK_125_clk_n,
    CLK_125_clk_p,
    GT_AURORA_MASTER_RX_rxn,
    GT_AURORA_MASTER_RX_rxp,
    GT_AURORA_MASTER_TX_txn,
    GT_AURORA_MASTER_TX_txp,
    GT_AURORA_REFCLK_clk_n,
    GT_AURORA_REFCLK_clk_p,
    GT_AURORA_SLAVE_RX_rxn,
    GT_AURORA_SLAVE_RX_rxp,
    GT_AURORA_SLAVE_TX_txn,
    GT_AURORA_SLAVE_TX_txp);
  output C2C_MASTER_STATUS_LED;
  output C2C_SLAVE_STATUS_LED;
  input [0:0]CLK_125_clk_n;
  input [0:0]CLK_125_clk_p;
  input [0:1]GT_AURORA_MASTER_RX_rxn;
  input [0:1]GT_AURORA_MASTER_RX_rxp;
  output [0:1]GT_AURORA_MASTER_TX_txn;
  output [0:1]GT_AURORA_MASTER_TX_txp;
  input GT_AURORA_REFCLK_clk_n;
  input GT_AURORA_REFCLK_clk_p;
  input [0:1]GT_AURORA_SLAVE_RX_rxn;
  input [0:1]GT_AURORA_SLAVE_RX_rxp;
  output [0:1]GT_AURORA_SLAVE_TX_txn;
  output [0:1]GT_AURORA_SLAVE_TX_txp;

  wire C2C_MASTER_STATUS_LED;
  wire C2C_SLAVE_STATUS_LED;
  wire [0:0]CLK_125_clk_n;
  wire [0:0]CLK_125_clk_p;
  wire [0:1]GT_AURORA_MASTER_RX_rxn;
  wire [0:1]GT_AURORA_MASTER_RX_rxp;
  wire [0:1]GT_AURORA_MASTER_TX_txn;
  wire [0:1]GT_AURORA_MASTER_TX_txp;
  wire GT_AURORA_REFCLK_clk_n;
  wire GT_AURORA_REFCLK_clk_p;
  wire [0:1]GT_AURORA_SLAVE_RX_rxn;
  wire [0:1]GT_AURORA_SLAVE_RX_rxp;
  wire [0:1]GT_AURORA_SLAVE_TX_txn;
  wire [0:1]GT_AURORA_SLAVE_TX_txp;

  sx_c2c_smf sx_c2c_smf_i
       (.C2C_MASTER_STATUS_LED(C2C_MASTER_STATUS_LED),
        .C2C_SLAVE_STATUS_LED(C2C_SLAVE_STATUS_LED),
        .CLK_125_clk_n(CLK_125_clk_n),
        .CLK_125_clk_p(CLK_125_clk_p),
        .GT_AURORA_MASTER_RX_rxn(GT_AURORA_MASTER_RX_rxn),
        .GT_AURORA_MASTER_RX_rxp(GT_AURORA_MASTER_RX_rxp),
        .GT_AURORA_MASTER_TX_txn(GT_AURORA_MASTER_TX_txn),
        .GT_AURORA_MASTER_TX_txp(GT_AURORA_MASTER_TX_txp),
        .GT_AURORA_REFCLK_clk_n(GT_AURORA_REFCLK_clk_n),
        .GT_AURORA_REFCLK_clk_p(GT_AURORA_REFCLK_clk_p),
        .GT_AURORA_SLAVE_RX_rxn(GT_AURORA_SLAVE_RX_rxn),
        .GT_AURORA_SLAVE_RX_rxp(GT_AURORA_SLAVE_RX_rxp),
        .GT_AURORA_SLAVE_TX_txn(GT_AURORA_SLAVE_TX_txn),
        .GT_AURORA_SLAVE_TX_txp(GT_AURORA_SLAVE_TX_txp));
endmodule
