module uart_buf_con_2(
    input             clk,
    input      [ 2:0] bcount,
    input      [31:0] tbuf1,  // First buffer input
    input      [31:0] tbuf2,  // Second buffer input
    input             start1, // Start signal for first buffer
    input             start2, // Start signal for second buffer
    output            ready,  // Indicates UART is ready
    output reg        tstart = 0, // Start signal for UART transmitter
    input             tready, // UART transmitter ready signal
    output reg [ 7:0] tbus = 0 // Byte to transmit
);
    reg [2:0] sel = 0;
    reg [31:0] pbuf = 0;
    reg running = 0;

    // Priority mechanism
    wire priority1 = start1 && !start2; // Priority for tbuf1
    wire priority2 = start2;            // Priority for tbuf2

    initial tstart <= 1'b0;
    initial tbus <= 8'b0;

    always @(posedge clk) begin
        if (tready == 1'b1) begin
            if (running == 1'b1) begin
                // Continue transmitting the current buffer
                if (sel == 3'd1) begin
                    running <= 1'b0;
                    sel <= bcount + 2'd2;
                end else begin
                    sel <= sel - 1'b1;
                    tstart <= 1'b1;
                end
            end else begin
                // Start transmitting a new buffer
                if (bcount != 3'b0) begin
                    if (priority1) begin
                        pbuf <= tbuf1; // Load buffer 1
                        tstart <= start1;
                        running <= start1;
                        sel <= bcount + 2'd2;
                    end else if (priority2) begin
                        pbuf <= tbuf2; // Load buffer 2
                        tstart <= start2;
                        running <= start2;
                        sel <= bcount + 2'd2;
                    end
                end
            end
        end else begin
            tstart <= 1'b0; // Stop transmitting
        end
    end

    assign ready = ~running;

    always @(sel, pbuf) begin
        case (sel)
            3'd1: tbus <= 8'h0;
            3'd2: tbus <= 8'd0;
            3'd3: tbus <= pbuf[7:0];
            3'd4: tbus <= 8'h0;
            3'd5: tbus <= 8'h0;
            3'd6: tbus <= 8'h0;
            default: tbus <= 8'd0;
        endcase
    end
endmodule
