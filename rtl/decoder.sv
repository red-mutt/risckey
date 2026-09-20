module decoder (
    input logic [31:0] instruction_input
);

endmodule

module r_decoder (
    input logic [31:0] instruction_input,
    output logic [6:0] opcode,
    output logic [4:0] rd,
    output logic [2:0] funct3,
    output logic [4:0] rs1,
    output logic [4:0] rs2,
    output logic [6:0] funct7
);

endmodule
