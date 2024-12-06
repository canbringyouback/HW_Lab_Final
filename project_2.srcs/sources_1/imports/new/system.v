module system(
    output [3:0] vgaRed, vgaGreen, vgaBlue,
    output Hsync, Vsync,
    input clk
);
    // Declare an input signal to write to the buffer
    reg [7:0] data_in;         // Single character data input
    reg write_enable;          // Signal to enable buffer updates

    // Instantiate the VGA display module
    vga_display display(
        .color({vgaRed, vgaGreen, vgaBlue}),
        .Hsync(Hsync),
        .Vsync(Vsync),
        .clk(clk),
        .char_in(data_in),     // Character to write to the buffer
        .write_enable(write_enable) // Enable signal for buffer updates
    );

endmodule
