`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent Inc 
// Engineer: Arthur Brown
// 
// Create Date: 07/27/2016 02:04:01 PM
// Design Name: Basys3 Keyboard Demo
// Module Name: top
// Project Name: Keyboard
// Target Devices: Basys3
// Tool Versions: 2016.X
// Description: 
//     Receives input from USB-HID in the form of a PS/2, displays keyboard key presses and releases over USB-UART.
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//     Known issue, when multiple buttons are pressed and one is released, the scan code of the one still held down is ometimes re-sent.
//////////////////////////////////////////////////////////////////////////////////


module top(
  input         clk,       // System clock (e.g., 100MHz)
    input         PS2Data,   // PS2 keyboard data line
    input         PS2Clk,    // PS2 keyboard clock line
    input         RsRx,      // UART receive line
    input         RsRx2,     // UART receive line for second channel
    output        tx,        // UART transmit line
    output        tx2   
);
    wire        tready;
    wire        ready;
    wire        tstart;
    reg         start=0;
    reg         CLK50MHZ=0;
    wire [31:0] tbuf;
    reg  [15:0] keycodev=0;
    wire [15:0] keycode;
    wire [ 7:0] tbus;
    reg  [ 2:0] bcount=0;
    wire        flag;
    reg         cn=0;
    
    always @(posedge(clk))begin
        CLK50MHZ<=~CLK50MHZ;
    end
    
    PS2Receiver uut (
        .clk(CLK50MHZ),
        .kclk(PS2Clk),
        .kdata(PS2Data),
        .keycode(keycode),
        .oflag(flag)
    );
    
    
    always@(keycode)
        if (keycode[7:0] == 8'hf0) begin
            cn <= 1'b0;
            bcount <= 3'd0;
        end else if (keycode[15:8] == 8'hf0) begin
            cn <= 1'b0;
            bcount <= 3'd5;
        end else begin
            cn <= keycode[7:0] != keycodev[7:0] || keycodev[15:8] == 8'hf0||keycode[15:8] != 8'hf0;
            bcount <= 3'd2;
        end
    
    always@(posedge clk)
        if (flag == 1'b1 && cn == 1'b1) begin
            start <= 1'b1;
            keycodev <= keycode;
        end else
            start <= 1'b0;
            
    bin2ascii #(
        .NBYTES(2)
    ) conv (
        .I(keycodev),
        .O(tbuf)
    );
    
    uart_buf_con tx_con (
        .clk    (clk   ),
        .bcount (5),
        .tbuf   (tbuf  ),  
        .start  (start ), 
        .ready  (ready ), 
        .tstart (tstart),
        .tready (tready),
        .tbus   (tbus  )
    );
    
    uart_tx get_tx (
        .clk    (clk),
        .start  (tstart),
        .tbus   (tbus),
        .tx     (tx2),
        .ready  (tready)
    );
  
    
     
        uart_translate echo_module2 (
        .clk(clk),
        .RsRx(RsRx2), 
        .tx(tx)           // Echoed data transmitted here
    );
endmodule