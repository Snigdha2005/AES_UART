`timescale 1ns / 1ps

module top_controller #(
    parameter N_DATA_BITS = 8
)(
    input i_clk_100M,
    input i_uart_rx,
    
    input i_data_valid,
    input [N_DATA_BITS*16-1:0] data_combined,
    output reg [N_DATA_BITS-1:0] data_array [0:15],
    //input t1,             // Toggle input for storing data in array
    input u1,             // Toggle input for sending data chunks
    output o_uart_tx,
    output uart_tx_ready,
    input reset
);
// Parameters for UART configuration
localparam OVERSAMPLE = 13;
localparam integer UART_CLOCK_DIVIDER = 64;
localparam integer MAJORITY_START_IDX = 4;
localparam integer MAJORITY_END_IDX = 8;
localparam integer UART_CLOCK_DIVIDER_WIDTH = $clog2(UART_CLOCK_DIVIDER);

// Internal Signals
//wire reset;
wire uart_clk_rx, uart_clk_tx;
reg uart_en_rx, uart_en_tx;
reg [UART_CLOCK_DIVIDER_WIDTH:0] uart_divider_counter ;
reg [UART_CLOCK_DIVIDER_WIDTH:0] uart_divider_counter_tx ;
wire [N_DATA_BITS-1:0] uart_rx_data;
wire [N_DATA_BITS-1:0] i_uart_tx_data;
wire uart_rx_data_valid;
reg uart_rx_data_valid_buf;
wire [3:0] chunk_select;
//reg [N_DATA_BITS-1:0] data_array [0:15];  // Array to store 16 received data bytes
reg [3:0] data_index = 0;                 // 4-bit index to track array position (0-15)
//wire [N_DATA_BITS*16-1:0] data_combined;  // Flattened 128-bit data for uart_tx_controller
//reg t1_prev = 0;                          // Previous state of t1 for edge detection
reg data_ready = 0;                       // Signals when data is ready for uart_tx_controller

// Combine 8-bit entries into a single 128-bit signal for transmission
//assign data_combined = {data_array[15], data_array[14], data_array[13], data_array[12],
//                        data_array[11], data_array[10], data_array[9], data_array[8],
//                        data_array[7], data_array[6], data_array[5], data_array[4],
//                        data_array[3], data_array[2], data_array[1], data_array[0]};
//////////////////////////////////////////////////////////////////////////////////////////////
// Instantiate VIO for reset
//vio_0 reset_source (
//    .clk(i_clk_100M),
//    .probe_out0(reset)
//);

//ila_1 your_instance_name (
//	.clk(uart_clk_rx), // input wire clk
//    .probe0(data_ready), // input wire [0:0]  probe0  
//	.probe1(u1), // input wire [0:0]  probe1 
//	.probe2(data_array[0]), // input wire [7:0]  probe2 
//	.probe3(data_array[3]), // input wire [7:0]  probe3 
//	.probe4(data_array[7]), // input wire [7:0]  probe4 
//	.probe5(data_array[15]), // input wire [7:0]  probe5 
//	.probe6(data_array[10]), // input wire [7:0]  probe6 
//	.probe7(chunk_select), // input wire [3:0]  probe7 
//	.probe8(data_array[13]), // input wire [7:0]  probe8 
//	.probe9(i_uart_tx_data) // input wire [7:0]  probe9
//);
// Clock wizard for generating UART clocks
//clk_wiz_0 clk_gen (
//    .clk_out1(uart_clk_rx),
//    .clk_out2(uart_clk_tx),
//    .clk_in1(i_clk_100M)
//);
  clk_wiz_0 i
   (
    // Clock out ports
    .clk_out1(uart_clk_tx),     // output clk_out1
    .clk_out2(uart_clk_rx),     // output clk_out2
   // Clock in ports
    .clk_in1(clk_in1)      // input clk_in1
);

/////////////////////////////////////////////////////////////////////////////////
// UART RX module instantiation
uart_rx #(
    .OVERSAMPLE(OVERSAMPLE),
    .N_DATA_BITS(N_DATA_BITS),
    .MAJORITY_START_IDX(MAJORITY_START_IDX),
    .MAJORITY_END_IDX(MAJORITY_END_IDX)
) rx_data (
    .i_clk(uart_clk_rx),
    .i_en(uart_en_rx),
    .i_reset(reset),
    .i_data(i_uart_rx),
    .o_data(uart_rx_data),
    .o_data_valid(uart_rx_data_valid)
);

// UART TX controller instantiation
uart_tx_controller #(
    .N_DATA_BITS(N_DATA_BITS)
) uart_tx_controller_inst (
    .i_uart_clk(uart_clk_tx),
    .i_uart_en(uart_en_tx),
    .i_uart_reset(reset),
    .i_data_ready(data_ready),
    .i_data_array(data_combined),
    .i_data_valid(i_data_valid),
    .u1(u1),
    .o_uart_ready(uart_tx_ready),
    .o_uart_tx(o_uart_tx)
);
///////////////////////////////////////////////////////////////////////////////////////////////////////
                    // Receive data and store in array
  
always @(posedge uart_clk_rx) begin
    if (uart_rx_data_valid && !uart_rx_data_valid_buf) begin  // Rising edge detect for uart_rx_data_valid
        data_array[data_index] <= uart_rx_data;  // Store data only on new valid signal
        if (data_index == 15) begin
            data_ready <= 1;  // Reset index after reaching the end of the array
        end else begin
            data_index <= data_index + 1;  // Increment index to store the next byte
        end
    end
    
    uart_rx_data_valid_buf <= uart_rx_data_valid;  // Buffer for edge detection
end

// Reset data_index and data_ready after full transmission is complete
always @(posedge i_clk_100M) begin
    if (uart_tx_ready && data_ready && chunk_select == 15) begin
        data_ready <= 0;
        data_index <= 0;
    end
end


//4 always blocks

    always @(posedge uart_clk_tx) begin
        if (uart_divider_counter_tx < (UART_CLOCK_DIVIDER - 1))
            uart_divider_counter_tx <= uart_divider_counter_tx + 1;
        else
            uart_divider_counter_tx <= 0;
    end

    // Enable UART Transmission based on Divider
    always @(posedge uart_clk_tx) begin
    if(i_data_valid)
    begin
        uart_en_tx <= (uart_divider_counter_tx == 'd10);
    end
    end

// UART RX clock divider
always @(posedge uart_clk_rx) begin
    if (uart_divider_counter < (UART_CLOCK_DIVIDER - 1))
        uart_divider_counter <= uart_divider_counter + 1;
    else
        uart_divider_counter <= 0;
end

always @(posedge uart_clk_rx) begin
    uart_en_rx <= (uart_divider_counter == 'd10);
end

endmodule