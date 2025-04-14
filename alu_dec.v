//ALU decoder
module alu_dec (  
    input [2:0] funct3,
    input [6:0] funct7,   
    input [3:0] fmt,    
    output reg [3:0] ALU_ctr
);

// Definições operações ALU
parameter ADD = 5'b00000;
parameter SUB = 5'b00001;
parameter AND = 5'b00010;
parameter OR = 5'b00011;
parameter XOR = 5'b00100;
parameter SLL = 5'b00101;
parameter SRL = 5'b00110;
parameter SLT = 5'b00111;
parameter SRA = 5'b01110;
parameter SLTU = 5'b01111;
parameter SLL_12 = 5'b10000;

//Definições FMT
parameter R_TYPE = 0;
parameter I_TYPE = 1;
parameter IL_TYPE = 2;
parameter IE_TYPE = 3;
parameter S_TYPE = 4;
parameter B_TYPE = 5;
parameter J_TYPE = 6;
parameter JI_TYPE = 7;
parameter U_TYPE = 8;
parameter UP_TYPE = 9;

always @(*) begin

    case (fmt)
        R_TYPE: begin
            case (funct3)

                0: begin
                    if(funct7 == 0) ALU_ctr = ADD;
                    else if(funct7 == 'h20) ALU_ctr = SUB;
                end

                4: ALU_ctr = XOR;
                6: ALU_ctr = OR;
                7: ALU_ctr = AND;
                1: ALU_ctr = SLL; 

                5: begin
                    if (funct7 == 0) ALU_ctr = SRL; 
                    else if (funct7 == 'h20) ALU_ctr = SRA; 
                end 

                2: ALU_ctr = SLT; 
                3: ALU_ctr = SLTU;

                default: 
                    ALU_ctr = AND;
            endcase
        end
        I_TYPE: begin
            case (funct3)

                0: ALU_ctr = ADD;
                4: ALU_ctr = XOR;
                6: ALU_ctr = OR;
                7: ALU_ctr = AND;
                1: ALU_ctr = SLL; 

                5: begin
                    if (funct7 == 0) ALU_ctr = SRL; 
                    else if (funct7 == 'h20) ALU_ctr = SRA; 
                end 

                2: ALU_ctr = SLT;
                3: ALU_ctr = SLTU;

                default: 
                    ALU_ctr = AND;
                endcase
             
        end
        IL_TYPE: begin
         ALU_ctr = ADD;
        end
        S_TYPE: begin
           ALU_ctr = ADD;
        end
        B_TYPE: begin
            ALU_ctr = ADD;
        end
        J_TYPE: begin
            ALU_ctr = ADD;
        end
        JI_TYPE: begin
            ALU_ctr = ADD;
        end
        U_TYPE: begin
            ALU_ctr = SLL_12;
        end
        UP_TYPE: begin
            ALU_ctr = ADD;
        end
        default: ALU_ctr = ADD;
    endcase

end

endmodule
