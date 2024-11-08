## Model input clock
set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property PACKAGE_PIN W5 [get_ports clk]

## UART RX and TX IO related pins
set_property IOSTANDARD LVCMOS33 [get_ports i_uart_rx]
set_property PACKAGE_PIN B18 [get_ports i_uart_rx]

set_property IOSTANDARD LVCMOS33 [get_ports o_uart_tx]
set_property PACKAGE_PIN A18 [get_ports o_uart_tx]

### Reset pin
#set_property IOSTANDARD LVCMOS33 [get_ports reset]
#set_property PACKAGE_PIN V17 [get_ports reset]

## Enable pin for UART transmission
#set_property PACKAGE_PIN R2 [get_ports i_data_valid]
#set_property IOSTANDARD LVCMOS33 [get_ports i_data_valid]

## Chunk select pin for transmission
set_property PACKAGE_PIN U1 [get_ports u1]
set_property IOSTANDARD LVCMOS33 [get_ports u1]

set_property PACKAGE_PIN V17 [get_ports enable]
set_property IOSTANDARD LVCMOS33 [get_ports enable]

set_property PACKAGE_PIN V16 [get_ports i_data_valid]
set_property IOSTANDARD LVCMOS33 [get_ports i_data_valid]

set_property PACKAGE_PIN U16 [get_ports data_ready]
set_property IOSTANDARD LVCMOS33 [get_ports data_ready]

set_property PACKAGE_PIN E19 [get_ports data_tx_ready]
set_property IOSTANDARD LVCMOS33 [get_ports data_tx_ready]

## UART TX Ready Signal
set_property PACKAGE_PIN L1 [get_ports uart_tx_ready]
set_property IOSTANDARD LVCMOS33 [get_ports uart_tx_ready]

## Debug hub settings
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_IBUF_BUFG]
