module AES(enable, in, encrypted128);

//input clk1;
//wire e128;
//output wire e192;
//output wire e256;
input enable;
input [127:0] in;
// The plain text used as input
//wire[127:0] in = 128'h00112233445566778899aabbccddeeff;

// The different keys used for testing (one of each type)
wire[127:0] key128 = 128'h000102030405060708090a0b0c0d0e0f;
wire[191:0] key192 = 192'h000102030405060708090a0b0c0d0e0f1011121314151617;
wire[255:0] key256 = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;

// The expected outputs from the encryption module
//wire[127:0] expected128 = 128'h69c4e0d86a7b0430d8cdb78070b4c55a;
//wire[127:0] expected192 = 128'hdda97ca4864cdfe06eaf70a0ec0d7191;
//wire[127:0] expected256 = 128'h8ea2b7ca516745bfeafc49904b496089;

// The result of the encryption module for every type
output [127:0] encrypted128;
//wire[127:0] encrypted192;
//wire[127:0] encrypted256;

//assign e128 = (encrypted128 == expected128 && enable) ? 1'b1 : 1'b0;
//assign e192 = (encrypted192 == expected192 && enable) ? 1'b1 : 1'b0;
//assign e256 = (encrypted256 == expected256 && enable) ? 1'b1 : 1'b0;

AES_Encrypt a(in,key128,encrypted128);
//AES_Encrypt #(192,12,6) b(in,key192,encrypted192);
//AES_Encrypt #(256,14,8) c(in,key256,encrypted256);

//  clk_wiz_0 clock
//   (
//    // Clock out ports
//    .clk_out1(clk),     // output clk_out1
//   // Clock in ports
//    .clk_in1(clk1)      // input clk_in1
//);
//vio_0 vio (
//  .clk(clk1),                // input wire clk
//  .probe_out0(enable)  // output wire [0 : 0] probe_out0
//);
//ila_1 your_instance_name (
//	.clk(clk1), // input wire clk


//	.probe0(expected_128), // input wire [127:0]  probe0  
//	.probe1(encrypted_128), // input wire [127:0]  probe1 
//	.probe2(expected_192), // input wire [127:0]  probe2 
//	.probe3(expected_192), // input wire [127:0]  probe3 
//	.probe4(expected_256), // input wire [127:0]  probe4 
//	.probe5(expected_256), // input wire [127:0]  probe5 
//	.probe6(clk),
//	.probe7(enable) // input wire [0:0]  probe6
//);


endmodule