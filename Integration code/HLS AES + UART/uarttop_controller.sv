`timescale 1ns / 1ps

module top_controller1(
    input   i_clk_100M,
            i_uart_rx,
    output reg [7:0] data_array [0:15]
);

// Parameters for UART configuration
localparam  N_DATA_BITS = 8,
            OVERSAMPLE = 13;
                
localparam integer UART_CLOCK_DIVIDER = 64;
localparam integer MAJORITY_START_IDX = 4;
localparam integer MAJORITY_END_IDX = 8;
localparam integer UART_CLOCK_DIVIDER_WIDTH = $clog2(UART_CLOCK_DIVIDER);
    
wire reset;

reg uart_clk;
reg uart_en;
reg [UART_CLOCK_DIVIDER_WIDTH:0] uart_divider_counter;
//reg [7:0] data_array [0:15];
wire [N_DATA_BITS-1:0] uart_rx_data;
wire uart_rx_data_valid;
reg uart_rx_data_valid_buf;

// Define array to store 16 bytes of data
//output [N_DATA_BITS-1:0] data_array [0:15];  // Array to store 16 received data bytes
reg [3:0] data_index = 0;                 // 4-bit index to track array position (0-15)

// Instantiate reset source
vio_0 reset_source (
  .clk(i_clk_100M),
  .probe_out0(reset)  // output wire [0 : 0] probe_out0
);
    
// Instantiate ILA for debugging
ila_0 debug_instance (
    .clk(uart_clk),                // input wire clk
    .probe0(uart_rx_data_valid),   // input wire [0:0]  probe0  
    .probe1(uart_rx_data),         // input wire [7:0]  probe1 
    .probe2(i_uart_rx),            // input wire [0:0]  probe2 
    .probe3(data_array[0]),        // input wire [7:0]  probe3 
    .probe4(data_array[1]),        // input wire [7:0]  probe4 
    .probe5(data_array[2]),        // input wire [7:0]  probe5 
    .probe6(data_array[3]),        // input wire [7:0]  probe6 
    .probe7(data_array[4]), // input wire [7:0]  probe7 
	.probe8(data_array[5]), // input wire [7:0]  probe8 
	.probe9(data_array[6]), // input wire [7:0]  probe9 
	.probe10(data_array[7]), // input wire [7:0]  probe10 
	.probe11(data_array[8]), // input wire [7:0]  probe11 
	.probe12(data_array[9]), // input wire [7:0]  probe12 
	.probe13(data_array[10]), // input wire [7:0]  probe13 
	.probe14(data_array[11]), // input wire [7:0]  probe14 
	.probe15(data_array[12]), // input wire [7:0]  probe15 
	.probe16(data_array[13]), // input wire [7:0]  probe16 
	.probe17(data_array[14]), // input wire [7:0]  probe17 
	.probe18(data_array[15]) // input wire [7:0]  probe18
);                               // input wire [7:0]  probe7 

// Instantiate UART receiver module
uart_rx #(
    .OVERSAMPLE(OVERSAMPLE),
    .N_DATA_BITS(N_DATA_BITS),
    .MAJORITY_START_IDX(MAJORITY_START_IDX),
    .MAJORITY_END_IDX(MAJORITY_END_IDX)
) rx_data (
    .i_clk(uart_clk),
    .i_en(uart_en),
    .i_reset(reset),
    .i_data(i_uart_rx),
    
    .o_data(uart_rx_data),
    .o_data_valid(uart_rx_data_valid)
);
    
// Instantiate clock generator
clk_wiz_0 clock_gen (
    .clk_out1(uart_clk),  // output clk_out1 = 162.209M
    .clk_in1(i_clk_100M)
);
    
// UART clock divider
always @(posedge uart_clk) begin
    if (uart_divider_counter < (UART_CLOCK_DIVIDER - 1))
        uart_divider_counter <= uart_divider_counter + 1;
    else
        uart_divider_counter <= 'd0;
end
    
always @(posedge uart_clk) begin
    uart_en <= (uart_divider_counter == 'd10); 
end

always @(posedge uart_clk) begin
    if (uart_rx_data_valid && !uart_rx_data_valid_buf) begin  // Rising edge detect for uart_rx_data_valid
        data_array[data_index] <= uart_rx_data;  // Store data only on new valid signal
        if (data_index == 15) begin
            data_index <= 0;  // Reset index after reaching the end of the array
        end else begin
            data_index <= data_index + 1;  // Increment index to store the next byte
        end
    end
    
    uart_rx_data_valid_buf <= uart_rx_data_valid;  // Buffer for edge detection
end


endmodule
