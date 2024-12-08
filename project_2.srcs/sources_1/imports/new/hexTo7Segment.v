`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2021 08:55:14 PM
// Design Name: 
// Module Name: hexTo7Segment
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


module hexTo7Segment(
    output [6:0] segments,
    input [7:0] hex
    );
    
    reg [6:0] segments;
    
// 7-segment encoding
//      0
//     ---
//  5 |   | 1
//     --- <--6
//  4 |   | 2
//     ---
//      3

   always @(hex)
      case (hex)
          8'h41 : segments = 7'b0100000;   // A
          8'h42 : segments = 7'b0000011;   // B
          8'h43  : segments =7'b0100111; // C??????
          8'h44 : segments = 7'b0100001;   // D
          8'h45 : segments = 7'b0000110;   // E
          8'h46 : segments = 7'b0001110;   // F
          8'h47 : segments = 7'b1000010;   // G
          8'h48 : segments = 7'b0001011;   // H
          8'h49 : segments = 7'b1101110;   // I
          8'h4A : segments = 7'b1110010;   // J
          8'h4B : segments = 7'b0001010;   // K
          8'h4C : segments = 7'b1000111;   // L
          8'h4D : segments = 7'b0101010;   // M
          8'h4E : segments = 7'b0101011;   // N
          8'h4F : segments = 7'b0100011;   // O
          8'h40 : segments = 7'b1101000;   // @
          8'h50 : segments = 7'b0001100;   // P
          8'h51 : segments = 7'b0011000;   // Q
          8'h52 : segments = 7'b0101111;   // R
          8'h53  : segments =7'b1010010; //   S
          8'h54 : segments = 7'b0000111;   // T
          8'h55 : segments = 7'b1100011;   // U
          8'h56 : segments = 7'b1010101;   // V
          8'h57 : segments = 7'b0010101;   // W
          8'h58 : segments = 7'b1101011;   // X
          8'h59 : segments = 7'b0010001;   // Y
          8'h5A : segments = 7'b1100100;   // Z
          8'h5C : segments = 7'b0011011;   // \
          8'h5F : segments = 7'b1110111;   // _
          8'h31 : segments = 7'b1111001;  // 1
          8'h32 : segments = 7'b0100100;  // 2
          8'h33  : segments = 7'b0110000; // 3
          8'h34 : segments = 7'b0011001;   // 4
          8'h35 : segments =  7'b0010010;   // 5
          8'h36 : segments = 7'b0000010;   // 6
          8'h37 : segments = 7'b1111000;   // 7
          8'h38 : segments =  7'b0000000;   // 8
          8'h39 : segments = 7'b0010000;   // 9
          8'h3A : segments = 7'b1110110;   // :
          8'h3B : segments = 7'b1110101;   // ;
          8'h3C : segments = 7'b1011110;   // <
          8'h3D : segments = 7'b0110111;   // =
          8'h3E : segments = 7'b1111100;   // >
          8'h3F : segments = 7'b0110100;   // ?
          8'h21 : segments = 7'b0010100;   // !
          8'h22 : segments = 7'b1011101;   // "
          8'h23  : segments =7'b1001001; // #
          8'h25 : segments = 7'b1010111;   // %
          8'h27 : segments = 7'b1011111;   // '
          8'h28 : segments = 7'b1000110;   // (
          8'h29 : segments = 7'b1110000;   // )
          8'h2A : segments = 7'b0110110;   // *
          8'h2B : segments = 7'b0111001;   // +
          8'h2C : segments = 7'b1110011;   // ,
          8'h2D : segments = 7'b0111111;   // -
          8'h2E : segments = 7'b1101111;   // .
          8'h2F : segments = 7'b0101101;  // /
          8'hB0 : segments = 7'b0011100;
          8'h61 : segments = 7'b0100000;   // a (same as A)
8'h62 : segments = 7'b0000011;   // b (same as B)
8'h63 : segments = 7'b1000111;   // c
8'h64 : segments = 7'b0100001;   // d (same as D)
8'h65 : segments = 7'b0000110;   // e (same as E)
8'h66 : segments = 7'b0001110;   // f (same as F)
8'h67 : segments = 7'b1000010;   // g (same as G)
8'h68 : segments = 7'b0001011;   // h (same as H)
8'h69 : segments = 7'b1101110;   // i (same as I)
8'h6A : segments = 7'b1110010;   // j (same as J)
8'h6B : segments = 7'b0001010;   // k (same as K)
8'h6C : segments = 7'b1000111;   // l (same as L)
8'h6D : segments = 7'b0101010;   // m (same as M)
8'h6E : segments = 7'b0101011;   // n (same as N)
8'h6F : segments = 7'b0100011;   // o (same as O)
8'h70 : segments = 7'b0001100;   // p (same as P)
8'h71 : segments = 7'b0011000;   // q (same as Q)
8'h72 : segments = 7'b0101111;   // r (same as R)
8'h73 : segments = 7'b1010010;   // s (same as S)
8'h74 : segments = 7'b0000111;   // t (same as T)
8'h75 : segments = 7'b1100011;   // u (same as U)
8'h76 : segments = 7'b1010101;   // v (same as V)
8'h77 : segments = 7'b0010101;   // w (same as W)
8'h78 : segments = 7'b1101011;   // x (same as X)
8'h79 : segments = 7'b0010001;   // y (same as Y)
8'h7A : segments = 7'b1100100;    //?
          default : segments = 7'b1000000;   // 0
      endcase
				
endmodule