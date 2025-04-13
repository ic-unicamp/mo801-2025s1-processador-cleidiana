//ALU
module alu (  
    input [3:0] ALU_ctr,
    input [31:0] ALU_srcA,   
    input  [31:0] ALU_srcB,       
    output reg [31:0] ALU_resp,
    output zero
);

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
assign zero = (ALU_resp == 0);

always @(*) begin

  case(ALU_ctr)
    ADD: ALU_resp = ALU_srcA + ALU_srcB;       
    SUB: ALU_resp = ALU_srcA - ALU_srcB;         
    AND: ALU_resp = ALU_srcA & ALU_srcB;       
    OR: ALU_resp = ALU_srcA | ALU_srcB;         
    XOR: ALU_resp = ALU_srcA ^ ALU_srcB;       
    SLL: ALU_resp = ALU_srcA << ALU_srcB[4:0];   
    SRL: ALU_resp = ALU_srcA >> ALU_srcB[4:0];  
    SLT: ALU_resp = ($signed(ALU_srcA) < $signed(ALU_srcB)) ? 32'd1 : 32'd0; 
    BEQ: ALU_resp = ALU_srcA == ALU_srcB;  
    BNE: ALU_resp = ALU_srcA != ALU_srcB;  
    BLT: ALU_resp = ALU_srcA < ALU_srcB;  
    BGE: ALU_resp = ALU_srcA >= ALU_srcB;  
    BLTU: ALU_resp = ALU_srcA < ALU_srcB;  
    BGEU: ALU_resp = ALU_srcA >= ALU_srcB;  
    default: ALU_resp = 32'd0;
  endcase

end

endmodule
