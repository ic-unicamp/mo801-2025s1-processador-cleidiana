//ALU decoder
module alu_dec (  
    input [2:0] funct3,
    input [6:0] funct7,   
    input [3:0] fmt,    
    output reg [3:0] ALU_ctr
);

// Definições operações ALU
parameter ADD = 4'b0000;
parameter SUB = 4'b0001;
parameter AND = 4'b0010;
parameter OR = 4'b0011;
parameter XOR = 4'b0100;
parameter SLL = 4'b0101;
parameter SRL = 4'b0110;
parameter SLT = 4'b0111;
parameter BEQ = 4'b1000;
parameter BNE = 4'b1001;
parameter BLT = 4'b1010;
parameter BGE = 4'b1011;
parameter BLTU = 4'b1100;
parameter BGEU = 4'b1101;

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
            if (funct3 == 0) begin
                if(funct7 == 0) ALU_ctr = ADD;
                else if(funct7 == 'h20) ALU_ctr = SUB;
            end 
            else if (funct3 == 4) begin
                ALU_ctr = XOR;
            end 
            else if (funct3 == 6) begin
                ALU_ctr = OR;
            end 
            else if (funct3 == 7) begin
                ALU_ctr = AND;
            end 
            else if (funct3 == 1) begin
                ALU_ctr = SLL; 
            end 
            else if (funct3 == 5) begin
                if (funct7 == 0) ALU_ctr = SRL; 
                //else if (funct7 == 'h20) ALU_ctr = SRA; 
            end 
            else if (funct3 == 2) begin
                ALU_ctr = SLT; 
            end
            else if (funct3 == 3) begin //todo
            end 
        end
        I_TYPE: begin
            if (funct3 == 0) begin
               ALU_ctr = ADD;
            end 
            else if (funct3 == 4) begin
                ALU_ctr = XOR;
            end 
            else if (funct3 == 6) begin
                ALU_ctr = OR;
            end 
            else if (funct3 == 7) begin
                ALU_ctr = AND;
            end 
            else if (funct3 == 1) begin
                ALU_ctr = SLL; 
            end 
            else if (funct3 == 5) begin
                if (funct7 == 0) ALU_ctr = SRL; 
               // else if (funct7 == 'h20) ALU_ctr = SRA; 
            end 
            else if (funct3 == 2) begin
                ALU_ctr = SLT; 
            end
            else if (funct3 == 3) begin //todo
            end  
        end
        IL_TYPE: begin
         ALU_ctr = ADD;
        end
        S_TYPE: begin
           ALU_ctr = ADD;
        end
        B_TYPE: begin
            if (funct3 == 0) begin
                ALU_ctr = BEQ;
            end 
            else if (funct3 == 1) begin
                ALU_ctr = BNE;
            end 
            else if (funct3 == 4) begin
                ALU_ctr = BLT;
            end 
            else if (funct3 == 5) begin
                ALU_ctr = BGE;
            end 
            else if (funct3 == 6) begin
                ALU_ctr = BLTU; 
            end 
            else if (funct3 == 7) begin
                ALU_ctr = BGEU; 
            end 
        end
        J_TYPE: begin
            ALU_ctr = ADD;
        end
        U_TYPE: begin
            ALU_ctr = ADD;
        end
        default: ALU_ctr = ADD;
    endcase

end

endmodule
