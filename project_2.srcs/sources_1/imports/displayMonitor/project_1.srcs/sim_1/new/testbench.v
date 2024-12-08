`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.12.2024 20:23:11
// Design Name: 
// Module Name: testbench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module testbench;
    // Testbench signals
    reg [9:0] x, y;
    reg [7:0] character;
    wire [11:0] color;
    
    // Instance of the module to test
    RgbRam uut (
        .color(color),
        .x(x),
        .y(y),
        .character(character)
    );
    
    // Generate the test cases
    initial begin
        // Test: Display character 'A' (ASCII 65)
        character = 0;  // ASCII value for 'A'
        
        // Test case 1: x=2, y=3 (position inside 'A')
        x = 2;
        y = 3;
        #10;  // Wait for a short time
        $display("Test case 1: character = %d, x = %d, y = %d, color = %h", character, x, y, color);
        
        // Test case 2: x=0, y=0 (top-left of 'A')
        x = 0;
        y = 0;
        #10;
        $display("Test case 2: character = %d, x = %d, y = %d, color = %h", character, x, y, color);
        
        // Test case 3: x=4, y=6 (bottom-right of 'A')
        x = 4;
        y = 6;
        #10;
        $display("Test case 3: character = %d, x = %d, y = %d, color = %h", character, x, y, color);
        
        // Add more test cases as needed to cover other points
        // End of simulation
        $finish;
    end
endmodule

