module core( // modulo de um core
  input clk, // clock
  input resetn, // reset que ativa em zero
  output reg [31:0] address, // endereço de saída
  output reg [31:0] data_out, // dado de saída
  input [31:0] data_in, // dado de entrada
  output reg we // write enable
);

wire [6:0] op; 
wire [2:0] funct3; 
wire [1:0] funct7;
wire [4:0] rd;
wire [4:0] rs1;
wire [4:0] rs2;
wire [31:0] imm;
wire ALU_op;
wire pc;
assign  we = 0;
assign  data_out = 32'h00000000;
assign  op = Adr[6:0];
assign  funct3 = Adr[14:12];
assign  rd = Adr[11:7];
assign  rs1 = Adr[19:15];
assign  rs2 = Adr[24:20];
assign  funct7 = Adr[31:25];
assign  immI = Adr[31:20];
assign  immS = {Adr[31:25], Adr[11:7]};
assign  immB = {Adr[12], Adr[30:25], Adr[11:8], Adr[11]};
assign  immU = Adr[31:12];
assign  immJ = {Adr[20], Adr[30:21], Adr[11], Adr[19:12]};
assign  ALU_op = 0;

//Main Controller
/*
  state: 
    0 - Fetch
    1 - Decode
    2 - MemAdr
    3 - MemRead
    4 - MemWB

*/
always @(posedge clk) begin
  if (resetn == 1'b0) 
    state = 0
  else begin  
    case (state)
      0: begin 
        state = 1;
        pc = next_pc;
      end
      1: begin 
      case (op)
        6'b0110011: begin //R-type
          format = 0;
        end
        6'b0000011: begin //I-type 
          format = 1;
        end
        6'b0010011: begin //I-type 
          format = 1;
        end
        6'b1100111: begin //I-type 
          format = 1;
        end
        6'b0100011: begin //S-type 
          format = 2;
        end
        6'b1100111: begin //B-type 
          format = 3;
        end
        6'b0110011: begin //U-type 
          format = 4;
        end
        6'b1101111: begin //J-type 
          format = 5;
        end
        default: begin
          format = 0; //faz uma leitura como defalt
        end
      endcase
      end
      2: begin 
        state =
      end
      3: begin 
        state =
      end
      4: begin
        state =
      end
      default: begin
        state = 0;
      end
    endcase
  end
end

always @(state) begin  
  case (state)
    0: begin 
      PCWrite = 0;
      AdrSrc = 0;
      memWrite = 0;
      IRWrite = 1;
      ResultSrc = 00;
      ALUControl = 00;
      ALUSrcA = 00;
      ALUSrcB =10;
      immSrc = 0;
      RegWrite = 0;
      PCnext  = pc + val;
    end
    1: begin 
      PCWrite = 0;
      AdrSrc = 0;
      memWrite = 0;
      IRWrite = 1;
      ResultSrc = 00;
      ALUControl = 00;
      ALUSrcA = 00;
      ALUSrcB =10;
      immSrc = 0;
      RegWrite = 0;
    end
    2: begin 
      PCWrite = 0;
      AdrSrc = 0;
      memWrite = 0;
      IRWrite = 1;
      ResultSrc = 00;
      ALUControl = 00;
      ALUSrcA = 00;
      ALUSrcB =10;
      immSrc = 0;
      RegWrite = 0;
    end
    3: begin 
      PCWrite = 0;
      AdrSrc = 0;
      memWrite = 0;
      IRWrite = 1;
      ResultSrc = 00;
      ALUControl = 00;
      ALUSrcA = 00;
      ALUSrcB =10;
      immSrc = 0;
      RegWrite = 0;
    end
    4:begin
      PCWrite = 0;
      AdrSrc = 0;
      memWrite = 0;
      IRWrite = 1;
      ResultSrc = 00;
      ALUControl = 00;
      ALUSrcA = 00;
      ALUSrcB =10;
      immSrc = 0;
      RegWrite = 0;
    end
    default: begin
      PCWrite = 0;
      AdrSrc = 0;
      memWrite = 0;
      IRWrite = 1;
      ResultSrc = 00;
      ALUControl = 00;
      ALUSrcA = 00;
      ALUSrcB =10;
      immSrc = 0;
      RegWrite = 0;
    end
  endcase
end

endmodule