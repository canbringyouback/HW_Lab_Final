module PS2Receiver(
    input clk,                 // Main system clock
    input kclk,                // Raw PS2 clock input
    input kdata,               // Raw PS2 data input
    output reg [15:0] keycode = 0,  // Combined keycode output
    output reg oflag = 0       // Output flag indicating new keycode
);
    // Debounced signals
    wire kclkf, kdataf;

    // Internal registers
    reg [7:0] datacur = 0;     // Current 8-bit data byte
    reg [7:0] dataprev = 0;    // Previous 8-bit data byte
    reg [15:0] last_keycode = 0; // Last processed keycode to avoid duplicates
    reg [3:0] cnt = 0;         // Counter for tracking bits
    reg flag = 0;              // Flag to indicate data completion

    // Debouncer for kclk
    debouncer #(
        .COUNT_MAX(99),        // Increased debounce count for better stability
        .COUNT_WIDTH(7)        // Adjust width for COUNT_MAX=99
    ) db_clk (
        .clk(clk),             // System clock
        .I(kclk),              // Raw kclk input
        .O(kclkf)              // Debounced clock output
    );

    // Debouncer for kdata
    debouncer #(
        .COUNT_MAX(99),        // Increased debounce count for better stability
        .COUNT_WIDTH(7)        // Adjust width for COUNT_MAX=99
    ) db_data (
        .clk(clk),             // System clock
        .I(kdata),             // Raw kdata input
        .O(kdataf)             // Debounced data output
    );

    // Shift in data on the falling edge of kclkf
    always @(negedge kclkf) begin
        case (cnt)
            0: ; // Start bit - do nothing
            1: datacur[0] <= kdataf;
            2: datacur[1] <= kdataf;
            3: datacur[2] <= kdataf;
            4: datacur[3] <= kdataf;
            5: datacur[4] <= kdataf;
            6: datacur[5] <= kdataf;
            7: datacur[6] <= kdataf;
            8: datacur[7] <= kdataf;
            9: flag <= 1'b1;  // Signal that the byte is complete
            10: flag <= 1'b0; // Reset flag
        endcase

        if (cnt <= 9)
            cnt <= cnt + 1'b1;  // Increment bit counter
        else
            cnt <= 0;           // Reset counter after stop bit
    end

    reg pflag = 0;  // Previous flag state
   always @(posedge clk) begin
    if (flag == 1'b1 && pflag == 1'b0) begin
        if (dataprev == 0 && keycode == 0) begin
            // Initialize dataprev correctly for the first key press
            dataprev <= datacur;
            keycode <= {8'b0, datacur}; // Use only datacur for the first press
        end else begin
            keycode <= {dataprev, datacur};  // Combine dataprev and datacur
            dataprev <= datacur;            // Update dataprev
        end

        // Check for duplicates
        
            oflag <= 1'b1;                  // Set output flag
            last_keycode <= keycode;        // Update last processed keycode
        
    end else begin
        oflag <= 1'b0;                      // Clear output flag
    end
    pflag <= flag;                          // Update previous flag state
end

endmodule
