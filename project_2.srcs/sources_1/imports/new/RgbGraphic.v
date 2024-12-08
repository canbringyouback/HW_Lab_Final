module RgbGraphic(
    output reg [11:0] color,
    input [9:0] x, y
);
    localparam START_PIC_X = 0; 
    localparam START_PIC_Y = 20; 
    localparam PICS_WIDTH = 160; 
    localparam PICS_HEIGHT = 25; 
    
    wire [11:0] charRgb;
    GraphicRam3 graphRam_inst_1(
        .color(charRgb),  
        .x((x[9:2] >= START_PIC_X && x[9:2] < START_PIC_X + PICS_WIDTH) ? x[9:2] - START_PIC_X : 0),  
        .y((y[9:2] >= START_PIC_Y && y[9:2] < START_PIC_Y + PICS_HEIGHT) ? y[9:2] - START_PIC_Y : 0)
    );   
    
    always @(*) begin
        if (x[9:2] >= START_PIC_X && x[9:2] < START_PIC_X + PICS_WIDTH &&
            y[9:2] >= START_PIC_Y && y[9:2] < START_PIC_Y + PICS_HEIGHT) 
        begin
            color = charRgb;
        end
        
    end
    
endmodule


module GraphicRam(output reg [11:0] color, input [7:0] x, y);
    localparam PICS_WIDTH = 160;
    localparam PICS_HEIGHT = 20; 

    reg [11:0] graphRom[0:PICS_WIDTH * PICS_HEIGHT - 1];

    initial begin
        $readmemh("duck.mem", graphRom);  // Load character bitmaps from memory file
    end

    always @(*) begin
        if (x < PICS_WIDTH && y < PICS_HEIGHT)
            color = graphRom[y * PICS_WIDTH + x];
        else
            color = 12'hbdd;  // ??????????ó? index ?????
    end
endmodule

module GraphicRam2(output reg [11:0] color, input [7:0] x, y);
    localparam PICS_WIDTH = 22;
    localparam PICS_HEIGHT = 22; 

    reg [11:0] graphRom[0:PICS_WIDTH * PICS_HEIGHT - 1];

    initial begin
        $readmemh("sun.mem", graphRom);  // Load character bitmaps from memory file
    end

    always @(*) begin
        if (x < PICS_WIDTH && y < PICS_HEIGHT)
            color = graphRom[y * PICS_WIDTH + x];
        else
            color = 12'hbdd;  // ??????????ó? index ?????
    end
endmodule
module GraphicRam3(output reg [11:0] color, input [7:0] x, y);
    localparam PICS_WIDTH = 160;
    localparam PICS_HEIGHT = 25; 

    reg [11:0] graphRom[0:PICS_WIDTH * PICS_HEIGHT - 1];

    initial begin
        $readmemh("cow.mem", graphRom);  // Load character bitmaps from memory file
    end

    always @(*) begin
        if (x < PICS_WIDTH && y < PICS_HEIGHT)
            color = graphRom[y * PICS_WIDTH + x];
        else
            color = 12'h58A;  // ??????????ó? index ?????
    end
endmodule