module flow_controller(
    input clk,
    input reset,
    output reg [31:0] output_result, // connected to the ILA
    output reg output_valid  // output_result holds valid data
);

wire [31:0] w_data, mul_data_a, mul_data_b;
wire [7:0] w_addr;
reg [7:0] read_addr_a, read_addr_b;
wire [63:0] product;
reg [31:0] result_matrix[8:0];
reg [2:0] state, i, j, k;
reg [3:0] result_index;
wire write_done, read, write;

data_loader loader(
    .clk(clk),
    .reset(reset),
    .enable_write(state == 0),
    .w_data(w_data),
    .w_addr(w_addr),
    .write_done(write_done)
);


 bramsdp bram(
        .clk(clk),
        .addra(w_addr),
        .dia(w_data),
        .addrb((state == 1) ? read_addr_a : read_addr_b), 
        .ena((state == 3)),
        .wea((state == 3)),
        .enb((state == 1) || (state == 2)),
        .dob((state == 1) ? mul_data_a : mul_data_b)
    );

paramul multiplier(
    .multiplier(mul_data_a),
    .multiplicand(mul_data_b),
    .sign(1'b0),
    .product(product)
);

always @(posedge clk) begin
    if (reset) begin
        state <= 0; 
        i <= 0; j <= 0; k <= 0;
    end else begin
        case (state)
            0: begin
                if (write_done) state <= 1; // Data loading done, move to multiplication
            end
            1: begin // Read Matrix A data
                read_addr_a <= i*3 + k;
                state <= 2;
            end
            2: begin // Read Matrix B data
                read_addr_b <= 9 + k*3 + j;
                state <= 3;
            end
            3: begin // Calculate and store result
                result_matrix[i*3+j] <= result_matrix[i*3+j] + product[31:0];
                k <= k + 1;
                if (k == 3) begin
                    k <= 0; j <= j + 1;
                    if (j == 3) begin
                        j <= 0; i <= i + 1;
                        if (i == 3) state <= 4; // Completion of operation
                        else state <= 1; // Next row
                    end else state <= 1;
                end else state <= 1;
            end
            4: begin
                if (result_index < 9) begin
                    output_result <= result_matrix[result_index];  // Send result to output
                    output_valid <= 1;
                    result_index <= result_index + 1;
                end else begin
                    output_valid <= 0; // No more valid data
                    state <= 5; // Move to completion state
                end
            end
            5: begin
                // Completed all output operations
                // Optionally reset or wait for further instructions
            end
        endcase
    end
end

endmodule

