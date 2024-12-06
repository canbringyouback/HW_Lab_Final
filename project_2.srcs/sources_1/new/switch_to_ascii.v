module switch_to_ascii (
    input         clk,       // System clock
    input         BTNC,      // Button to trigger sending
    input  [15:0] sw,        // 16-bit switch input
    output        start,     // Start signal for UART
    output [31:0] tbuf       // Converted ASCII data
);
    reg  [15:0] sw_reg = 0;    // Register to hold switch value
    reg         btn_last = 0;  // Last state of the button
    reg         start_reg = 0;

    // Latch switch value and detect button press
    always @(posedge clk) begin
        btn_last <= BTNC;
        if (BTNC && !btn_last) begin
            sw_reg <= sw;
            start_reg <= 1'b1;  // Generate start signal when BTNC is pressed
        end else begin
            start_reg <= 1'b0;
        end
    end

    assign start = start_reg;

    // Binary to ASCII conversion
    bin2ascii #(
        .NBYTES(2) // Configured for 16-bit input (2 bytes)
    ) sw_to_ascii (
        .I(sw_reg),  // Pass the 16-bit switch value
        .O(tbuf)
    );
endmodule
