module vga_display_tb;

    // �ѭ�ҳ����Ѻ�������͡Ѻ vga_display
    reg clk;
    reg [7:0] char_in;
    reg write_enable;
    wire [11:0] color;
    wire Hsync, Vsync;

    // Instance �ͧ vga_display
    vga_display uut (
        .color(color),
        .Hsync(Hsync),
        .Vsync(Vsync),
        .clk(clk),
        .char_in(char_in),
        .write_enable(write_enable)
    );

    // ���ҧ Clock ����� period 10ns
    always begin
        #5 clk = ~clk;
    end

    // Testbench �������
    initial begin
        // ��駤���������
        clk = 0;
        write_enable = 0;
        char_in = 8'b0;
        
        // �ѡ��è��ͧ㹪�ǧ�����á�
        #10;
        
        // ���ͺ��û�͹������ 1 (��Ңͧ char_in = 'A')
        write_enable = 1;
        char_in = 8'h41; // 'A' � ASCII
        #10; // ����� clock �ӧҹ 1 cycle
        
        // ���ͺ��û�͹������ 2 (��Ңͧ char_in = 'B')
        char_in = 8'h42; // 'B' � ASCII
        #10;
        
        // ���ͺ��á����� DELETE (��Ңͧ char_in = 8'h7F)
        char_in = 8'h7F; // DELETE � ASCII
        #10;
        
        // ���ͺ��á����� Enter (��Ңͧ char_in = 8'h0D)
        char_in = 8'h0D; // ENTER � ASCII
        #10;
        
        // �Դ�����¹
        write_enable = 0;
        char_in = 8'h00;
        #10;

        // ���ͺ�ա����
        write_enable = 1;
        char_in = 8'h41; // 'A' � ASCII
        #10;
        
        // ����ش��÷��ͺ
        $finish;
    end

    // �ټ��Ѿ��� simulation
    initial begin
        $monitor("At time %t: Hsync = %b, Vsync = %b, color = %h", $time, Hsync, Vsync, color);
    end

endmodule
