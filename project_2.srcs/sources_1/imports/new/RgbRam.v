module RgbRam(output reg [11:0] color, 
              input [9:0] x, y, 
              input [63:0] character,
              input [63:0] character_2,
              input [63:0] character_3,
              input [63:0] character_4,
              input [63:0] character_5,
              input [9:0]START_CHAR_X,
              input [9:0]START_CHAR_Y
              );  // ?????????????? 8 ???

    localparam CHAR_WIDTH = 6;  // ?????????????????
    localparam CHAR_HEIGHT = 7; // ???????????????

//    localparam START_CHAR_X = 27;
    localparam LINE_SPACE = 15;
    
    localparam START_PIC_X = 0; 
    localparam START_PIC_Y = 100; 
    localparam PICS_WIDTH = 160; 
    localparam PICS_HEIGHT = 20; 
    
    localparam START_PIC_X_2 = 130; 
    localparam START_PIC_Y_2 = 9; 
    localparam PICS_WIDTH_2 = 22; 
    localparam PICS_HEIGHT_2 = 22;

    wire [11:0] charRgb[7:0];
    wire [11:0] charRgb2[7:0]; 
    wire [11:0] charRgb3[7:0]; 
    wire [11:0] charRgb4[7:0]; 
    wire [11:0] charRgb5[7:0]; 

    // Instantiate CharRam ??????????????????
    generate 
        for (genvar i = 0; i  <8; i = i + 1) begin
            CharRam charRam_inst_1(
                .color(charRgb[i]),  
                .x(x[9:2] - START_CHAR_X - CHAR_WIDTH * i),  
                .y(y[9:2] - START_CHAR_Y),  
                .charIndex(character[(8*(i+1))-1 -: 8])  
            );   
            CharRam charRam_inst_2(
                .color(charRgb2[i]),  
                .x(x[9:2] - START_CHAR_X - CHAR_WIDTH * i),  
                .y(y[9:2] - (START_CHAR_Y+LINE_SPACE)),  
                .charIndex(character_2[(8*(i+1))-1 -: 8])  
            );   
            CharRam charRam_inst_3(
                .color(charRgb3[i]),  
                .x(x[9:2] - START_CHAR_X - CHAR_WIDTH * i),  
                .y(y[9:2] - (START_CHAR_Y+LINE_SPACE*2)),  
                .charIndex(character_3[(8*(i+1))-1 -: 8])  
            );   
            CharRam charRam_inst_4(
                .color(charRgb4[i]),  
                .x(x[9:2] - START_CHAR_X - CHAR_WIDTH * i),  
                .y(y[9:2] - (START_CHAR_Y+LINE_SPACE*3)),  
                .charIndex(character_4[(8*(i+1))-1 -: 8])  
            );   
            CharRam charRam_inst_5(
                .color(charRgb5[i]),  
                .x(x[9:2] - START_CHAR_X - CHAR_WIDTH * i),  
                .y(y[9:2] - (START_CHAR_Y+LINE_SPACE*4)),  
                .charIndex(character_5[(8*(i+1))-1 -: 8])  
            );   
        end
    endgenerate
    
    wire [11:0] picRgb;
    wire [11:0] picRgb2;
    
    GraphicRam graphRam_inst_1(
        .color(picRgb),  
        .x((x[9:2] >= START_PIC_X && x[9:2] < START_PIC_X + PICS_WIDTH) ? x[9:2] - START_PIC_X : 0),  
        .y((y[9:2] >= START_PIC_Y && y[9:2] < START_PIC_Y + PICS_HEIGHT) ? y[9:2] - START_PIC_Y : 0)
    );
