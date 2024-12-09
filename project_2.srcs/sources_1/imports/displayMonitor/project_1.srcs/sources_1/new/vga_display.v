module vga_display(
    output [11:0] color, 
    output Hsync, Vsync,
    input clk,          // Clock input
    input [7:0] char_in, // Data input for updating buffer
    input write_enable
);
    // VGA signal wires
    wire [9:0] x, y; // Current pixel coordinates
    wire videoOn;    // Signal indicating whether the pixel is in the visible region
    
    // VGA synchronization module
    vga_sync vga_sync_unit (
        .clk(clk), 
        .hsync(Hsync), 
        .vsync(Vsync),
        .video_on(videoOn), 
        .p_tick(), 
        .x(x), 
        .y(y)
    );
    
    reg [7:0] buffer [0:39];
    integer i;
    initial begin
     
        for (i = 0; i < 40; i = i + 1) begin
            buffer[i] = 8'b0; // Set each element to 0
        end
    end
    reg state=0;
    reg [25:0] count;
    reg [5:0] index=0; 
    always @(negedge write_enable) begin
            if(char_in==8'h7F)begin //delete
                buffer[index-1] <=8'b0;
                if (index>0) index <=index-1;
            end
            else if (char_in == 8'h0D || char_in == 8'h0A)begin //enter
                index <= ((index + 8) / 8) * 8;
                if(index>39) index <=39;
            end
            else begin
                if(index<=39)begin
                    buffer[index] <=char_in;
                    if(index<=39) index <= index+1; 
                end
                else begin
                // Shift buffer data down by 8
                buffer[0] <= buffer[8];
                buffer[1] <= buffer[9];
                buffer[2] <= buffer[10];
                buffer[3] <= buffer[11];
                buffer[4] <= buffer[12];
                buffer[5] <= buffer[13];
                buffer[6] <= buffer[14];
                buffer[7] <= buffer[15];
                buffer[8] <= buffer[16];
                buffer[9] <= buffer[17];
                buffer[10] <= buffer[18];
                buffer[11] <= buffer[19];
                buffer[12] <= buffer[20];
                buffer[13] <= buffer[21];
                buffer[14] <= buffer[22];
                buffer[15] <= buffer[23];
                buffer[16] <= buffer[24];
                buffer[17] <= buffer[25];
                buffer[18] <= buffer[26];
                buffer[19] <= buffer[27];
                buffer[20] <= buffer[28];
                buffer[21] <= buffer[29];
                buffer[22] <= buffer[30];
                buffer[23] <= buffer[31];
                buffer[24] <= buffer[32];
                buffer[25] <= buffer[33];
                buffer[26] <= buffer[34];
                buffer[27] <= buffer[35];
                buffer[28] <= buffer[36];
                buffer[29] <= buffer[37];
                buffer[30] <= buffer[38];
                buffer[31] <= buffer[39];

                // Clear buffer[32] to buffer[39]
                buffer[32] <= 8'b0;
                buffer[33] <= 8'b0;
                buffer[34] <= 8'b0;
                buffer[35] <= 8'b0;
                buffer[36] <= 8'b0;
                buffer[37] <= 8'b0;
                buffer[38] <= 8'b0;
                buffer[39] <= 8'b0;

                // Set the new character at index 31 (last position before clearing)
                buffer[32] <= char_in;

                // Adjust index to point to the next available position (31)
                index <= 33;
            end
            
        end
        $display("buffer[%0d] = %0d", index, buffer[index]); 
    end
    

    
    reg [63:0] char_0;
    reg [63:0] char_1;
    reg [63:0] char_2;
    reg [63:0] char_3;
    reg [63:0] char_4;
    
    always @(posedge clk) begin
        char_0 = {buffer[7], buffer[6], buffer[5], buffer[4], buffer[3], buffer[2], buffer[1], buffer[0]};
        char_1 = {buffer[15], buffer[14], buffer[13], buffer[12], buffer[11], buffer[10], buffer[9], buffer[8]};
        char_2 = {buffer[23], buffer[22], buffer[21], buffer[20], buffer[19], buffer[18], buffer[17], buffer[16]};
        char_3 = {buffer[31], buffer[30], buffer[29], buffer[28], buffer[27], buffer[26], buffer[25], buffer[24]};
        char_4 = {buffer[39], buffer[38], buffer[37], buffer[36], buffer[35], buffer[34], buffer[33], buffer[32]};
    end

    // Color wire for the current pixel
    wire [11:0] ramColor;

    // Character RGB RAM module for displaying the ASCII character
    RgbRam ram (
        .color(ramColor),   // Output color for the current pixel
        .x(x),              // Current pixel x-coordinate
        .y(y),              // Current pixel y-coordinate
        .character(char_0),
        .character_2(char_1),
        .character_3(char_2),
        .character_4(char_3),
        .character_5(char_4), // ASCII value of the character to display
        .START_CHAR_X(60),
        .START_CHAR_Y(30)
    );

    // Output the color only when videoOn is active
    assign color = videoOn ? ramColor : 12'b000000000000;

endmodule