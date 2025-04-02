//ALU Decoder
module ALUDecoder (  
    input ALU_op,
    output reg [2:0] ALU_srcA,   
    output reg [2:0] ALU_srcB,       
    output reg [3:0] ALU_ctr
);

always @(*) begin
  case (ALU_op)
    0: 
    begin 
      ALU_srcA = 0;
      ALU_srcB = 2;
      ALU_ctr = 00;
    end
    1: 
    begin 
      ALU_srcA = 00;
      ALU_srcB = 00;
      ALU_ctr = 00;
    end
    2: 
    begin 
      ALU_srcA = 00;
      ALU_srcB = 00;
      ALU_ctr = 00;
    end
    3: 
    begin 
      ALU_srcA = 00;
      ALU_srcB = 00;
      ALU_ctr = 00;
    end
    4: 
    begin 
      ALU_srcA = 00;
      ALU_srcB = 00;
      ALU_ctr = 00;
    end
    5: 
    begin 
      ALU_srcA = 00;
      ALU_srcB = 00;
      ALU_ctr = 00;
    end
    default: begin
      ALU_srcA = 00;
      ALU_srcB = 00;
      ALU_ctr = 00;
    end
  endcase

end
endmodule
