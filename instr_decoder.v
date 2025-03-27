//Instr Decoder
/*
  format: 
    0 - R-type
    1 - I-type
    2 - S-type
    3 - B-type
    4 - U-type
    5 - J-type
*/
  case (op)
    6'b0110011: 
    begin 
      format = 0;
      ALU_op = 0;
    end
    6'b0000011: 
    begin 
      format = 1;
      imm = {rs2, funct7};
    end
    6'b0010011: 
    begin 
      format = 1;
      imm = {rs2, funct7};
    end
    6'b1100111: 
    begin 
      format = 1;
      imm = {rs2, funct7};
    end
    6'b0100011: 
    begin 
      format = 2;
      imm = {rd, funct7};
    end
    6'b1100111: 
    begin 
      format = 3;
      imm = {rd[4:1], funct7[11], funct7[10:5], funct7[12]};
    end
    6'b0110011: 
    begin 
      format = 4;
      imm = {funct3, rs1, rs2, funct7};
    end
    6'b1101111: 
    begin 
      format = 5;
      imm = {funct3, rs1, rs2, funct7};
    end
    default: begin
      format = 0; //faz uma leitura como defalt
    end
  endcase
