module decoder (
    input logic [31:0] instruction_input,

    // Instruction fields to be output
    output logic [4:0] rd,
    output logic [4:0] rs1,
    output logic [4:0] rs2,
    output logic [31:0] imm,

    output logic [4:0] alu_control,

    // flags for the instruction
    output logic mem_write,
    output logic mem_read,
    output logic [1:0] mem_size,

    output logic reg_write,

    output logic [1:0] result_src, // where the result we want to write comes from

    output logic [2:0] branch, //covers the type branch to be done
    output logic jump,
    output logic jump_reg,

    output logic alu_src_immediate, //alu src2 = imm

    output logic e_call,

    output logic alu_src_pc
);
import riscv_defs::*;

logic [6:0] opcode;

logic [2:0] funct3;
logic [6:0] funct7;

always_comb begin
    opcode = instruction_input[6:0];

    rd = '0;
    rs1 = '0;
    rs2 = '0;
    imm = '0;

    alu_control = ALU_ADD;

    mem_write = 0;
    mem_read = 0;
    mem_size = SIZE_WORD;

    reg_write = 0;
    result_src = SOURCE_ALU;

    alu_src_immediate = 0;

    branch = BRANCH_NONE;
    jump = 0;
    jump_reg = 0;

    alu_src_pc = 0;

    e_call = 0;



    case (opcode) 
        OPCODE_R_TYPE: begin
            // R
            rd = instruction_input[11:7];
            funct3 = instruction_input[14:12];
            rs1 = instruction_input[19:15];
            rs2 = instruction_input[24:20];
            funct7 = instruction_input[31:25];

            reg_write = 1;
            mem_write = 0;
            alu_src_immediate = 0;

            case (func3)
                F3_ADD_SUB: begin
                    case (funct7)
                        F7_ADD: alu_control = ALU_ADD;
                        F7_SUB: alu_control = ALU_SUB;
                    endcase
                end

                F3_XOR: alu_control = ALU_XOR;
                F3_OR: alu_control = ALU_OR;
                F3_AND: alu_control = ALU_AND;
                F3_SLL: alu_control = ALU_SLL;

                F3_SRL_SRA: begin
                    case (funct7)
                        F7_SRL: alu_control = ALU_SRL;
                        F7_SRA: alu_control = ALU_SRA;
                    endcase
                end

                F3_SLT: alu_control = ALU_SLT;
                F3_SLTU: alu_control = ALU_SLUTU;
            endcase
        end
        OPCODE_I_TYPE_ARITH: begin
            // I arithmetic
            rd = instruction_input[11:7];
            funct3 = instruction_input[14:12];
            rs1 = instruction_input[19:15];
            imm = {{20{instruction_input[31]}}, instruction_input[31:20]};

            mem_write = 0;
            reg_write = 1;
            alu_src_immediate = 1;

            case (funct3)
                F3_ADD_SUB: alu_control = ALU_ADD; //Just add, no subbing (reused definition)
                F3_XOR: alu_control = ALU_XOR;
                F3_OR: alu_control = ALU_OR;
                F3_AND: alu_control = ALU_AND;
                F3_SLL: alu_control = ALU_SLL;

                F3_SRL_SRA: begin
                    case(imm[11:5])
                        //both definitions here are reused and as you can see
                        //aren't actually F7
                        F7_SRL: alu_control = ALU_SRL;
                        F7_SRA: alu_control = ALU_SRA;
                    endcase
                end

                F3_SLT: alu_control = ALU_SLT;
                F3_SLTU: alu_control = ALU_SLTU;
            endcase
        end
        OPCODE_I_TYPE_LOAD: begin
            // I loading
            rd = instruction_input[11:7];
            funct3 = instruction_input[14:12];
            rs1 = instruction_input[19:15];
            imm = {{20{instruction_input[31]}}, instruction_input[31:20]};

            reg_write = 1;
            mem_read = 1;
            mem_write = 0;
            result_src = SOURCE_MEM;
            alu_src_immediate = 1;
            alu_control = ALU_ADD;
            
            case (funct3)
                LOAD_STORE_BYTE: mem_size = SIZE_BYTE;
                LOAD_STORE_HALF: mem_size = SIZE_HALF;
                LOAD_STORE_WORD: mem_size = SIZE_WORD;
                LOAD_BYTEU: mem_size = SIZE_BYTE;
                LOAD_HALFU: mem_size = SIZE_HALF;
            endcase

        end
        OPCODE_S_TYPE: begin
            // S
            funct3 = instruction_input[14:12];
            rs1 = instruction_input[19:15];
            rs2 = instruction_input[24:20];

            imm = {{20{instruction_input[31]}},
                    instruction_input[31:25],
                    instruction_input[11:7]};

            reg_write = 0;
            mem_read = 0;
            mem_write = 1;
            result_src = SOURCE_REG;
            alu_src_immediate = 0;

            case (funct3)
                LOAD_STORE_BYTE: mem_size = SIZE_BYTE;
                LOAD_STORE_HALF: mem_size = SIZE_HALF;
                LOAD_STORE_WORD: mem_size = SIZE_WORD;
            endcase
        end
        OPCODE_B_TYPE: begin
            // B
            funct3 = instruction_input[14:12];
            rs1 = instruction_input[19:15];
            rs2 = instruction_input[24:20];

            imm = {
                {19{instruction_input[31]}},
                instruction_input[31],
                instruction_input[7],
                instruction_input[30:25],
                instruction_input[11:8],
                1'b0
            };

            reg_write = 0;
            mem_read = 0;
            mem_write = 0;
            result_src = SOURCE_REG;
            alu_src_immediate = 0;

            case (funct3) 
                F3_EQ: branch = BRANCH_EQ;
                F3_NE: branch = BRANCH_NE;
                F3_LT: branch = BRANCH_LT;
                F3_GE: branch = BRANCH_GE;
                F3_LTU: branch = BRANCH_LTU;
                F3_GEU: branch = BRANCH_GEU;
            endcase 
        end
        OPCODE_J_TYPE_LINK: begin
            // J (Jump and link)
            rd = instruction_input[11:7];

            imm = {
                {11{instruction_input[31]}},
                instruction_input[31],
                instruction_input[19:12],
                instruction_input[20],
                instruction_input[30:21],
                1'b0
            };

            reg_write = 1;
            mem_read = 0;
            mem_write = 0;
            result_src = SOURCE_PC_PLUS_4;
            alu_src_immediate = 0;
            jump = 1;
        end
        OPCODE_I_TYPE_LINK: begin
            // I (Jump and link reg)
            rd = instruction_input[11:7];
            funct3 = instruction_input[14:12];
            rs1 = instruction_input[19:15];
            imm = {{20{instruction_input[31]}}, instruction_input[31:20]};
            reg_write = 1;
            mem_read = 0;
            mem_write = 0;
            result_src = SOURCE_PC_PLUS_4;
            alu_src_immediate = 0;
            jump_reg = 1;
        end
        OPCODE_U_TYPE: begin
            // U (Load Upper Imm)
            rd = instruction_input[11:7];
            imm[31:12] = instruction_input[31:12];

            reg_write = 1;
            mem_read = 0;
            mem_write = 0;
            result_src = SOURCE_ALU;
            alu_src_immediate = 1;
            jump_reg = 0;
            alu_control = ALU_SLL;
        end
        OPCODE_U_TYPE_PC: begin
            // U (Add upper imm to pc)
            rd = instruction_input[11:7];
            imm[31:12] = instruction_input[31:12];

            reg_write = 1;
            mem_read = 0;
            mem_write = 0;
            result_src = SOURCE_ALU;
            alu_src_immediate = 1;
            jump_reg = 0;
            alu_control = ALU_SLL;

            //used primarily for auipc
            alu_src_pc = 1;
        end
        OPCODE_I_TYPE_ENV: begin
            // I (Environment)
            rd = instruction_input[11:7];
            funct3 = instruction_input[14:12];
            rs1 = instruction_input[19:15];
            imm[11:0] = {{20{instruction_input[31]}}, instruction_input[31:20]};

            // transfer controll to OS or debugger, based in imm, not that
            // important i don't think.
            reg_write = 0;
            mem_read = 0;
            mem_write = 0;
            result_src = SOURCE_ALU;
            alu_src_immediate = 0;
            jump_reg = 0;
            alu_control = 0;
        end
        default: begin
            // Unsuported instruction
        end
    endcase
end
endmodule

/*
* Unused localparams, converted to enums in the package
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
*/
