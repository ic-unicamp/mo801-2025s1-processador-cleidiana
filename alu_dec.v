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

//Definições FMT
parameter R_TYPE = 0;
parameter I_TYPE = 1;
parameter S_TYPE = 2;
parameter B_TYPE = 3;
parameter J_TYPE = 4;
parameter U_TYPE = 5;

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
        S_TYPE: begin
           ALU_ctr = ADD;
        end
        B_TYPE: begin
            ALU_ctr = SUB;
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
