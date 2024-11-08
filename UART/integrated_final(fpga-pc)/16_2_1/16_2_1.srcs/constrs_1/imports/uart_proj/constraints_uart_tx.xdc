set_property PACKAGE_PIN W5 [get_ports i_clk_100M]
set_property PACKAGE_PIN R2 [get_ports i_data_valid]
set_property PACKAGE_PIN T1 [get_ports t1]
set_property PACKAGE_PIN A18 [get_ports o_uart_tx]
set_property IOSTANDARD LVCMOS33 [get_ports i_clk_100M]
set_property IOSTANDARD LVCMOS33 [get_ports i_data_valid]
set_property IOSTANDARD LVCMOS33 [get_ports o_uart_tx]
set_property PACKAGE_PIN V17 [get_ports {i_uart_tx_data[0]}]
set_property PACKAGE_PIN V16 [get_ports {i_uart_tx_data[1]}]
set_property PACKAGE_PIN W16 [get_ports {i_uart_tx_data[2]}]
set_property PACKAGE_PIN W17 [get_ports {i_uart_tx_data[3]}]
set_property PACKAGE_PIN W15 [get_ports {i_uart_tx_data[4]}]
set_property PACKAGE_PIN V15 [get_ports {i_uart_tx_data[5]}]
set_property PACKAGE_PIN W14 [get_ports {i_uart_tx_data[6]}]
set_property PACKAGE_PIN W13 [get_ports {i_uart_tx_data[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {i_uart_tx_data[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {i_uart_tx_data[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {i_uart_tx_data[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {i_uart_tx_data[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {i_uart_tx_data[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {i_uart_tx_data[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {i_uart_tx_data[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {i_uart_tx_data[0]}]

set_property PACKAGE_PIN L1 [get_ports uart_tx_ready]
set_property IOSTANDARD LVCMOS33 [get_ports uart_tx_ready]
connect_debug_port dbg_hub/clk [get_nets i_clk_100M_IBUF_BUFG]

set_property IOSTANDARD LVCMOS33 [get_ports t1]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets i_clk_100M_IBUF]