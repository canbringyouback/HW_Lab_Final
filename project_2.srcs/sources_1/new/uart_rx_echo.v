module uart_rx_echo(
    input       clk,      // Clock signal
    input       RsRx,     // UART receive line
    output      tx, 
    output reg [7:0] buffer=0       // UART transmit line
);
    // Internal signals for UART receiver
    wire [7:0] received_data; // Data received from external UART
    wire       data_ready;    // Indicates when data is ready

    // Internal signals for UART transmitter
    reg        start_tx = 0;  // Start transmission signal
    reg [7:0]  transmit_data = 8'd0; // Data to transmit
    wire       ready_tx;      // Indicates transmitter is ready

    // Internal state for data consumption
    reg data_consumed = 0;

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

    // Echo received data
    always @(posedge clk) begin
        if (data_ready && ready_tx && !data_consumed) begin
            start_tx <= 1'b1;
            transmit_data <= received_data;
            buffer<=received_data;
            data_consumed <= 1'b1; // Mark data as consumed
        end else begin
            start_tx <= 1'b0;
            if (!data_ready) data_consumed <= 1'b0; // Reset consumption flag
        end
    end
endmodule
