`timescale 1ns / 1ps

module vga_sync_tb;

    // Inputs
    reg clk;
    reg reset;

    // Outputs
    wire hsync;
    wire vsync;
    wire video_on;
    wire p_tick;
    wire [9:0] x;
    wire [9:0] y;

    // Instantiate the vga_sync module
    vga_sync uut (
        .clk(clk),
        .reset(reset),
        .hsync(hsync),
        .vsync(vsync),
        .video_on(video_on),
        .p_tick(p_tick),
        .x(x),
        .y(y)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;  // 100 MHz clock (period = 10ns)
    end

    // Initial block for simulation setup
    initial begin
        // Initialize signals
        clk = 0;
        reset = 0;

        // Apply reset for the first few clock cycles
        reset = 1;
        #20 reset = 0;

        // Monitor the output signals
        $monitor("Time: %0t | hsync: %b | vsync: %b | video_on: %b | p_tick: %b | x: %d | y: %d", 
                 $time, hsync, vsync, video_on, p_tick, x, y);

        // Run the simulation for enough time to see the pattern
        #50000;  // 50 ms of simulation time
        $stop;   // Stop the simulation
    end
endmodule
