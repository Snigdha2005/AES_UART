`timescale 1ns / 1ps

module uart_tx_controller #(
    parameter N_DATA_BITS = 8  // Number of bits per UART transmission
)(
    input i_uart_clk,          // UART clock input
    input i_uart_en,           // Enable signal for UART transmission
    input i_uart_reset,        // Reset signal
    input i_data_ready,        // Signal indicating data is ready for transmission
    input [N_DATA_BITS*16-1:0] i_data_array, // 128-bit data array input (16 chunks of 8 bits each)
    input i_data_valid,        // Toggle input to start transmission process
    input u1,                  // Toggle input to switch chunks
    output reg o_uart_ready,   // UART ready signal
    output o_uart_tx           // UART transmission output
);

    // Internal signals and registers
    reg [N_DATA_BITS-1:0] data_chunk;  // Current 8-bit data chunk to transmit
    reg [3:0] chunk_select = 0;        // 4-bit index for selecting 1 of 16 chunks
    reg data_valid = 0;                // Data valid signal for uart_tx
    reg u1_prev = 0;                   // Register to store previous state of u1
    reg transmission_done = 0;         // Flag to indicate if the current chunk was transmitted
    wire uart_tx_ready;                // Ready signal from uart_tx module

    // Instantiating uart_tx for transmission
    uart_tx #(.N_DATA_BITS(N_DATA_BITS)) uart_transmitter (
        .i_uart_clk(i_uart_clk),
        .i_uart_en(i_uart_en),
        .i_uart_reset(i_uart_reset),
        .i_uart_data_valid(data_valid),
        .i_uart_data(data_chunk),
        .o_uart_ready(uart_tx_ready),
        .o_uart_tx(o_uart_tx)
    );

    // Logic to send data in chunks of 8 bits
    always @(posedge i_uart_clk or posedge i_uart_reset) begin
        if (i_uart_reset) begin
            chunk_select <= 0;
            data_valid <= 0;
            o_uart_ready <= 1;
            u1_prev <= 0;
            transmission_done <= 0;
        end else if (i_uart_en && i_data_ready && i_data_valid) begin
            // Check if UART transmitter is ready and the chunk has not been sent yet
            if (uart_tx_ready && !transmission_done) begin
                data_chunk <= i_data_array[chunk_select * N_DATA_BITS +: N_DATA_BITS];
                data_valid <= 1;  // Set data valid to start transmission
                o_uart_ready <= 0;  // UART is busy
                transmission_done <= 1;  // Mark current chunk as sent
            end else begin
                data_valid <= 0;
            end

            // Update chunk select when u1 is toggled
            if (u1 && !u1_prev) begin
                chunk_select <= (chunk_select < 15) ? chunk_select + 1 : 0;
                transmission_done <= 0;  // Reset transmission flag for the new chunk
            end
            u1_prev <= u1;  // Update previous state of u1

            // If all chunks are sent, mark UART ready
            if (uart_tx_ready && chunk_select == 15 && transmission_done) begin
                o_uart_ready <= 1;  // UART ready for new data
            end
        end else begin
            o_uart_ready <= 1;
        end
    end
endmodule