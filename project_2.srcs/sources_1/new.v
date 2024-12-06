module top (
    input         clk,       // System clock (e.g., 100MHz)
    input         PS2Data,   // PS2 keyboard data line
    input         PS2Clk,    // PS2 keyboard clock line
    input         RsRx,      // UART receive line
    input         RsRx2,     // UART receive line for second channel
    input         btnC,      // Button input for switches
    input  [15:0] sw,        // 16-bit switch input
    output        tx,        // UART transmit line
    output        tx2, 
    output [6:0] seg,
    output dp,
    output [3:0] an,
    output [3:0] vgaRed, vgaGreen, vgaBlue,
    output Hsync, Vsync       // UART transmit line for second channel
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


    wire        ready1, ready2;
    wire        tstart_ps2;
    wire        tstart_sw;
    wire [31:0] tbuf_ps2;
    wire [31:0] tbuf_sw;
    wire [7:0]  tbus;
    wire        tstart1, tstart2;
    wire        tx3;
    wire [7:0] O;
    wire an0,an1,an2,an3;
    assign an={an3,an2,an1,an0};

        wire targetClk;
    wire [18:0] tclk;
    
    assign tclk[0]=clk;
    
    genvar c;
    generate for(c=0;c<18;c=c+1) begin
        clockDiv fDiv(tclk[c+1],tclk[c]);
    end endgenerate
    
    clockDiv fdivTarget(targetClk,tclk[18]);
   
    // PS2 to ASCII instance
    ps2_to_ascii ps2_to_ascii_inst (
        .clk(clk),
        .PS2Clk(PS2Clk),
        .PS2Data(PS2Data),
        .tbuf(tbuf_ps2),
        .start(tstart_ps2)
    );

    // Switch to ASCII instance
    switch_to_ascii switch_to_ascii_inst (
        .clk(clk),
        .BTNC(btnC),
        .sw(sw),
        .start(tstart_sw),
        .tbuf(tbuf_sw)
    );

    // UART transmit controller with dual buffer handling
    uart_buf_con_2 tx_con2 (
        .clk    (clk),
        .bcount (5),
        .tbuf1  (tbuf_ps2),
        .tbuf2  (tbuf_sw),  
        .start1 (tstart_ps2),
        .start2 (tstart_sw),
        .ready  (ready),
        .tstart (tstart), 
        .tready (tready),  // Ready signal for first UART transmitter
        .tbus   (tbus)
    );

    // Logic to separate tstart1 and tstart2 based on sw[15]


    // UART transmitter 1
    uart_tx get_tx (
        .clk    (clk),
        .start  (tstart),  // Active only when sw[15] == 0
        .tbus   (tbus),
        .tx     (tx2),
        .ready  (tready)
    );

    // UART transmitter 2
   

    // Echo UART module for second channel
    uart_translate echo_module2 (
        .clk(clk),
        .RsRx(RsRx2),   // Internal wire tx3 connected as input RsRx 
        .tx(tx),
        .buffer(O)//Echoed data transmitted here
    );
  reg [7:0] write_enable_count=48; // Counter for write_enable assertion

always @(posedge clk) begin
    if (O != data_in) begin
        data_in = O;         // Update data_in with new character
        write_enable = 1'b1; // Enable buffer update for one clock cycle
    end else begin
        write_enable <= 1'b0; // Disable write on subsequent cycles
    end

    // Increment the counter when write_enable is 1
    if (write_enable) begin
        write_enable_count <= write_enable_count + 1;
    end
end


    
    quadSevenSeg q7seg(seg,dp,an0,an1,an2,an3, write_enable_count,sw[7:0],O,data_in,targetClk);
    
    
endmodule
