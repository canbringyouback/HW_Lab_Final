module Testbench;

    // ข้อกำหนดของสัญญาณ (signals)
    reg [9:0] x, y;
    reg [63:0] char_in;
    wire [11:0] color;

    // สร้าง instance ของ RgbRam
    RgbRam rgbRam_inst(
        .color(color),
        .x(x),
        .y(y),
        .character(char_in)  // ส่งค่าของ char_in เข้าไป
    );

    // ค่าทดสอบ (test case)
    initial begin
        // กำหนดค่า char_in
        char_in = 64'b001000100010001000100010001000100010001000100010001000100010001000100010;

        // กำหนดค่า x และ y สำหรับการทดสอบ
        // ตัวอย่างเช่น ทดสอบที่ตำแหน่ง x = 27, y = 30
        x = 27;
        y = 30;

        // พิมพ์ค่า charIndex ที่ถูกส่งไป
        #10;  // รอเวลาทำงานให้พอสมควร
        $display("Character at index: %b", char_in);  // แสดงผลค่า char_in (หรือค่าที่ใช้เป็น index)

        // สามารถทดสอบค่าตำแหน่งอื่น ๆ ได้ที่นี่
        x = 28;
        y = 30;
        #10;
        $display("Character at index: %b", char_in);

        // สั่งให้ simulation จบ
        $finish;
    end

    // ดูผลลัพธ์สีของตัวอักษร
    always @(*) begin
        // พิมพ์ค่า color เพื่อดูสีที่แสดงผล
        $display("Color: %b", color);
    end

endmodule
