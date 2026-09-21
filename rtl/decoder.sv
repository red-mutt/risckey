module decoder (
    input logic [31:0] instruction_input,
    output logic mem_write,
    output logic reg_write
);
always_comb begin
    logic [6:0] opcode;

    //Fields from R
    logic [4:0] rd;
    logic [2:0] funct3;
    logic [4:0] rs1;
    logic [4:0] rs2;
    logic [6:0] funct7;

    // I additions
    logic [31:0] imm;

    opcode = instruction_input[6:0];

    case (opcode) 
        OPCODE_R_TYPE: begin
            // R
            assign rd = instruction_input[11:7];
            assign funct3 = instruction_input[14:12];
            assign rs1 = instruction_input[19:15];
            assign rs2 = instruction_input[24:20];
            assign funct7 = instruction_input[31:25];

            reg_write = 1;
            mem_write = 0;
        end
        OPCODE_I_TYPE_ARITH: begin
            // I arithmetic
            assign rd = instruction_input[11:7];
            assign funct3 = instruction_input[14:12];
            assign rs1 = instruction_input[19:15];
            assign imm[11:0] = instruction_input[31:20];
        end
        OPCODE_I_TYPE_LOAD: begin
            // I loading
            assign rd = instruction_input[11:7];
            assign funct3 = instruction_input[14:12];
            assign rs1 = instruction_input[19:15];
            assign imm[11:0] = instruction_input[31:20];
        end
        OPCODE_S_TYPE: begin
            // S
            assign imm[4:0] = instruction_input[11:7];
            assign funct3 = instruction_input[14:12];
            assign rs1 = instruction_input[19:15];
            assign rs2 = instruction_input[24:20];
            assign imm[11:5] = instruction_input[31:25];
        end
        OPCODE_B_TYPE: begin
            // B
            assign imm[11] = instruction_input[7];
            assign imm[4:1] = instruction_input[4:1];
            assign funct3 = instruction_input[14:12];
            assign rs1 = instruction_input[19:15];
            assign rs2 = instruction_input[24:20];
            assign imm[10:5] = instruction_input[30:25];
            assign imm[12] = instruction_input[31];
            
            
        end
        OPCODE_J_TYPE_LINK: begin
            // J (Jump and link)
            assign rd = instruction_input[11:7];
            assign imm[19:12] = instruction_input[19:12];
            assign imm[11] = instruction_input[20];
            assign imm[10:1] = instruction_input[30:21];
            assign imm[20] = instruction_input[31];

        end
        OPCODE_I_TYPE_LINK: begin
            // I (Jump and link reg)
            assign rd = instruction_input[11:7];
            assign funct3 = instruction_input[14:12];
            assign rs1 = instruction_input[19:15];
            assign imm[11:0] = instruction_input[31:20];
        end
        OPCODE_U_TYPE: begin
            // U (Load Upper Imm)
            assign rd = instruction_input[11:7];
            assign imm[31:12] = instruction_input[31:12];
        end
        OPCODE_U_TYPE_PC: begin
            // U (Add upper imm to pc)
            assign rd = instruction_input[11:7];
            assign imm[31:12] = instruction_input[31:12];
        end
        OPCODE_I_TYPE_ENV: begin
            // I (Environment)
            assign rd = instruction_input[11:7];
            assign funct3 = instruction_input[14:12];
            assign rs1 = instruction_input[19:15];
            assign imm[11:0] = instruction_input[31:20];
        end
        default: begin
            // Unsuported instruction
        end
    endcase
end
endmodule

localparam logic [6:0] OPCODE_R_TYPE = 7'b0110011;
localparam logic [6:0] OPCODE_I_TYPE_ARITH = 7'b0010011;
localparam logic [6:0] OPCODE_I_TYPE_LOAD   = 7'b0000011;
localparam logic [6:0] OPCODE_S_TYPE = 7'b0100011;
localparam logic [6:0] OPCODE_B_TYPE = 7'b1100011;
localparam logic [6:0] OPCODE_J_TYPE_LINK = 7'b1101111;
localparam logic [6:0] OPCODE_I_TYPE_LINK = 7'b1100111;
localparam logic [6:0] OPCODE_U_TYPE = 7'b0110111;
localparam logic [6:0] OPCODE_U_TYPE_PC   = 7'b0010111;
localparam logic [6:0] OPCODE_I_TYPE_ENV   = 7'b1110011;
