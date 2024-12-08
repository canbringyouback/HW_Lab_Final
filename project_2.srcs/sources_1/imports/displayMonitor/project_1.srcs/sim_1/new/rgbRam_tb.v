module Testbench;

    // ��͡�˹��ͧ�ѭ�ҳ (signals)
    reg [9:0] x, y;
    reg [63:0] char_in;
    wire [11:0] color;

    // ���ҧ instance �ͧ RgbRam
    RgbRam rgbRam_inst(
        .color(color),
        .x(x),
        .y(y),
        .character(char_in)  // �觤�Ңͧ char_in ����
    );

    // ��ҷ��ͺ (test case)
    initial begin
        // ��˹���� char_in
        char_in = 64'b001000100010001000100010001000100010001000100010001000100010001000100010;

        // ��˹���� x ��� y ����Ѻ��÷��ͺ
        // ������ҧ�� ���ͺ�����˹� x = 27, y = 30
        x = 27;
        y = 30;

        // ������� charIndex ���١���
        #10;  // �����ҷӧҹ���������
        $display("Character at index: %b", char_in);  // �ʴ��Ť�� char_in (���ͤ�ҷ������ index)

        // ����ö���ͺ��ҵ��˹���� � ������
        x = 28;
        y = 30;
        #10;
        $display("Character at index: %b", char_in);

        // ������ simulation ��
        $finish;
    end

    // �ټ��Ѿ���բͧ����ѡ��
    always @(*) begin
        // ������� color ���ʹ��շ���ʴ���
        $display("Color: %b", color);
    end

endmodule
