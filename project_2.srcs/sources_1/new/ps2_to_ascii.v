module ps2_to_ascii (
    input        clk,
    input        PS2Clk,
    input        PS2Data,
    output [31:0] tbuf,
    output       start
);
    reg         CLK50MHZ = 0;
    reg  [15:0] keycodev = 0;
    wire [15:0] keycode;
    wire        flag;
    reg         cn = 0;
    reg  [ 2:0] bcount = 0;

    // Generate 50MHz clock
    always @(posedge clk) begin
        CLK50MHZ <= ~CLK50MHZ;
    end

    // PS2 Receiver instance
    PS2Receiver uut (
        .clk(CLK50MHZ),
        .kclk(PS2Clk),
        .kdata(PS2Data),
        .keycode(keycode),
        .oflag(flag)
    );

    // Keycode processing
    always @(keycode) begin
        if (keycode[7:0] == 8'hf0) begin
            cn <= 1'b0;
            bcount <= 3'd0;
        end else if (keycode[15:8] == 8'hf0) begin
            cn <= 1'b0;
            bcount <= 3'd5;
        end else begin
            cn <= keycode[7:0] != keycodev[7:0] || keycodev[15:8] == 8'hf0 || keycode[15:8] != 8'hf0;
            bcount <= 3'd2;
        end
    end

    // Latch keycode and generate start signal
    reg start_reg = 0;
    always @(posedge clk) begin
        if (flag == 1'b1 && cn == 1'b1) begin
            start_reg <= 1'b1;
            keycodev <= keycode;
        end else
            start_reg <= 1'b0;
    end

    assign start = start_reg;

    // Binary to ASCII conversion
    bin2ascii #(
        .NBYTES(2)
    ) conv (
        .I(keycodev),
        .O(tbuf)
    );
endmodule
