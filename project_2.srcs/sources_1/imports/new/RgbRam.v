module RgbRam(output reg [11:0] color, 
              input [9:0] x, y, 
              input [63:0] character,
              input [63:0] character_2,
              input [63:0] character_3,
              input [63:0] character_4,
              input [63:0] character_5,
              input [9:0]START_CHAR_X,
              input [9:0]START_CHAR_Y
              );  // �Ѻ�����ŵ���ѡ�� 8 ���

    localparam CHAR_WIDTH = 6;  // �������ҧ�ͧ����ѡ��
    localparam CHAR_HEIGHT = 7; // �����٧�ͧ����ѡ��

//    localparam START_CHAR_X = 27;
    localparam LINE_SPACE = 15;

    wire [11:0] charRgb[7:0];
    wire [11:0] charRgb2[7:0]; 
    wire [11:0] charRgb3[7:0]; 
    wire [11:0] charRgb4[7:0]; 
    wire [11:0] charRgb5[7:0]; 

    // Instantiate CharRam ����Ѻ����ѡ�����е��
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
    
    always @(*) begin
        // ��˹������ѧ���բ��
        color = 12'b111111111111;

        if (y[9:2] >= START_CHAR_Y && y[9:2] < START_CHAR_Y + CHAR_HEIGHT) begin
            if (x[9:2] >= START_CHAR_X && x[9:2] < START_CHAR_X + CHAR_WIDTH * 8) begin
               
                for (integer i = 0; i < 8; i = i + 1) begin
                    if (x[9:2] >= START_CHAR_X + i * CHAR_WIDTH && x[9:2] < START_CHAR_X + (i + 1) * CHAR_WIDTH) begin
                        color = charRgb[i];  // �ʴ��ŵ���ѡ�÷��ç�Ѻ���˹� x
                    end
                end
            end
        end
        else if (y[9:2] >= START_CHAR_Y+LINE_SPACE && y[9:2] < START_CHAR_Y+LINE_SPACE + CHAR_HEIGHT) begin
            if (x[9:2] >= START_CHAR_X && x[9:2] < START_CHAR_X + CHAR_WIDTH * 8) begin
                // ��Ǩ�ͺ���˹� x ������͡�յ�����˹觢ͧ����ѡ��
                for (integer i = 0; i < 8; i = i + 1) begin
                    if (x[9:2] >= START_CHAR_X + i * CHAR_WIDTH && x[9:2] < START_CHAR_X + (i + 1) * CHAR_WIDTH) begin
                        color = charRgb2[i];  // �ʴ��ŵ���ѡ�÷��ç�Ѻ���˹� x
                    end
                end
            end
        end
        else if (y[9:2] >= START_CHAR_Y+LINE_SPACE*2 && y[9:2] < START_CHAR_Y+LINE_SPACE*2 + CHAR_HEIGHT) begin
            if (x[9:2] >= START_CHAR_X && x[9:2] < START_CHAR_X + CHAR_WIDTH * 8) begin
                // ��Ǩ�ͺ���˹� x ������͡�յ�����˹觢ͧ����ѡ��
                for (integer i = 0; i < 8; i = i + 1) begin
                    if (x[9:2] >= START_CHAR_X + i * CHAR_WIDTH && x[9:2] < START_CHAR_X + (i + 1) * CHAR_WIDTH) begin
                        color = charRgb3[i];  // �ʴ��ŵ���ѡ�÷��ç�Ѻ���˹� x
                    end
                end
            end
        end
        else if (y[9:2] >= START_CHAR_Y+LINE_SPACE*3 && y[9:2] < START_CHAR_Y+LINE_SPACE*3 + CHAR_HEIGHT) begin
            if (x[9:2] >= START_CHAR_X && x[9:2] < START_CHAR_X + CHAR_WIDTH * 8) begin
                // ��Ǩ�ͺ���˹� x ������͡�յ�����˹觢ͧ����ѡ��
                for (integer i = 0; i < 8; i = i + 1) begin
                    if (x[9:2] >= START_CHAR_X + i * CHAR_WIDTH && x[9:2] < START_CHAR_X + (i + 1) * CHAR_WIDTH) begin
                        color = charRgb4[i];  // �ʴ��ŵ���ѡ�÷��ç�Ѻ���˹� x
                    end
                end
            end
        end
        else if (y[9:2] >= START_CHAR_Y+LINE_SPACE*4 && y[9:2] < START_CHAR_Y+LINE_SPACE*4 + CHAR_HEIGHT) begin
            if (x[9:2] >= START_CHAR_X && x[9:2] < START_CHAR_X + CHAR_WIDTH * 8) begin
                // ��Ǩ�ͺ���˹� x ������͡�յ�����˹觢ͧ����ѡ��
                for (integer i = 0; i < 8; i = i + 1) begin
                    if (x[9:2] >= START_CHAR_X + i * CHAR_WIDTH && x[9:2] < START_CHAR_X + (i + 1) * CHAR_WIDTH) begin
                        color = charRgb5[i];  // �ʴ��ŵ���ѡ�÷��ç�Ѻ���˹� x
                    end
                end
            end
        end
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
            color = 12'b111111111111;  // Default to white for out-of-range
        else begin
            
            color = charRom[y * CHAR_WIDTH + x + charIndex * CHAR_WIDTH * CHAR_HEIGHT];
        end
        $display("charIndex = %d", charIndex);
    end
endmodule