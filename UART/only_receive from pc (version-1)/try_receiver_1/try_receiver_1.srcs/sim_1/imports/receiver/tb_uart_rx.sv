`timescale 1ns / 1ps

module tb_uart_rx;
    localparam  CLOCK_PERIOD = 1000;
    localparam  OVERSAMPLE = 11,
                N_DATA_BITS = 8;
                
    reg clk;
    reg en, reset, data_in;
    
    wire [N_DATA_BITS-1:0] data_out;
    wire data_valid;
    
    reg data_seq_1[N_DATA_BITS-1:0];
    reg data_seq_2[N_DATA_BITS-1:0];

    integer i;
    
    uart_rx #(
        .OVERSAMPLE(OVERSAMPLE),
        .N_DATA_BITS(N_DATA_BITS)
    ) DUT (
        .i_clk(clk),
        .i_en(en),
        .i_reset(reset),
        .i_data(data_in),
        
        .o_data(data_out),
        .o_data_valid(data_valid)
    );
    
    initial begin
        clk = 0;
        reset = 1;
        en = 1;
        data_in = 1;
        
        data_seq_1 = {1, 0, 1, 0, 1, 1, 0, 1};
        data_seq_2 = {0, 0, 0, 1, 0, 1, 0, 1};
        
        #(10*CLOCK_PERIOD) reset = 0;
        
        #(OVERSAMPLE*CLOCK_PERIOD) data_in = 0;
        for(i = 0; i < N_DATA_BITS; i++)
            #(OVERSAMPLE*CLOCK_PERIOD) data_in = data_seq_1[i];
        
        #(2*OVERSAMPLE*CLOCK_PERIOD) data_in = 1;
        #(OVERSAMPLE*CLOCK_PERIOD) data_in = 0;
        for(i = 0; i < N_DATA_BITS; i++)
            #(OVERSAMPLE*CLOCK_PERIOD) data_in = data_seq_2[i];
                
        #(2*OVERSAMPLE*CLOCK_PERIOD) data_in = 1;
        #(20*CLOCK_PERIOD) $finish;
    end
    
    always #(CLOCK_PERIOD/2) clk <= ~clk;
endmodule
