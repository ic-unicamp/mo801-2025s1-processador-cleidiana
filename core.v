module core( // modulo de um core
  input clk, // clock
  input resetn, // reset que ativa em zero
  output reg [31:0] address, // endereço de saída
  output reg [31:0] data_out, // dado de saída
  input [31:0] data_in, // dado de entrada
  output reg we // write enable
);
reg state;
wire [2:0] ALU_srcA;   
wire [2:0] ALU_srcB;       
wire [3:0] ALU_ctr; 
wire [6:0] op; 
wire [2:0] funct3; 
wire [1:0] funct7;
wire [4:0] rd;
wire [4:0] rs1;
wire [4:0] rs2;
wire [31:0] imm;
wire ALU_op;
reg pc;
reg pc_next;
reg pc_add;

assign  op = data_in[6:0];
assign  funct3 = data_out[14:12];
assign  rd = data_out[11:7];
assign  rs1 = data_out[19:15];
assign  rs2 = data_out[24:20];
assign  funct7 = data_out[31:25];
assign  immI = data_out[31:20];
assign  immS = {data_out[31:25], data_out[11:7]};
assign  immB = {data_out[12], data_out[30:25], data_out[11:8], data_out[11]};
assign  immU = data_out[31:12];
assign  immJ = {data_out[20], data_out[30:21], data_out[11], data_out[19:12]};

//Main Controller
/*
  state: 
    0 - Fetch
    1 - Decode
    2 - MemAdr
    3 - MemRead
    4 - MemWB

*/
parameter r_type = 7'b0110011;
ALUDecoder ad(  
  .ALU_srcA(ALU_srcA),   
  .ALU_srcB(ALU_srcB),       
  .ALU_ctr(ALU_ctr),
  .ALU_op(ALU_op)
);

always @(posedge clk) begin
  if (resetn == 1'b0) begin
    state = 0;
    pc = 1;
    end
  else begin
    //$display(op);
    case (state)
      0: begin 
        state = 1;
        pc = pc_next;
      end
      1: begin 
      case (op)
        r_type: begin //R-type
          if(funct3 == 3)begin
            state = 0;
            $display("soma");
          end
        end
        7'b0000011: begin //I-type 
          state = 1;
        end
        7'b0010011: begin //I-type 
          state = 1;
        end
        7'b1100111: begin //I-type 
          state = 1;
        end
        7'b0100011: begin //S-type 
          state = 2;
        end
        7'b1100111: begin //B-type 
          state = 3;
        end
        7'b0110011: begin //U-type 
          state = 4;
        end
        7'b1101111: begin //J-type 
          state = 5;
        end
        default: begin
          state = 0; //faz uma leitura como defalt
        end
      endcase
      end
      default: begin
        state = 0;
      end
    endcase
  end
end

always @(*) begin  
  //default values
  pc_add = 0;
  case (state)
    0: begin 
      pc_next  = pc + pc_add;
    end
    1: begin 
      pc_next  = pc;
    end
    default: begin
    end
  endcase
  end

endmodule