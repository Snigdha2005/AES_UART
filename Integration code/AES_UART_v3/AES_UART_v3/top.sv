
`timescale 1ns / 1ps

module top(
    input clk, 
    input reset,
    input u1
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
    wire ap_idle;
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
    localparam integer N_DATA_BITS = 8;
    localparam integer N_TOTAL = 128;
    // Define parameters and an array to store the received cipher text
localparam integer CIPHER_TEXT_SIZE = 128; // Adjust size as needed
reg [CIPHER_TEXT_SIZE-1:0] cipher_text_array ;
wire [CIPHER_TEXT_SIZE-1:0] cipher_text_array1 ; // Array for cipher text storage
reg [5:0] cipher_text_index = 0; // Index for storing cipher text (6 bits for indexing up to 64 locations)

// Flag to alternate between d0 and d1
reg toggle;

// Flag to indicate storing is complete
reg cipher_text_store_complete;
    wire i_uart_rx;
    reg write_into_bram;
    reg [N_DATA_BITS-1:0] data_array [0:15];
    reg [N_DATA_BITS*16-1:0] data_array_flat;
     localparam integer N_ADDR_BITS = 7;  // Address width (7 bits for 128 locations)

    // Signals for dual-port RAM
    reg ena, enb;                       // Enable signals for each port
    reg wea, web = 0;                       // Write enable signals for each port
    reg [N_ADDR_BITS-1:0] addra, addrb; // Address signals for each port
    reg [N_DATA_BITS-1:0] dina, dinb;   // Data input signals for each port
    wire [N_DATA_BITS-1:0] douta, doutb;// Data output signals for each port
    reg reset_uart_top = 1'b1;
    reg o_uart_tx;
    reg uart_tx_ready;
    assign cipher_text_array1 = cipher_text_array;
        top_controller top_rx(.i_clk_100M(clk), 
                          .i_uart_rx(i_uart_rx),
                          .i_data_valid(cipher_text_store_complete),
                          .data_array(data_array),.u1(u1),
                          .o_uart_tx(o_uart_tx),
                          .uart_tx_ready(uart_tx_ready),
                          .data_combined(cipher_text_array1), .reset(reset_uart_top));
                          
 

// Flatten the 2D data_array into the 1D data_array_flat
genvar j;
generate
    for (j = 0; j < 16; j = j + 1) begin
        always @(*) begin
            data_array_flat[j*8 +: 8] = data_array[j];  // Flatten each byte
        end
    end
endgenerate
    blk_mem_gen_1 your_instance_name (
  .clka(clk),    // input wire clka
  .ena(plain_text_ce0),      // input wire ena
  .wea(wea),      // input wire [0 : 0] wea
  .addra(plain_text_address0),  // input wire [6 : 0] addra
  .dina(dina),    // input wire [0 : 0] dina
  .douta(plain_text_q0),  // output wire [0 : 0] douta
  .clkb(clk),    // input wire clkb
  .enb(plain_text_ce1),      // input wire enb
  .web(web),      // input wire [0 : 0] web
  .addrb(plain_text_address0),  // input wire [6 : 0] addrb
  .dinb(dinb),    // input wire [0 : 0] dinb
  .doutb(plain_text_q1)  // output wire [0 : 0] doutb
);
reg [4:0] i;               // Counter for loop iteration (use a suitable width for indexing)
//reg write_into_bram;       // Signal to indicate writing is complete

always @(posedge clk or posedge reset) begin
    if (reset) begin
        i <= 0;                       // Reset counter
        write_into_bram <= 0;         // Reset completion flag
        wea <= 0;                     // Disable write enable initially
    end else if (!write_into_bram) begin
        addra <= i;                   // Set address to current index
        dina <= data_array_flat[i];        // Set data input for BRAM write
        wea <= 1;                     // Enable write for this cycle

        if (i == N_DATA_BITS*16 - 1) begin
            write_into_bram <= 1;     // Set completion flag when last element is written
            wea <= 0;                 // Disable write enable after completion
        end else begin
            i <= i + 1;               // Increment index for next cycle
        end
    end else begin
        wea <= 0;                     // Keep write disabled once all data is written
    end
end

    
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
  .ap_start(write_into_bram),                          // input wire ap_start
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

//blk_mem_gen_2 key (
//  .clka(clk),    // input wire clka
//  .ena(key_ce0),      // input wire ena
//  .addra(key_address0),  // input wire [3 : 0] addra
//  .douta(key_q0),  // output wire [7 : 0] douta
//  .clkb(clk),    // input wire clkb
//  .enb(key_ce1),      // input wire enb
//  .addrb(key_address1),  // input wire [3 : 0] addrb
//  .doutb(key_q1)  // output wire [7 : 0] doutb
//);

// Capture and store cipher text in the array
always @(posedge clk or posedge reset) begin
    if (reset) begin
        cipher_text_index <= 0;
        toggle <= 0;
        cipher_text_store_complete <= 0; // Reset completion flag on reset
    end else if (ap_ready && !cipher_text_store_complete) begin  // Only capture when data is ready and storage isn't complete
        if (toggle) begin
            // Store cipher_text_d0 at current index
            cipher_text_array[cipher_text_index] <= cipher_text_d0;
        end else begin
            // Store cipher_text_d1 at current index
            cipher_text_array[cipher_text_index] <= cipher_text_d1;
        end
        toggle <= ~toggle; // Toggle between d0 and d1 for next cycle

        // Increment index every two captures (one d0 and one d1)
        if (toggle == 1) begin
            cipher_text_index <= cipher_text_index + 1;
        end

        // Set completion flag when last position is reached
        if (cipher_text_index == CIPHER_TEXT_SIZE - 1 && toggle == 1) begin
            cipher_text_store_complete <= 1;
        end
    end
end

ila_1 ila (
	.clk(clk), // input wire clk


	.probe0(plain_text_address0), // input wire [6:0]  probe0  
	.probe1(plain_text_q0), // input wire [0:0]  probe1 
	.probe2(plain_text_address1), // input wire [6:0]  probe2 
	.probe3(plain_textq1), // input wire [0:0]  probe3 
	.probe4(cipher_text_address0), // input wire [6:0]  probe4 
	.probe5(cipher_text_d0), // input wire [0:0]  probe5 
	.probe6(cipher_text_address1), // input wire [6:0]  probe6 
	.probe7(cipher_text_d1) // input wire [0:0]  probe7 
//	.probe8(data_array[1]), // input wire [7:0]  probe8 
//	.probe9(data_array[2]), // input wire [7:0]  probe9 
//	.probe10(data_array[3]), // input wire [7:0]  probe10 
//	.probe11(data_array[4]), // input wire [7:0]  probe11 
//	.probe12(data_array[5]), // input wire [7:0]  probe12 
//	.probe13(data_array[6]), // input wire [7:0]  probe13 
//	.probe14(data_array[7]), // input wire [7:0]  probe14 
//	.probe15(data_array[8]) // input wire [7:0]  probe15
);

//always @(posedge clk) begin
//    plain_text_q0 = 1'b1;
//    plain_text_q1 = 1'b0;
//    key_q0 = 8'b10010001;
//    key_q1 = 8'b00011110;
//end


endmodule
