module ALU_Control (
    input wire is_immediate_i,
    input wire [1:0] ALU_CO_i,
    input wire [6:0] FUNC7_i,
    input wire [2:0] FUNC3_i,
    output reg [3:0] ALU_OP_o
);

    // Operações da ALU
    localparam AND_OP   = 4'b0000,
               OR_OP    = 4'b0001,
               XOR_OP   = 4'b1000,
               NOR_OP   = 4'b1001,
               SUM_OP   = 4'b0010,
               SUB_OP   = 4'b1010,
               EQ_OP    = 4'b0011,
               GE_OP    = 4'b1100,
               GEU_OP   = 4'b1101,
               SLT_OP   = 4'b1110,
               SLTU_OP  = 4'b1111,
               SLL_OP   = 4'b0100,
               SRL_OP   = 4'b0101,
               SRA_OP   = 4'b0111;

    always @(*) begin
        case (ALU_CO_i)
            // LOAD/STORE
            2'b00: ALU_OP_o = SUM_OP;

            // BRANCH
            2'b01: begin
                case (FUNC3_i)
                    3'b000: ALU_OP_o = SUB_OP;   // beq
                    3'b001: ALU_OP_o = EQ_OP;    // bne
                    3'b010: ALU_OP_o = SUB_OP;   // blt
                    3'b011: ALU_OP_o = SUB_OP;   // bltu
                    3'b100: ALU_OP_o = GE_OP;    // bge
                    3'b101: ALU_OP_o = SLT_OP;   // blt (em testes)
                    3'b110: ALU_OP_o = GEU_OP;   // bgeu
                    3'b111: ALU_OP_o = SLTU_OP;  // bgeu (alternativa)
                    default: ALU_OP_o = SUM_OP;
                endcase
            end

            // ALU
            2'b10: begin
                case (FUNC3_i)
                    3'b000: begin
                        if (is_immediate_i == 1'b1) begin
                            ALU_OP_o = SUM_OP; // ADDI
                        end else begin
                            if (FUNC7_i == 7'b0100000)
                                ALU_OP_o = SUB_OP; // SUB
                            else
                                ALU_OP_o = SUM_OP; // ADD
                        end
                    end

                    3'b001: ALU_OP_o = SLL_OP;   // SLL/SLLI
                    3'b010: ALU_OP_o = SLT_OP;   // SLT/SLTI
                    3'b011: ALU_OP_o = SLTU_OP;  // SLTU/SLTIU
                    3'b100: ALU_OP_o = XOR_OP;   // XOR/XORI

                    3'b101: begin
                        if (FUNC7_i == 7'b0100000)
                            ALU_OP_o = SRA_OP;   // SRA/SRAI
                        else
                            ALU_OP_o = SRL_OP;   // SRL/SRLI
                    end

                    3'b110: ALU_OP_o = OR_OP;    // OR/ORI
                    3'b111: ALU_OP_o = AND_OP;   // AND/ANDI
                    default: ALU_OP_o = SUM_OP;
                endcase
            end

            default: ALU_OP_o = 4'b0000;
        endcase
    end

endmodule