module register_file (
    input logic clk,
    input logic reset,
    input logic write_enable,
    input logic [4:0] write_address,
    input logic [31:0] write_data,

    input logic [4:0] read_address_a,
    output logic [31:0] read_data_a,
    input logic [4:0] read_address_b,
    output logic [31:0] read_data_b
);
// 32 = program counter
/* Registers x0-x31
* Standard software uses x1 to hold return address for call
* standard calling also uses x2 as the stack pointer
*/
logic [31:0] regs [0:31];

always_ff @(posedge clk) begin
    if (reset) begin
        for (int i = 0; i < 32; i++) begin
            regs[i] <= 32'b0;
        end
    end
    else if (write_enable && write_address != 0) begin
        regs[write_address] <= write_data;
    end
end

always_comb begin
    read_data_a = regs[read_address_a];
    read_data_b = regs[read_address_b];
end



endmodule
