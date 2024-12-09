module top2 (
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
    output Hsync, Vsync, output  led,led2       // UART transmit line for second channel
);
    // Declare an input signal to write to the buffer
    reg [8:0] data_in;         // Single character data input
    reg write_enable;
              // Signal to enable buffer updates
 assign led = sw[8];
    // Instantiate the VGA display module
    vga_display display(
        .color({vgaRed, vgaGreen, vgaBlue}),
        .Hsync(Hsync),
        .Vsync(Vsync),
        .clk(clk),
        .char_in(data_in),     // Character to write to the buffer
        .write_enable(write_enable) // Enable signal for buffer updates
    );


    wire        ready1, ready2,ready3;
    reg         ready4=0;
    wire        tstart_ps2;
    wire        tstart_sw;
    wire [31:0] tbuf_ps2;
    wire [31:0] tbuf_sw;
    wire [7:0]  tbus;
    wire        tstart1, tstart2;
    wire        tx3;
    wire [8:0] O;
    wire an0,an1,an2,an3;
    reg [8:0] O1=0;
    
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
   // switch_to_ascii switch_to_ascii_inst (
     //   .clk(clk),
     //   .BTNC(btnC),
      //  .sw(sw),
      //  .start(tstart_sw),
     //  .tbuf(tbuf_sw)
    //);

    // UART transmit controller with dual buffer handling
   // uart_buf_con_2 tx_con2 (
    //    .clk    (clk),
    //    .bcount (5),
     //   .tbuf1  (tbuf_ps2),
     //   .tbuf2  (tbuf_sw),  
      //  .start1 (tstart_ps2),
      //  .start2 (tstart_sw),
      //  .ready  (ready),
      //  .tstart (tstart), 
      //  .tready (tready),  // Ready signal for first UART transmitter
     //   .tbus   (tbus)
   // );

  
    // Logic to separate tstart1 and tstart2 based on sw[15]


    // UART transmitter 1
   
    // UART transmitter 2
     // Synchronizer
    wire [7:0] d,notd,d2,notd2;
    genvar n;
    generate for(n=0;n<8;n=n+1) begin
        dFlipflop dFF2(d2[n],notd2[n],sw[n],targetClk);
        dFlipflop dFF(d[n],notd[n],d2[n],targetClk);
    end endgenerate
    
    ////////////////////////////////////////
    // Single Pulser
 wire push,pop,reset;
    singlePulser(push, btnC, clk);

    // Echo UART module for second channel
    uart_translate echo_module2 (
        .clk(clk),
        .RsRx(RsRx2),
        .use_external_input(sw[15]),
        .external_key_char(sw[7:0]),
        .uppercase(sw[8]),
        .sw_input(push),   // Internal wire tx3 connected as input RsRx 
        .tx(tx2),
        .internal(sw[14]),
        .external(sw[13]),
        .mirror(sw[12]),
        .tstart(tstart_ps2),
        .internal_buffer(tbuf_ps2[7:0]),
        .buffer(O)
        );
        
always @(posedge clk) begin
    if (O != data_in) begin
        data_in = O;         // Update data_in with new character
        write_enable = 1'b1; // Enable buffer update for one clock cycle
    end else begin
        write_enable <= 1'b0; // Disable write on subsequent cycles
    end  
    end
    
  reg s15, s14, s13, s12;  
    always @(posedge clk) begin
        s15 <= sw[15];  // Capture the value of sw[15]
        s14 <= sw[14];  // Capture the value of sw[14]
        s13 <= sw[13];  // Capture the value of sw[13]
        s12 <= sw[12];  // Capture the value of sw[12]
    end
  wire [7:0] ascii_k = 8'h4B; // ASCII for 'K'
    wire [7:0] ascii_s = 8'h53; // ASCII for 'S'
    wire [7:0] ascii_m = 8'h4D; // ASCII for 'M'
    wire [7:0] ascii_d = 8'h44;
  // Register to store the previous value of tbuf_ps2
  reg [7:0] display_data;  
reg [7:0] display_data2;
always @(posedge clk) begin
    
     if (s14) begin
        display_data2 <= ascii_m; // Display 'M' if sw[14] is high
    end else if (s13) begin
        display_data2 <= ascii_s; // Display 'S' if sw[13] is high
    end else if (s12) begin
        display_data2 <= ascii_d; // Display 'D' if sw[12] is high
    end else begin
        display_data2 <= 8'h20;  // Default to space if no switches are high
    end
end

always @(posedge clk) begin
if (s15) begin
        display_data <= 8'h53; // Display 'K' if sw[15] == 1
    end else begin
    display_data<=ascii_k;
    end
end

          // Ready signal           // Ready signal feedback
quadSevenSeg q7seg(seg,dp,an0,an1,an2,an3, sw[7:0],data_in,display_data,display_data2,targetClk);
endmodule
