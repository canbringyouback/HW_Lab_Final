module uart_translate(
    input        clk,                // Clock signal
    input        RsRx,               // UART receive line
    input        use_external_input, // Select external input source
    input  [7:0] external_key_char,  // External keypress input
    input        uppercase,          // Uppercase control for external input
    input        sw_input,
    input        internal,
    input        external,
    input  [7:0] internal_buffer,
    input        tstart,     
    input        mirror,
    input  [7:0] keyboard,           // Button signal for manual sending (external only)
    output       tx,                 // UART transmit line
    output reg [8:0] buffer = 0,     // Buffer for the transmitted character
    output reg   ready = 0
              // Ready signal           // Ready signal feedback
);

    // Internal signals for UART receiver
    wire [7:0] received_data;       // Data received from UART
    wire       data_ready;          // Indicates when UART data is ready

    // Internal signals for UART transmitter
    reg        start_tx = 0;        // Start transmission signal
    reg [7:0]  transmit_data = 8'd0; // Data to transmit (ASCII character)
    wire       ready_tx;            // Indicates transmitter is ready

    // Processed keypress character
    reg [7:0] key_char = 8'd0;      // Shared key character
    reg [7:0] external_key = 8'd0;
    reg caps_lock=0;  // Key from external input
     // Caps Lock state (0: off, 1: on)

    // Stable uppercase control signal
    reg uppercase_stable = 0;
    always @(posedge clk) begin
        uppercase_stable <= uppercase; // Synchronize uppercase to clock
    end

    // UART receiver instantiation
    uart_rx receiver (
        .clk(clk),
        .RsRx(RsRx),
        .data(received_data),
        .ready(data_ready)
    );

    // UART transmitter instantiation
    uart_tx transmitter (
        .clk(clk),
        .tbus(transmit_data),
        .start(start_tx),
        .tx(tx),
        .ready(ready_tx)
    );

    // Process input data (either UART or external)
    always @(posedge clk) begin
        // Clear transmission start by default
        start_tx <= 1'b0;
       
         if (sw_input) begin
            // Process external input if `sw_input` is pressed
            if (!uppercase && external_key_char >= 8'h41 && external_key_char <= 8'h5A) begin
                    external_key = external_key_char + 8'h20; // Convert to lowercase
                end else begin
                    external_key = external_key_char; // Keep original value
                end
           
                // Perform case conversion if uppercase_stable is active
                

                // Transmit the processed key if valid
                if (external_key != 8'h3F) begin
                if(internal)begin
                    buffer <= {ready, external_key};
                    ready <= !ready;
                 end
                 else if(mirror)begin
                  transmit_data <=external_key;
                    buffer <= {ready, external_key};
                    start_tx <= 1'b1;
                    ready <= !ready;
                 end
                 else if(external) begin
                    transmit_data <= external_key;
                    start_tx <= 1'b1;
                 end // Toggle ready signal
                end
           
        end else if (external&&data_ready) begin
               // if (internal_buffer == 8'h58) begin
              
 
                // Transmit the character
                if (key_char != 8'h3F) begin
                
                    buffer <= {ready, received_data};
                    ready <= !ready;
                         end
        
        end
       
        else if (tstart) begin
           begin
                // Map scan code to ASCII character
                case (internal_buffer)

    // Numbers
    8'h16: key_char = uppercase ? 8'h21 : 8'h31; // '!' or '1'
    8'h1E: key_char = uppercase ? 8'h40 : 8'h32; // '@' or '2'
    8'h26: key_char = uppercase ? 8'h23 : 8'h33; // '#' or '3'
    8'h25: key_char = uppercase ? 8'h24 : 8'h34; // '$' or '4'
    8'h2E: key_char = uppercase ? 8'h25 : 8'h35; // '%' or '5'
    8'h36: key_char = uppercase ? 8'h5E : 8'h36; // '^' or '6'
    8'h3D: key_char = uppercase ? 8'h26 : 8'h37; // '&' or '7'
    8'h3E: key_char = uppercase ? 8'h2A : 8'h38; // '*' or '8'
    8'h46: key_char = uppercase ? 8'h28 : 8'h39; // '(' or '9'
    8'h45: key_char = uppercase ? 8'h29 : 8'h30; // ')' or '0'

    // Letters
    8'h1C: key_char = uppercase ? 8'h41 : 8'h61; // 'A' or 'a'
    8'h32: key_char = uppercase ? 8'h42 : 8'h62; // 'B' or 'b'
    8'h21: key_char = uppercase ? 8'h43 : 8'h63; // 'C' or 'c'
    8'h23: key_char = uppercase ? 8'h44 : 8'h64; // 'D' or 'd'
    8'h24: key_char = uppercase ? 8'h45 : 8'h65; // 'E' or 'e'
    8'h2B: key_char = uppercase ? 8'h46 : 8'h66; // 'F' or 'f'
    8'h34: key_char = uppercase ? 8'h47 : 8'h67; // 'G' or 'g'
    8'h33: key_char = uppercase ? 8'h48 : 8'h68; // 'H' or 'h'
    8'h43: key_char = uppercase ? 8'h49 : 8'h69; // 'I' or 'i'
    8'h3B: key_char = uppercase ? 8'h4A : 8'h6A; // 'J' or 'j'
    8'h42: key_char = uppercase ? 8'h4B : 8'h6B; // 'K' or 'k'
    8'h4B: key_char = uppercase ? 8'h4C : 8'h6C; // 'L' or 'l'
    8'h3A: key_char = uppercase ? 8'h4D : 8'h6D; // 'M' or 'm'
    8'h31: key_char = uppercase ? 8'h4E : 8'h6E; // 'N' or 'n'
    8'h44: key_char = uppercase ? 8'h4F : 8'h6F; // 'O' or 'o'
    8'h4D: key_char = uppercase ? 8'h50 : 8'h70; // 'P' or 'p'
    8'h15: key_char = uppercase ? 8'h51 : 8'h71; // 'Q' or 'q'
    8'h2D: key_char = uppercase ? 8'h52 : 8'h72; // 'R' or 'r'
    8'h1B: key_char = uppercase ? 8'h53 : 8'h73; // 'S' or 's'
    8'h2C: key_char = uppercase ? 8'h54 : 8'h74; // 'T' or 't'
    8'h3C: key_char = uppercase ? 8'h55 : 8'h75; // 'U' or 'u'
    8'h2A: key_char = uppercase ? 8'h56 : 8'h76; // 'V' or 'v'
    8'h1D: key_char = uppercase ? 8'h57 : 8'h77; // 'W' or 'w'
    8'h22: key_char = uppercase ? 8'h58 : 8'h78; // 'X' or 'x'
    8'h35: key_char = uppercase ? 8'h59 : 8'h79; // 'Y' or 'y'
    8'h1A: key_char = uppercase ? 8'h5A : 8'h7A; // 'Z' or 'z'

    // Punctuation and symbols
    8'h0E: key_char = uppercase ? 8'h7E : 8'h60;  // '~' or '`'
    8'h4E: key_char = uppercase ? 8'h5F : 8'h2D;  // '_' or '-'
    8'h55: key_char = uppercase ? 8'h2B : 8'h3D;  // '+' or '='
    8'h5D: key_char = uppercase ? 8'h7C : 8'h5C;  // '|' or '\'
    8'h54: key_char = uppercase ? 8'h7B : 8'h5B;  // '{' or '['
    8'h5B: key_char = uppercase ? 8'h7D : 8'h5D;  // '}' or ']'
    8'h4C: key_char = uppercase ? 8'h3A : 8'h3B;  // ':' or ';'
    8'h52: key_char = uppercase ? 8'h22 : 8'h27;  // '"' or '\''
    8'h41: key_char = uppercase ? 8'h3C : 8'h2C;  // '<' or ','
    8'h49: key_char = uppercase ? 8'h3E : 8'h2E;  // '>' or '.'
    8'h4A: key_char = uppercase ? 8'h3F : 8'h2F;  // '?' or '/'

    // Special keys
    8'h66: key_char = 8'h7F;  // 'DEL' (Delete)
    8'h5A: key_char = 8'h0A;
    8'h58: caps_lock= ~ caps_lock;  // 'Enter' (Line feed)
 8'h29: key_char = 8'h20; 
    default: key_char = 8'h3F; // '?' for unmapped keys
endcase

                // Transmit the character
                if (key_char != 8'h3F&&internal_buffer!=8'h58) begin
                if(internal)begin
                    buffer <= {ready, key_char};
                    ready <= !ready;
                    
                 end
                 else if(mirror)begin
                    transmit_data <= key_char;
                    buffer <= {ready, key_char};
                    start_tx <= 1'b1;
                    ready <= !ready;
                 end
                 else begin
                    transmit_data <= key_char;
                
                    start_tx <= 1'b1;   
                 end // Tog
                     // Toggle ready signal
                end
            end
        end
    end
endmodule
