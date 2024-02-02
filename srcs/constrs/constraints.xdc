set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]

create_clock -period 6.400 -name GT_AURORA_REFCLK_clk_p -waveform {0.000 3.200} [get_ports GT_AURORA_REFCLK_clk_p]
set_property PACKAGE_PIN R8 [get_ports GT_AURORA_REFCLK_clk_p]

create_clock -period 8.000 -name CLK_125_clk_p -waveform {0.000 4.000} [get_ports CLK_125_clk_p]
set_property PACKAGE_PIN E17 [get_ports CLK_125_clk_p]
set_property IOSTANDARD DIFF_HSTL_I_18 [get_ports CLK_125_clk_p]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets sx_c2c_smf_i/util_ds_buf_0/U0/USE_IBUFDS.GEN_IBUFDS[0].IBUFDS_I/O]


set_property PACKAGE_PIN H16 [get_ports C2C_MASTER_STATUS_LED]
set_property PACKAGE_PIN J16 [get_ports C2C_SLAVE_STATUS_LED]
set_property IOSTANDARD LVCMOS33 [get_ports C2C_MASTER_STATUS_LED]
set_property IOSTANDARD LVCMOS33 [get_ports C2C_SLAVE_STATUS_LED]


