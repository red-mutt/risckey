module decoder (
    input logic [31:0] instruction_input
);
always_comb begin
    logic [6:0] opcode;
    opcode = instruction_input[6:0];
    case (opcode) 
        7'b0110011: begin
            // R
        end
        7'b0010011: begin
            // I arithmetic
        end
        7'b0000011: begin
            // I loading
        end
        7'b0100011: begin
            // S
        end
        7'b1100011: begin
            // B
        end
        7'b1101111: begin
            // J (Jump and link)
        end
        7'b1100111: begin
            // I (Jump and link reg)
        end
        7'b0110111: begin
            // U (Load Upper Imm)
        end
        7'b0010111: begin
            // U (Add upeer imm to pc)
        end
        7'b1110011: begin
            // I (Environment)
        end
    endcase
end


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
