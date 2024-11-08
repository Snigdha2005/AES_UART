# Model input clock
#set_property IOSTANDARD LVCMOS33 [get_ports i_clk_100M]
#set_property PACKAGE_PIN W5 [get_ports i_clk_100M]

# UART IO related pins
#set_property IOSTANDARD LVCMOS33 [get_ports i_uart_rx]
#set_property PACKAGE_PIN B18 [get_ports i_uart_rx]

create_clock -name ap_clk -period 10.000 [get_ports clk]

set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports u1]
set_property IOSTANDARD LVCMOS33 [get_ports reset]
set_property PACKAGE_PIN W5 [get_ports clk]
set_property PACKAGE_PIN V16 [get_ports u1]
set_property PACKAGE_PIN V17 [get_ports reset]
set_property C_CLK_INPUT_FREQ_HZ 100000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk]
