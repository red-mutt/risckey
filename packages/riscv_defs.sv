package riscv_defs;

    typedef enum logic [6:0] {
         OPCODE_R_TYPE = 7'b0110011,
         OPCODE_I_TYPE_ARITH = 7'b0010011,
         OPCODE_I_TYPE_LOAD   = 7'b0000011,
         OPCODE_S_TYPE = 7'b0100011,
         OPCODE_B_TYPE = 7'b1100011,
         OPCODE_J_TYPE_LINK = 7'b1101111,
         OPCODE_I_TYPE_LINK = 7'b1100111,
         OPCODE_U_TYPE = 7'b0110111,
         OPCODE_U_TYPE_PC   = 7'b0010111,
         OPCODE_I_TYPE_ENV   = 7'b1110011
    } opcode_t;


    typedef enum logic [3:0] {
        ALU_ADD = 4'b0000,
        ALU_SUB = 4'b0001,
        ALU_AND = 4'b0010,
        ALU_OR = 4'b0011,
        ALU_SLL = 4'b0100,
        ALU_SLT = 4'b0101,
        ALU_SRL = 4'b0110,
        ALU_SLTU = 4'b0111,
        ALU_XOR = 4'b1000,
        ALU_SRA = 4'b1001
    } alu_control_t;



endpackage
