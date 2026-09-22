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

    //used for R and I arithmetic
    typedef enum logic [1:0] {
        F3_ADD_SUB = 2'h0,
        F3_XOR = 2'h4,
        F3_OR = 2'h6,
        F3_AND = 2'h7,
        F3_SLL = 2'h1,
        F3_SRL_SRA = 2'h5,
        F3_SLT = 2'h2,
        F3_SLTU = 2'h3
    } funct3_r_t

    typedef enum logic [7:0] {
        F7_ADD = 8'h00,
        F7_SUB = 8'h20
    } funct7_r_add_sub

    typedef enum logic [7:0] {
        F7_SRL = 8'h00,
        F7_SRA = 8'20
    } funct7_r_shifts



endpackage
