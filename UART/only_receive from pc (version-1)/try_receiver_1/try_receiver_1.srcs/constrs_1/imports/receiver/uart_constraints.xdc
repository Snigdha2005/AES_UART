# Model input clock
set_property IOSTANDARD LVCMOS33 [get_ports i_clk_100M]
set_property PACKAGE_PIN W5 [get_ports i_clk_100M]

# UART IO related pins
set_property IOSTANDARD LVCMOS33 [get_ports i_uart_rx]
set_property PACKAGE_PIN B18 [get_ports i_uart_rx]

# Seven segment displays related pins
set_property IOSTANDARD LVCMOS33 [get_ports {anodes[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {anodes[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {anodes[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {anodes[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cathodes[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cathodes[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cathodes[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cathodes[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cathodes[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cathodes[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cathodes[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cathodes[0]}]

set_property PACKAGE_PIN W4 [get_ports {anodes[3]}]
set_property PACKAGE_PIN V4 [get_ports {anodes[2]}]
set_property PACKAGE_PIN U4 [get_ports {anodes[1]}]
set_property PACKAGE_PIN U2 [get_ports {anodes[0]}]
set_property PACKAGE_PIN W7 [get_ports {cathodes[7]}]
set_property PACKAGE_PIN W6 [get_ports {cathodes[6]}]
set_property PACKAGE_PIN U8 [get_ports {cathodes[5]}]
set_property PACKAGE_PIN V8 [get_ports {cathodes[4]}]
set_property PACKAGE_PIN U5 [get_ports {cathodes[3]}]
set_property PACKAGE_PIN V5 [get_ports {cathodes[2]}]
set_property PACKAGE_PIN U7 [get_ports {cathodes[1]}]
set_property PACKAGE_PIN V7 [get_ports {cathodes[0]}]