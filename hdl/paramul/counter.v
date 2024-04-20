module data_loader (
    input clk,
    input reset,
    input enable_write,  // Start write sequence
    input enable_read,   // Start read sequence
    output reg [31:0] w_data,
    output reg [9:0] w_addr, r_addr,
    output reg write_done  // Indicates completion of writing data
);

// State definitions
localparam IDLE = 0, WRITE = 1, WRITE_WAIT = 2, READ = 3, READ_WAIT = 4;
reg [2:0] state, next_state;

// Write and read count limit for a 3x3 matrix
localparam COUNT_LIMIT = 9;

// Control and status
integer count;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        w_data <= 0;
        w_addr <= 0;
        r_addr <= 0;
        count <= 0;
        write_done <= 0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (enable_write) next_state <= WRITE;
                else if (enable_read) next_state <= READ;
            end
            WRITE: begin
                w_data <= count+1024;  // Sample data: simply use count value
                w_addr <= count;  // Address: use count as address
                if (count < COUNT_LIMIT - 1) begin
                    count <= count + 1;
                end else begin
                    count <= 0;
                    next_state <= WRITE_WAIT;
                end
            end
            WRITE_WAIT: begin
                write_done <= 1;  // Indicate writing is done
                if (!enable_write) next_state <= IDLE;
            end
            READ: begin
                r_addr <= count;  // Read from the same address
                if (count < COUNT_LIMIT - 1) begin
                    count <= count + 1;
                end else begin
                    count <= 0;
                    next_state <= READ_WAIT;
                end
            end
            READ_WAIT: begin
                if (!enable_read) next_state <= IDLE;
            end
        endcase
    end
end

endmodule
