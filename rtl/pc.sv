module pc (
    input clk,
    input rst,

    output [31:0] pc
)

always_ff @(posedge clk) begin
    if (rst) begin
        pc <= 32'h00000000;
    end
    else begin
        pc <= pc + 1;
    end
end

endmodule
