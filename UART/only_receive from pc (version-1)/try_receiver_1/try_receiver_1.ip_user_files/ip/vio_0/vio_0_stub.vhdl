-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2022.2 (win64) Build 3671981 Fri Oct 14 05:00:03 MDT 2022
-- Date        : Fri Oct 18 16:11:08 2024
-- Host        : Laptop-dell running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               c:/Users/Dell/fpga/uart/uart_proj/try_receiver_1/try_receiver_1.gen/sources_1/ip/vio_0/vio_0_stub.vhdl
-- Design      : vio_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a35tcpg236-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vio_0 is
  Port ( 
    clk : in STD_LOGIC;
    probe_out0 : out STD_LOGIC_VECTOR ( 0 to 0 )
  );

end vio_0;

architecture stub of vio_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,probe_out0[0:0]";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "vio,Vivado 2022.2";
begin
end;
