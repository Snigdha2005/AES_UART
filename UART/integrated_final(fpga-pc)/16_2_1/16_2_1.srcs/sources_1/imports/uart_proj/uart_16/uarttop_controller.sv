//`timescale 1ns / 1ps

//module top_controller #(N_DATA_BITS = 8)(
//    input   i_clk_100M,
//            i_data_valid,
//            input [N_DATA_BITS-1:0] i_uart_tx_data,
//            input t1,  // New input signal t1 for toggling
//    output   o_uart_tx,
//             uart_tx_ready
//);

//    localparam OVERSAMPLE = 13;
                
//    localparam integer UART_CLOCK_DIVIDER = 64;
//    localparam integer MAJORITY_START_IDX = 4;
//    localparam integer MAJORITY_END_IDX = 8;
//    localparam integer UART_CLOCK_DIVIDER_WIDTH = $clog2(UART_CLOCK_DIVIDER);
    
//    wire reset;
    
//    reg uart_clk_rx;
//    reg uart_en_rx;
//    reg [UART_CLOCK_DIVIDER_WIDTH:0] uart_divider_counter_rx;

//    reg uart_clk_tx;
//    reg uart_en_tx;
//    reg [UART_CLOCK_DIVIDER_WIDTH:0] uart_divider_counter_tx;
    
//    // Array to store two sets of 8-bit data
//    reg [N_DATA_BITS-1:0] data_array[1:0];
//    reg [1:0] index = 0;  // Keeps track of the current index
//    reg t1_prev = 0;      // Previous state of t1 for edge detection
//    reg data_ready = 0;
    
//    // Instantiate reset VIO and ILA for debugging signals
//    vio_0 reset_source (
//        .clk(i_clk_100M),
//        .probe_out0(reset)  // output wire [0 : 0] probe_out0
//    );
   
//    ila_0 ila_signal (
//        .clk(uart_clk_rx),       // input wire clk
//        .probe0(i_data_valid),   // input wire [0:0]  probe0  
//        .probe1(i_uart_tx_data), // input wire [7:0]  probe1 
//        .probe2(uart_tx_ready),  // input wire [0:0]  probe2 
//        .probe3(o_uart_tx),      // input wire [0:0]  probe3
//        .probe4(uart_en_tx),     // input wire [0:0]  probe4
//        .probe5(data_array[0]),  // input wire [7:0] data at index 0
//        .probe6(data_array[1])   // input wire [7:0] data at index 1
//    );
    
//    clk_wiz_0 instance_name(
//        // Clock out ports
//        .clk_out1(uart_clk_rx),     // output clk_out1
//        .clk_out2(uart_clk_tx),     // output clk_out2
//        // Clock in ports
//        .clk_in1(i_clk_100M)
//    );

//    uart_tx #(.N_DATA_BITS(N_DATA_BITS)) uart_transmitter (
//        .i_uart_clk(uart_clk_tx),
//        .i_uart_en(uart_en_tx),
//        .i_uart_reset(reset),
//        .i_uart_data_valid(data_ready),
//        .i_uart_data(data_array[0]), // Modify if needed to send other data
//        .o_uart_ready(uart_tx_ready),
//        .o_uart_tx(o_uart_tx)
//    );
    
//    // Logic to store data based on t1 toggle
//    always @(posedge i_clk_100M) begin
//        if (i_data_valid) begin
//            // Check for a rising edge on t1 to toggle index
//            if (t1 && !t1_prev) begin
//                data_array[index] <= i_uart_tx_data;  // Store data in the current index
//                index <= index + 1;                    // Move to the next index
//                data_ready <= (index == 1);            // Set data_ready when both entries are stored
//            end
//        end else begin
//            data_ready <= 0;       // Reset data_ready when data is invalid
//        end
//        t1_prev <= t1;  // Update previous t1 state
//    end

//    // Clock Divider for UART Transmission
//    always @(posedge uart_clk_tx) begin
//        if(uart_divider_counter_tx < (UART_CLOCK_DIVIDER-1))
//            uart_divider_counter_tx <= uart_divider_counter_tx + 1;
//        else
//            uart_divider_counter_tx <= 'd0;
//    end
    
