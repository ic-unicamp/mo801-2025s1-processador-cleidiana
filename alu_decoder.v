//ALU Decoder

module ALUDecoder (  
    input [2:0] ALUSrcA,   
    input [2:0] ALUSrcB,       
    output [3:0] ALUCtr 
);
  case (ALU_op)
    0: 
    begin 
      ALUSrcA = 00;
      ALUSrcB = 10;
      ALUCtr = 00;
    end
    1: 
    begin 
      ALUSrcA = 00;
      ALUSrcB = 00;
      ALUOp = 00;
    end
    2: 
    begin 
      ALUSrcA = 00;
      ALUSrcB = 00;
      ALUOp = 00;
    end
    3: 
    begin 
      ALUSrcA = 00;
      ALUSrcB = 00;
      ALUOp = 00;
    end
    4: 
    begin 
      ALUSrcA = 00;
      ALUSrcB = 00;
      ALUOp = 00;
    end
    5: 
    begin 
      ALUSrcA = 00;
      ALUSrcB = 00;
      ALUOp = 00;
    end
    default: begin
      ALUSrcA = 00;
      ALUSrcB = 00;
      ALUOp = 00;
    end
  endcase


endmodule
