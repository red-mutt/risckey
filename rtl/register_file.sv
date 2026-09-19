module register_file (
    input logic clk,
    input logic reset,
    input logic write_enable,
    input logic [5:0] write_address,
    input logic [31:0] write_data,
    input logic [5:0] read_address,
    output logic [31:0] read_data
);
// 32 = program counter
/* Registers x0-x31
* Standard software uses x1 to hold return address for call
* standard calling also uses x2 as the stack pointer
*/
logic [31:0] regs [0:31];


endmodule