//    GraphicRam2 graphRam_inst_2(
//        .color(picRgb2),  
//        .x((x[9:2] >= START_PIC_X_2 && x[9:2] < START_PIC_X_2 + PICS_WIDTH_2) ? x[9:2] - START_PIC_X_2 : 0),  
//        .y((y[9:2] >= START_PIC_Y_2 && y[9:2] < START_PIC_Y_2 + PICS_HEIGHT_2) ? y[9:2] - START_PIC_Y_2 : 0)
//    ); 
    
    always @(*) begin
        // ????????????????
        color = 12'hbdd;

        if (y[9:2] >= START_CHAR_Y && y[9:2] < START_CHAR_Y + CHAR_HEIGHT) begin
            if (x[9:2] >= START_CHAR_X && x[9:2] < START_CHAR_X + CHAR_WIDTH * 8) begin
               
                for (integer i = 0; i < 8; i = i + 1) begin
                    if (x[9:2] >= START_CHAR_X + i * CHAR_WIDTH && x[9:2] < START_CHAR_X + (i + 1) * CHAR_WIDTH) begin
                        color = charRgb[i];  // ??????????÷??ç??????? x
                    end
                end
            end
        end
        else if (y[9:2] >= START_CHAR_Y+LINE_SPACE && y[9:2] < START_CHAR_Y+LINE_SPACE + CHAR_HEIGHT) begin
            if (x[9:2] >= START_CHAR_X && x[9:2] < START_CHAR_X + CHAR_WIDTH * 8) begin
                // ?????????? x ????????????????????????
                for (integer i = 0; i < 8; i = i + 1) begin
                    if (x[9:2] >= START_CHAR_X + i * CHAR_WIDTH && x[9:2] < START_CHAR_X + (i + 1) * CHAR_WIDTH) begin
                        color = charRgb2[i];  // ??????????÷??ç??????? x
                    end
                end
            end
        end
        else if (y[9:2] >= START_CHAR_Y+LINE_SPACE*2 && y[9:2] < START_CHAR_Y+LINE_SPACE*2 + CHAR_HEIGHT) begin
            if (x[9:2] >= START_CHAR_X && x[9:2] < START_CHAR_X + CHAR_WIDTH * 8) begin
                // ?????????? x ????????????????????????
                for (integer i = 0; i < 8; i = i + 1) begin
                    if (x[9:2] >= START_CHAR_X + i * CHAR_WIDTH && x[9:2] < START_CHAR_X + (i + 1) * CHAR_WIDTH) begin
                        color = charRgb3[i];  // ??????????÷??ç??????? x
                    end
                end
            end
        end
        else if (y[9:2] >= START_CHAR_Y+LINE_SPACE*3 && y[9:2] < START_CHAR_Y+LINE_SPACE*3 + CHAR_HEIGHT) begin
            if (x[9:2] >= START_CHAR_X && x[9:2] < START_CHAR_X + CHAR_WIDTH * 8) begin
                // ?????????? x ????????????????????????
                for (integer i = 0; i < 8; i = i + 1) begin
                    if (x[9:2] >= START_CHAR_X + i * CHAR_WIDTH && x[9:2] < START_CHAR_X + (i + 1) * CHAR_WIDTH) begin
                        color = charRgb4[i];  // ??????????÷??ç??????? x
                    end
                end
            end
        end
        else if (y[9:2] >= START_CHAR_Y+LINE_SPACE*4 && y[9:2] < START_CHAR_Y+LINE_SPACE*4 + CHAR_HEIGHT) begin
            if (x[9:2] >= START_CHAR_X && x[9:2] < START_CHAR_X + CHAR_WIDTH * 8) begin
                // ?????????? x ????????????????????????
                for (integer i = 0; i < 8; i = i + 1) begin
                    if (x[9:2] >= START_CHAR_X + i * CHAR_WIDTH && x[9:2] < START_CHAR_X + (i + 1) * CHAR_WIDTH) begin
                        color = charRgb5[i];  // ??????????÷??ç??????? x
                    end
                end
            end
        end
        else if (x[9:2] >= START_PIC_X && x[9:2] < START_PIC_X + PICS_WIDTH &&
            y[9:2] >= START_PIC_Y && y[9:2] < START_PIC_Y + PICS_HEIGHT) 
        begin
            color = picRgb;
        end
//        else if (x[9:2] >= START_PIC_X_2 && x[9:2] < START_PIC_X_2 + PICS_WIDTH_2 &&
//            y[9:2] >= START_PIC_Y_2 && y[9:2] < START_PIC_Y_2 + PICS_HEIGHT_2) 
//        begin
//            color = picRgb2;
//        end
    end
    
    
endmodule




// Character ROM module to load and access character bitmaps
module CharRam(output reg [11:0] color, input [7:0] x, y, input [7:0] charIndex);
    localparam CHAR_WIDTH = 6;  // Width of each character in pixels
    localparam CHAR_HEIGHT = 7; // Height of each character in pixels

    reg [11:0] charRom[0:CHAR_WIDTH * CHAR_HEIGHT * 128 - 1];

    initial begin
        $readmemh("font_bitmap.mem", charRom);  // Load character bitmaps from memory file
    end

    always @(*) begin
        if (charIndex >= 128)  // Out of range for ASCII characters
            color = 12'hbdd;  // Default to white for out-of-range
        else begin
            
            color = charRom[y * CHAR_WIDTH + x + charIndex * CHAR_WIDTH * CHAR_HEIGHT];
        end
        $display("charIndex = %d", charIndex);
    end
endmodule