//    // Enable UART Transmission based on Divider
//    always @(posedge uart_clk_tx) begin
//        uart_en_tx <= (uart_divider_counter_tx == 'd10); 
//    end

//endmodule

`timescale 1ns / 1ps

module top_controller #(N_DATA_BITS = 8)(
    input   i_clk_100M,
            i_data_valid,
            t1,
            [N_DATA_BITS-1:0] i_uart_tx_data,
              // Toggle signal for data storage
    output   o_uart_tx,
             uart_tx_ready
);

    localparam OVERSAMPLE = 13;
                
    localparam integer UART_CLOCK_DIVIDER = 64;
    localparam integer MAJORITY_START_IDX = 4;
    localparam integer MAJORITY_END_IDX = 8;
    localparam integer UART_CLOCK_DIVIDER_WIDTH = $clog2(UART_CLOCK_DIVIDER);
    
    wire reset;
    
    reg uart_clk_rx;
    reg uart_en_rx;
    reg [UART_CLOCK_DIVIDER_WIDTH:0] uart_divider_counter_rx;

    reg uart_clk_tx;
    reg uart_en_tx;
    reg [UART_CLOCK_DIVIDER_WIDTH:0] uart_divider_counter_tx;
    
    // Array to store sixteen sets of 8-bit data
    reg [N_DATA_BITS-1:0] data_array[15:0];
    reg [3:0] state = 0;  // State machine to handle 16 sequential storage locations
    reg data_ready = 0;
    reg prev_t1 = 0;      // Previous state of t1 to detect toggling
    
    // Variables for the seven-segment display

    vio_0 reset_source (
      .clk(i_clk_100M),
      .probe_out0(reset)  // output wire [0 : 0] probe_out0
    );
   
    ila_0 ila_signal (
       .clk(uart_clk_rx), // input wire clk
       .probe0(data_array[0]), // input wire [0:0]  probe0  
       .probe1(data_array[1]), // input wire [7:0]  probe1 
       .probe2(data_array[2]), // input wire [0:0]  probe2 
       .probe3(data_array[3]), // input wire [0:0]  probe3
       .probe4(data_array[4])
    );
    
    clk_wiz_0 instance_name(
        // Clock out ports
        .clk_out1(uart_clk_rx),     // output clk_out1
        .clk_out2(uart_clk_tx),     // output clk_out2
        // Clock in ports
        .clk_in1(i_clk_100M)
    );

    uart_tx #(.N_DATA_BITS(N_DATA_BITS)) uart_transmitter (
        .i_uart_clk(uart_clk_tx),
        .i_uart_en(uart_en_tx),
        .i_uart_reset(reset),
        .i_uart_data_valid(data_ready),
        .i_uart_data(data_array[0]), // Send data_array[0] (or modify if sending encrypted data)
        .o_uart_ready(uart_tx_ready),
        .o_uart_tx(o_uart_tx)
    );
    
    always @(posedge i_clk_100M) begin
        if (i_data_valid && (t1 != prev_t1)) begin  // Store data only on t1 toggle
            data_array[state] <= i_uart_tx_data;  // Store data in the current index
            if (state < 15)
                state <= state + 1;               // Move to the next index
            else begin
                data_ready <= 1;                  // Set data_ready once all 128 bits are stored
                state <= 0;                       // Reset state for the next sequence
            end
        end else if (!i_data_valid) begin
            data_ready <= 0;                      // Reset data_ready when i_data_valid is low
        end
        prev_t1 <= t1;  // Update previous t1 state to detect toggling
    end

    always @(posedge uart_clk_tx) begin
        if(uart_divider_counter_tx < (UART_CLOCK_DIVIDER-1))
            uart_divider_counter_tx <= uart_divider_counter_tx + 1;
        else
            uart_divider_counter_tx <= 'd0;
    end
    
    always @(posedge uart_clk_tx) begin
        uart_en_tx <= (uart_divider_counter_tx == 'd10); 
    end

endmodule
