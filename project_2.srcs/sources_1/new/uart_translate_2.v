module uart_translate2(
    input       clk,       // Clock signal
    input       RsRx,      // UART receive line (first receiver)
    input       RsRx2,     // UART receive line (second receiver)
    output      tx         // UART transmit line
);
    // Internal signals for the first UART receiver
    wire [7:0] received_data1;  // Data received from the first UART
    wire       data_ready1;     // Indicates when data is ready from the first UART

    // Internal signals for the second UART receiver
    wire [7:0] received_data2;  // Data received from the second UART
    wire       data_ready2;     // Indicates when data is ready from the second UART

    // Internal signals for UART transmitter
    reg        start_tx = 0;      // Start transmission signal
    reg [7:0]  transmit_data = 8'd0; // Data to transmit (ASCII character)
    wire       ready_tx;          // Indicates transmitter is ready

    // Processed keypress character
    reg [7:0] key_char = 8'd0; // Mapped keypress character
    reg       caps_lock = 0;   // Caps Lock state (0: off, 1: on)

    // UART receiver instantiation for the first receiver
    uart_rx receiver1 (
        .clk(clk),
        .RsRx(RsRx),
        .data(received_data1),
        .ready(data_ready1)
    );

    // UART receiver instantiation for the second receiver
    uart_rx receiver2 (
        .clk(clk),
        .RsRx(RsRx2),
        .data(received_data2),
        .ready(data_ready2)
    );

    // UART transmitter instantiation
    uart_tx transmitter (
        .clk(clk),
        .tbus(transmit_data),
        .start(start_tx),
        .tx(tx),
        .ready(ready_tx)
    );

    // Scan code to keypress character mapping and selection of active receiver
    always @(posedge clk) begin
        if ((data_ready1 || data_ready2) && ready_tx) begin
            if (data_ready1) begin
                // Handle data from the first receiver
                if (received_data1 == 8'h58) begin
                    caps_lock <= ~caps_lock; // Toggle Caps Lock state
                end else begin
                    case (received_data1)
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
                        8'h1C: key_char <= caps_lock ? 8'h41 : 8'h61; // 'A'/'a'
                        8'h32: key_char <= caps_lock ? 8'h42 : 8'h62; // 'B'/'b'
                        8'h21: key_char <= caps_lock ? 8'h43 : 8'h63; // 'C'/'c'
                        8'h23: key_char <= caps_lock ? 8'h44 : 8'h64; // 'D'/'d'
                        8'h24: key_char <= caps_lock ? 8'h45 : 8'h65; // 'E'/'e'
                        8'h2B: key_char <= caps_lock ? 8'h46 : 8'h66; // 'F'/'f'
                        8'h34: key_char <= caps_lock ? 8'h47 : 8'h67; // 'G'/'g'
                        8'h33: key_char <= caps_lock ? 8'h48 : 8'h68; // 'H'/'h'
                        8'h43: key_char <= caps_lock ? 8'h49 : 8'h69; // 'I'/'i'
                        8'h3B: key_char <= caps_lock ? 8'h4A : 8'h6A; // 'J'/'j'
                        8'h42: key_char <= caps_lock ? 8'h4B : 8'h6B; // 'K'/'k'
                        8'h4B: key_char <= caps_lock ? 8'h4C : 8'h6C; // 'L'/'l'
                        8'h3A: key_char <= caps_lock ? 8'h4D : 8'h6D; // 'M'/'m'
                        8'h31: key_char <= caps_lock ? 8'h4E : 8'h6E; // 'N'/'n'
                        8'h44: key_char <= caps_lock ? 8'h4F : 8'h6F; // 'O'/'o'
                        8'h4D: key_char <= caps_lock ? 8'h50 : 8'h70; // 'P'/'p'
                        8'h15: key_char <= caps_lock ? 8'h51 : 8'h71; // 'Q'/'q'
                        8'h2D: key_char <= caps_lock ? 8'h52 : 8'h72; // 'R'/'r'
                        8'h1B: key_char <= caps_lock ? 8'h53 : 8'h73; // 'S'/'s'
                        8'h2C: key_char <= caps_lock ? 8'h54 : 8'h74; // 'T'/'t'
                        8'h3C: key_char <= caps_lock ? 8'h55 : 8'h75; // 'U'/'u'
                        8'h2A: key_char <= caps_lock ? 8'h56 : 8'h76; // 'V'/'v'
                        8'h1D: key_char <= caps_lock ? 8'h57 : 8'h77; // 'W'/'w'
                        8'h22: key_char <= caps_lock ? 8'h58 : 8'h78; // 'X'/'x'
                        8'h35: key_char <= caps_lock ? 8'h59 : 8'h79; // 'Y'/'y'
                        8'h1A: key_char <= caps_lock ? 8'h5A : 8'h7A; // 'Z'/'z'

                        // Special Characters (e.g., Enter, Space, etc.)
                        8'h29: key_char <= 8'h20; // Space
                        8'h5A: key_char <= 8'h0D; // Enter
                        8'h66: key_char <= 8'h08; // Backspace
                        8'h0D: key_char <= 8'h1B; // Escape (optional mapping)

                        // Default case for unmapped keys
                        default: key_char <= 8'h3F; // '?' for unknown codes
                    endcase
                end
            end else if (data_ready2) begin
                // Handle data from the second receiver
                // (Similar to the first receiver, map keys here if needed)
            end

            // Trigger transmission of the processed key character
            if (key_char != 8'h3F) begin
                transmit_data <= key_char;
                start_tx <= 1'b1;
            end
        end else begin
            start_tx <= 1'b0; // Clear transmission start
        end
    end
endmodule
