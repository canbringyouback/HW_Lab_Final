module translate_to_ascii(
    input             clk,         // Clock signal
    input      [31:0] tbuf1,       // Keyboard scan codes from tbuf1
    input             start1,      // Start signal for tbuf1
    output reg [31:0] pbuf = 32'd0, // Processed ASCII characters
    output reg        ready = 0     // Ready signal
);
    reg [7:0] key_char = 8'd0;      // Translated ASCII character
    reg       caps_lock = 0;        // Caps Lock state (0: off, 1: on)

    // State Machine for translating scan codes
    always @(posedge clk) begin
        if (start1) begin
            // Check for Caps Lock toggle
            if (tbuf1[7:0] == 8'h58) begin
                caps_lock <= ~caps_lock; // Toggle Caps Lock
                ready <= 0; // No ASCII output for Caps Lock key
            end else begin
                // Translate the scan code into ASCII
                case (tbuf1[7:0])
                    // Numbers
                    8'h16: key_char <= 8'h31; // '1'
                    8'h1E: key_char <= 8'h32; // '2'
                    8'h26: key_char <= 8'h33; // '3'
                    8'h25: key_char <= 8'h34; // '4'
                    8'h2E: key_char <= 8'h35; // '5'
                    8'h36: key_char <= 8'h36; // '6'
                    8'h3D: key_char <= 8'h37; // '7'
                    8'h3E: key_char <= 8'h38; // '8'
                    8'h46: key_char <= 8'h39; // '9'
                    8'h45: key_char <= 8'h30; // '0'

                    // Letters
                    8'h1C: key_char <= caps_lock ? 8'h41 : 8'h61; // 'a' or 'A'
                    8'h32: key_char <= caps_lock ? 8'h42 : 8'h62; // 'b' or 'B'
                    8'h21: key_char <= caps_lock ? 8'h43 : 8'h63; // 'c' or 'C'
                    8'h23: key_char <= caps_lock ? 8'h44 : 8'h64; // 'd' or 'D'
                    8'h24: key_char <= caps_lock ? 8'h45 : 8'h65; // 'e' or 'E'
                    8'h2B: key_char <= caps_lock ? 8'h46 : 8'h66; // 'f' or 'F'
                    8'h34: key_char <= caps_lock ? 8'h47 : 8'h67; // 'g' or 'G'
                    8'h33: key_char <= caps_lock ? 8'h48 : 8'h68; // 'h' or 'H'
                    8'h43: key_char <= caps_lock ? 8'h49 : 8'h69; // 'i' or 'I'
                    8'h3B: key_char <= caps_lock ? 8'h4A : 8'h6A; // 'j' or 'J'
                    8'h42: key_char <= caps_lock ? 8'h4B : 8'h6B; // 'k' or 'K'
                    8'h4B: key_char <= caps_lock ? 8'h4C : 8'h6C; // 'l' or 'L'
                    8'h3A: key_char <= caps_lock ? 8'h4D : 8'h6D; // 'm' or 'M'
                    8'h31: key_char <= caps_lock ? 8'h4E : 8'h6E; // 'n' or 'N'
                    8'h44: key_char <= caps_lock ? 8'h4F : 8'h6F; // 'o' or 'O'
                    8'h4D: key_char <= caps_lock ? 8'h50 : 8'h70; // 'p' or 'P'
                    8'h15: key_char <= caps_lock ? 8'h51 : 8'h71; // 'q' or 'Q'
                    8'h2D: key_char <= caps_lock ? 8'h52 : 8'h72; // 'r' or 'R'
                    8'h1B: key_char <= caps_lock ? 8'h53 : 8'h73; // 's' or 'S'
                    8'h2C: key_char <= caps_lock ? 8'h54 : 8'h74; // 't' or 'T'
                    8'h3C: key_char <= caps_lock ? 8'h55 : 8'h75; // 'u' or 'U'
                    8'h2A: key_char <= caps_lock ? 8'h56 : 8'h76; // 'v' or 'V'
                    8'h1D: key_char <= caps_lock ? 8'h57 : 8'h77; // 'w' or 'W'
                    8'h22: key_char <= caps_lock ? 8'h58 : 8'h78; // 'x' or 'X'
                    8'h35: key_char <= caps_lock ? 8'h59 : 8'h79; // 'y' or 'Y'
                    8'h1A: key_char <= caps_lock ? 8'h5A : 8'h7A; // 'z' or 'Z'

                    // Default case for unmapped keys
                    default: key_char <= 8'h3F; // '?' for unknown codes
                endcase
                if(key_char!=8'h3F) begin pbuf <= {24'd0, key_char}; 
               
                ready <= 1'b1;
                end
                // Update processed buffer (pbuf)
               // Pass only the current ASCII character
                // Indicate data is ready
            end
        end else begin
            ready <= 1'b0; // No data being processed
        end
    end
endmodule
