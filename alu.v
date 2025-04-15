//ALU
module alu (  
  input clk,
  input [3:0] ALU_ctr,
  input [31:0] ALU_srcA,   
  input  [31:0] ALU_srcB,       
  output reg [31:0] ALU_resp
);

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

always @(posedge clk) begin

  case(ALU_ctr)
    ADD: ALU_resp = ALU_srcA + ALU_srcB;       
    SUB: ALU_resp = ALU_srcA - ALU_srcB;         
    AND: ALU_resp = ALU_srcA & ALU_srcB;       
    OR: ALU_resp = ALU_srcA | ALU_srcB;         
    XOR: ALU_resp = ALU_srcA ^ ALU_srcB;       
    SLL: ALU_resp = ALU_srcA << ALU_srcB[4:0];  
    SLL_12: ALU_resp = ALU_srcA << 12;    
    SRL: ALU_resp = ALU_srcA >> ALU_srcB[4:0];  
    SRA: ALU_resp = $signed(ALU_srcA) >>> ALU_srcB[4:0];
    SLT: ALU_resp = ($signed(ALU_srcA) < $signed(ALU_srcB)) ? 32'd1 : 32'd0; 
    SLTU: ALU_resp = ($unsigned(ALU_srcA) < $unsigned(ALU_srcB)) ? 32'd1 : 32'd0; 
    
    default: ALU_resp = 32'd0;
  endcase

end

endmodule