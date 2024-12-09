module uart_rx(
    input       clk,       // Clock signal
    input       RsRx,      // UART receive line
    output reg [7:0] data, // Received data byte
    output reg  ready      // Indicates data is ready
);
    parameter CD_MAX = 10368; // Clock divider for baud rate (adjust as needed)
    reg [15:0] cd_count = 0;
    reg [3:0] bit_count = 0;
    reg [9:0] shift_reg = 10'b1111111111; // Start + 8 data + Stop
    reg running = 0;

    always @(posedge clk) begin
        if (~running && ~RsRx) begin
            // Start bit detected
            running <= 1;
            cd_count <= 0;
            bit_count <= 0;
        end else if (running) begin
            if (cd_count == CD_MAX) begin
                cd_count <= 0;

                if (bit_count == 4'd9) begin
                    // Stop bit, data reception complete
                    running <= 0;
                    data <= shift_reg[8:1]; // Extract 8-bit data
                    ready <= 1;            // Signal valid data
                end else begin
                    // Shift in the next bit
                    shift_reg <= {RsRx, shift_reg[9:1]};
                    bit_count <= bit_count + 1;
                end
            end else begin
                cd_count <= cd_count + 1;
            end
        end else begin
            ready <= 0; // Reset ready flag
        end
    end
endmodule
