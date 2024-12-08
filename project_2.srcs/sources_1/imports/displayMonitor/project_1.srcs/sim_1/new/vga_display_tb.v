module vga_display_tb;

    // สัญญาณสำหรับเชื่อมต่อกับ vga_display
    reg clk;
    reg [7:0] char_in;
    reg write_enable;
    wire [11:0] color;
    wire Hsync, Vsync;

    // Instance ของ vga_display
    vga_display uut (
        .color(color),
        .Hsync(Hsync),
        .Vsync(Vsync),
        .clk(clk),
        .char_in(char_in),
        .write_enable(write_enable)
    );

    // สร้าง Clock ให้มี period 10ns
    always begin
        #5 clk = ~clk;
    end

    // Testbench เริ่มต้น
    initial begin
        // ตั้งค่าเริ่มต้น
        clk = 0;
        write_enable = 0;
        char_in = 8'b0;
        
        // พักการจำลองในช่วงเวลาแรกๆ
        #10;
        
        // ทดสอบการป้อนข้อมูล 1 (ค่าของ char_in = 'A')
        write_enable = 1;
        char_in = 8'h41; // 'A' ใน ASCII
        #10; // รอให้ clock ทำงาน 1 cycle
        
        // ทดสอบการป้อนข้อมูล 2 (ค่าของ char_in = 'B')
        char_in = 8'h42; // 'B' ใน ASCII
        #10;
        
        // ทดสอบการกดปุ่ม DELETE (ค่าของ char_in = 8'h7F)
        char_in = 8'h7F; // DELETE ใน ASCII
        #10;
        
        // ทดสอบการกดปุ่ม Enter (ค่าของ char_in = 8'h0D)
        char_in = 8'h0D; // ENTER ใน ASCII
        #10;
        
        // ปิดการเขียน
        write_enable = 0;
        char_in = 8'h00;
        #10;

        // ทดสอบอีกครั้ง
        write_enable = 1;
        char_in = 8'h41; // 'A' ใน ASCII
        #10;
        
        // สิ้นสุดการทดสอบ
        $finish;
    end

    // ดูผลลัพธ์ใน simulation
    initial begin
        $monitor("At time %t: Hsync = %b, Vsync = %b, color = %h", $time, Hsync, Vsync, color);
    end

endmodule
