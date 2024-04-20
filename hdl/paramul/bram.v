module bram (
    input clk, 
    input [7:0] i_addr,
    input [31:0] i_data,
    input [7:0] o_addr,
    input write,
    input read, 
    output reg [31:0] o_read
);


    reg [31:0] ram [255:0];
    
    always @(posedge clk) begin
        if (write == 1'b1) begin
            ram[i_addr] <= i_data;
        end
        if (read == 1'b1) begin 
            o_read <= ram[o_addr];
        end
    end

endmodule
    
    