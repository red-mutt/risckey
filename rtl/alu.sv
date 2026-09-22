module alu (
    input logic [3:0] alu_control,
    input logic [31:0] src1,
    input logic [31:0] src2,
    output logic [31:0] alu_result
);

import riscv_defs::*;

always_comb begin
    case (alu_control)
        ALU_ADD: alu_result = src1 + src2;
        ALU_SUB: alu_result = src1 - src2;
        ALU_AND: alu_result = src1 & src2;
        ALU_OR: alu_result = src1 | src2;
        ALU_SLL: alu_result = src1 << src2;
        ALU_SLT: alu_result = $signed(src1) < $signed(src2);
        ALU_SRL: alu_result = src1 >> src2;
        ALU_SLTU: alu_result = src1 < src2;
        ALU_XOR: alu_result = src1 ^ src2;
        ALU_SRA: alu_result = $signed(src1) >>> src2;
        default: alu_result = 0;
    endcase
end

endmodule


