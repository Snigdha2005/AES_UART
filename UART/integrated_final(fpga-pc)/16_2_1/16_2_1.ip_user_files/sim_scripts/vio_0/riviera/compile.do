vlib work
vlib riviera

vlib riviera/xil_defaultlib

vmap xil_defaultlib riviera/xil_defaultlib

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../16_2_1.gen/sources_1/ip/vio_0/hdl/verilog" "+incdir+../../../../16_2_1.gen/sources_1/ip/vio_0/hdl" \
"../../../../16_2_1.gen/sources_1/ip/vio_0/sim/vio_0.v" \


vlog -work xil_defaultlib \
"glbl.v"

