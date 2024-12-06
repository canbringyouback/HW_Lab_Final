`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/26/2024 05:43:11 PM
// Design Name: 
// Module Name: hexto7seg
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


module clockDiv(
 output clkdiv,
 input clk
    );
    reg clkdiv;
    
    initial begin;
    clkdiv=0;
    end
    
    always@(posedge clk) begin
    clkdiv=~clkdiv;
    end
endmodule
