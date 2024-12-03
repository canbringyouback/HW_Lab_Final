module int_to_ascii (
    input  [7:0] int_data,   // 8-bit integer input
    output reg [7:0] ascii_char // ASCII character output
);
    always @(*) begin
        case (int_data)
            8'd0: ascii_char = 8'h30;  // '0'
            8'd1: ascii_char = 8'h31;  // '1'
            8'd2: ascii_char = 8'h32;  // '2'
            8'd3: ascii_char = 8'h33;  // '3'
            8'd4: ascii_char = 8'h34;  // '4'
            8'd5: ascii_char = 8'h35;  // '5'
            8'd6: ascii_char = 8'h36;  // '6'
            8'd7: ascii_char = 8'h37;  // '7'
            8'd8: ascii_char = 8'h38;  // '8'
            8'd9: ascii_char = 8'h39;  // '9'
            default: ascii_char = 8'h3F; // '?' for invalid input
        endcase
    end
endmodule
