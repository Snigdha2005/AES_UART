`timescale 1ns / 1ps

module top_controller(
    input   i_clk_100M,
            i_uart_rx,
    
    output  [7:0] cathodes,
            [3:0] anodes
);

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
    
    wire [N_DATA_BITS-1:0] uart_rx_data;
    wire uart_rx_data_valid;
    
    reg [N_DATA_BITS-1:0] uart_rx_data_buf;
    reg uart_rx_data_valid_buf;
    
    // Variables for the seven segment display
    reg display_clk;
    reg display_data_update;
    reg [N_DATA_BITS-1:0] display_data;
    
    vio_0 reset_source (
      .clk(i_clk_100M),
      .probe_out0(reset)  // output wire [0 : 0] probe_out0
    );
    
    ila_0 input_monitor (
        .clk(uart_clk), // input wire clk
    
    
        .probe0(uart_rx_data_valid), // input wire [0:0]  probe0  
        .probe1(uart_rx_data), // input wire [7:0]  probe1 
        .probe2(i_uart_rx) // input wire [7:0]  probe2
    );
    
    uart_rx #(
        .OVERSAMPLE(OVERSAMPLE),
        .N_DATA_BITS(N_DATA_BITS),
        .MAJORITY_START_IDX(MAJORITY_START_IDX),
        .MAJORITY_END_IDX(MAJORITY_END_IDX)
    ) rx_data (
        .i_clk(uart_clk),
        .i_en(uart_en),//synchronise the clock
        .i_reset(reset),
        .i_data(i_uart_rx),
        
        .o_data(uart_rx_data),
        .o_data_valid(uart_rx_data_valid)
    );
    
    seven_seg_drive #(
        .INPUT_WIDTH(N_DATA_BITS),
        .SEV_SEG_PRESCALAR(16)
    ) display (
        .i_clk(uart_clk),
        .number(display_data),
        .decimal_points(4'h0),
        .anodes(anodes),
        .cathodes(cathodes)
    );
    
    clk_wiz_0 clock_gen (
        // Clock out ports
        .clk_out1(uart_clk),     
//        .clk_out2(display_clk),     
       // Clock in ports
        .clk_in1(i_clk_100M)
    );
    
    always @(posedge uart_clk) begin
        if(uart_divider_counter < (UART_CLOCK_DIVIDER-1))
            uart_divider_counter <= uart_divider_counter + 1;
       else
            uart_divider_counter <= 'd0;
    end
    
    always @(posedge uart_clk) begin
        uart_en <= (uart_divider_counter == 'd10); 
    end
    
    always @(posedge uart_clk)
        if(uart_rx_data_valid)
            display_data <= uart_rx_data;
    
endmodule
