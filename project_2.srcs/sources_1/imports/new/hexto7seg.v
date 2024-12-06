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


module hexto7seg(
output [6:0] segments,
input[3:0] hex
    );
    
    reg[6:0] segments;
    // 0
    //5  1
    // 6
   //4  2 
    //3
    always@(hex)
      case(hex)
       4'b0001: segments=7'b1111001;
       4'b0010: segments=7'b0100100;
       4'b0011: segments=7'b0110000;
       4'b0100: segments=7'b0011001;
       4'b0101: segments=7'b0001011;
       4'b0110: segments=7'b0000010;
       4'b0111: segments=7'b1111000;
       4'b1000 : segments = 7'b0000000;   // 8
       4'b1001 : segments = 7'b0010000;   // 9
       4'b1010 : segments = 7'b0001000;   // A
       4'b1011 : segments = 7'b0000011;   // b
       4'b1100 : segments = 7'b1000110;   // C
       4'b1101 : segments = 7'b0100001;   // d
       4'b1110 : segments = 7'b0000110;   // E
       4'b1111 : segments = 7'b0001110;   // F
       default : segments = 7'b1000000;   // 0
     
       endcase
endmodule