`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.11.2024 19:18:11
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    input clk1, 
    input reset
    );
    wire plain_text_ce0;
    wire plain_text_ce1;
    wire cipher_text_ce0;
    wire cipher_text_we0;
    wire cipher_text_ce1;
    wire cipher_text_we1;
    wire key_ce0;
    wire key_ce1;
    wire ap_done;
    wire ap_dile;
    wire ap_ready;
    wire [6:0] plain_text_address0;
    wire plain_text_q0;
    wire [6:0] plain_text_address1;
    wire plain_text_q1;
    wire [6:0] cipher_text_address0;
    wire cipher_text_d0;
    wire [6:0] cipher_text_address1;
    wire cipher_text_d1;
    wire cipher_text_q0;
    wire cipher_text_q1;
    wire [3:0] key_address0;
    wire [7:0] key_q0;
    wire [3:0] key_address1;
    wire [7:0] key_q1;
    wire dina, dinb;
    reg [128:0] cipher_text_array;
    
blk_mem_gen_0 plain_text(
  .clka(clk),    // input wire clka
  .ena(plain_text_ce0),      // input wire ena
  .wea(1'b0),      // input wire [0 : 0] wea
  .addra(plain_text_address0),  // input wire [6 : 0] addra
  .dina(dina),    // input wire [0 : 0] dina
  .douta(plain_text_q0),  // output wire [0 : 0] douta
  .clkb(clk),    // input wire clkb
  .enb(plain_text_ce1),      // input wire enb
  .web(1'b0),      // input wire [0 : 0] web
  .addrb(plain_text_address1),  // input wire [6 : 0] addrb
  .dinb(dinb),    // input wire [0 : 0] dinb
  .doutb(plain_text_q1)  // output wire [0 : 0] doutb
);

blk_mem_gen_0 cipher_text(
  .clka(clk),    // input wire clka
  .ena(cipher_text_ce0),      // input wire ena
  .wea(cipher_text_we0),      // input wire [0 : 0] wea
  .addra(cipher_text_address0),  // input wire [6 : 0] addra
  .dina(cipher_text_d0),    // input wire [0 : 0] dina
  .douta(cipher_text_q0),  // output wire [0 : 0] douta
  .clkb(clk),    // input wire clkb
  .enb(cipher_text_ce1),      // input wire enb
  .web(cipher_text_we1),      // input wire [0 : 0] web
  .addrb(cipher_text_address1),  // input wire [6 : 0] addrb
  .dinb(cipher_text_d1),    // input wire [0 : 0] dinb
  .doutb(cipher_text_q1)  // output wire [0 : 0] doutb
);

always @(cipher_text_q0 or cipher_text_q1) begin
    if(ap_ready) begin cipher_text_array = cipher_text_array; end
    else cipher_text_array = {cipher_text_array, cipher_text_q0, cipher_text_q1};
end

blk_mem_gen_1 key(
  .clka(clk),    // input wire clka
  .ena(key_ce0),      // input wire ena
  .addra(key_address0),  // input wire [3 : 0] addra
  .douta(key_q0),  // output wire [7 : 0] douta
  .clkb(clk),    // input wire clkb
  .enb(key_ce1),      // input wire enb
  .addrb(key_address1),  // input wire [3 : 0] addrb
  .doutb(key_q1)  // output wire [7 : 0] doutb
);
    AES_0 encryption(
  .plain_text_ce0(plain_text_ce0),              // output wire plain_text_ce0
  .plain_text_ce1(plain_text_ce1),              // output wire plain_text_ce1
  .cipher_text_ce0(cipher_text_ce0),            // output wire cipher_text_ce0
  .cipher_text_we0(cipher_text_we0),            // output wire cipher_text_we0
  .cipher_text_ce1(cipher_text_ce1),            // output wire cipher_text_ce1
  .cipher_text_we1(cipher_text_we1),            // output wire cipher_text_we1
  .key_ce0(key_ce0),                            // output wire key_ce0
  .key_ce1(key_ce1),                            // output wire key_ce1
  .ap_clk(clk),                              // input wire ap_clk
  .ap_rst(reset),                              // input wire ap_rst
  .ap_start(1'b1),                          // input wire ap_start
  .ap_done(ap_done),                            // output wire ap_done
  .ap_idle(ap_idle),                            // output wire ap_idle
  .ap_ready(ap_ready),                          // output wire ap_ready
  .plain_text_address0(plain_text_address0),    // output wire [6 : 0] plain_text_address0
  .plain_text_q0(plain_text_q0),                // input wire [0 : 0] plain_text_q0
  .plain_text_address1(plain_text_address1),    // output wire [6 : 0] plain_text_address1
  .plain_text_q1(plain_text_q1),                // input wire [0 : 0] plain_text_q1
  .cipher_text_address0(cipher_text_address0),  // output wire [6 : 0] cipher_text_address0
  .cipher_text_d0(cipher_text_d0),              // output wire [0 : 0] cipher_text_d0
  .cipher_text_address1(cipher_text_address1),  // output wire [6 : 0] cipher_text_address1
  .cipher_text_d1(cipher_text_d1),              // output wire [0 : 0] cipher_text_d1
  .key_address0(key_address0),                  // output wire [3 : 0] key_address0
  .key_q0(key_q0),                              // input wire [7 : 0] key_q0
  .key_address1(key_address1),                  // output wire [3 : 0] key_address1
  .key_q1(key_q1)                              // input wire [7 : 0] key_q1
);

  clk_wiz_0 instance_name
   (
    // Clock out ports
    .clk_out1(clk),     // output clk_out1
   // Clock in ports
    .clk_in1(clk1)      // input clk_in1
);

ila_0 ila(
	.clk(clk1), // input wire clk


	.probe0(plain_text_address0), // input wire [6:0]  probe0  
	.probe1(plain_text_q0), // input wire [0:0]  probe1 
	.probe2(plain_text_address1), // input wire [6:0]  probe2 
	.probe3(clk), // input wire [0:0]  probe3 
	.probe4(cipher_text_address0), // input wire [6:0]  probe4 
	.probe5(cipher_text_q0), // input wire [0:0]  probe5 
	.probe6(cipher_text_address1), // input wire [6:0]  probe6 
	.probe7(cipher_text_q1) // input wire [0:0]  probe7 
//	.probe8(clk) // input wire [0:0]  probe8
);



endmodule
