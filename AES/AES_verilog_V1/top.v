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
    input clk, 
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
    reg plain_text_q0;
    wire [6:0] plain_text_address1;
    reg plain_text_q1;
    wire [6:0] cipher_text_address0;
    wire cipher_text_d0;
    wire [6:0] cipher_text_address1;
    wire cipher_text_d1;
    wire [3:0] key_address0;
    reg [7:0] key_q0;
    wire [3:0] key_address1;
    reg [7:0] key_q1;
    
    AES_0 trial(
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
ila_0 your_instance_name (
	.clk(clk), // input wire clk


	.probe0(plain_text_address0), // input wire [6:0]  probe0  
	.probe1(plain_text_q0), // input wire [0:0]  probe1 
	.probe2(plain_text_address1), // input wire [6:0]  probe2 
	.probe3(plain_textq1), // input wire [0:0]  probe3 
	.probe4(cipher_text_address0), // input wire [6:0]  probe4 
	.probe5(cipher_text_d0), // input wire [0:0]  probe5 
	.probe6(cipher_text_address1), // input wire [6:0]  probe6 
	.probe7(cipher_text_d1) // input wire [0:0]  probe7
);

always @(posedge clk) begin
    plain_text_q0 = 1'b1;
    plain_text_q1 = 1'b0;
    key_q0 = 8'b10010001;
    key_q1 = 8'b00011110;
end


endmodule
