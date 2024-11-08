`timescale 1ns / 1ps

module uart_tx #(
    N_DATA_BITS = 8
)(
    input i_uart_clk,
          i_uart_en,
          i_uart_reset,
          i_uart_data_valid,
          [N_DATA_BITS-1:0] i_uart_data,
    output o_uart_ready,
           o_uart_tx
);
    
    localparam integer FRAME_IDX_WIDTH = $clog2(N_DATA_BITS);
    reg o_uart_ready_reg = 1;
    reg [N_DATA_BITS:0] data_buf;
    reg frame_start = 0;
    reg o_uart_tx_reg = 1;
    
    assign o_uart_ready = o_uart_ready_reg;
    assign o_uart_tx = o_uart_tx_reg;
    
    
    integer frame_idx = 0;
    
    always @(posedge i_uart_clk) begin
    if(i_uart_en) begin
        if(i_uart_reset) begin
            frame_start <= 1;
            o_uart_ready_reg <= 1;
        end
        else if(i_uart_data_valid && o_uart_ready_reg && !frame_start) begin
            o_uart_ready_reg <= 0;
            data_buf <= {i_uart_data, 1'b0};  // here 0 is padded to start the frame with start bit
            frame_start <= 1;
        end
        else if(frame_idx == N_DATA_BITS + 1) begin
            frame_start <= 0;
            o_uart_ready_reg <= 1;
        end
    end
end
 
    always @(posedge i_uart_clk) begin
    if(i_uart_en) begin
        if(i_uart_reset) begin
            o_uart_tx_reg <= 1;
            frame_idx <= 0;
        end
        else if(frame_start) begin
            if(frame_idx < N_DATA_BITS + 1) begin
                o_uart_tx_reg <= data_buf[frame_idx];
                frame_idx <= frame_idx + 1;
            end
            else begin
                o_uart_tx_reg <= 1;
                frame_idx <= 0;
            end
        end
    end
end

endmodule