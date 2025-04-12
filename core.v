module core( // modulo de um core
  input clk, // clock
  input resetn, // reset que ativa em zero
  output reg [31:0] address, // endereço de saída
  output reg [31:0] data_out, // dado de saída
  input [31:0] data_in, // dado de entrada
  output reg we // write enable
);

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

reg [3:0] state = 0, state_next = 0;
reg [31:0] pc;
reg [31:0] pc_next;
reg [31:0] pc_add;
reg PCWrite;
reg AdrSrc;
reg [31:0] instr;    

// Associação das variaveis de acordo com a instrução 
assign  op = instr[6:0];
assign  funct3 = instr[14:12];
assign  rd = instr[11:7];
assign  rs1 = instr[19:15];
assign  rs2 = instr[24:20];
assign  funct7 = instr[31:25];
assign  immI = instr[31:20];
assign  immS = {instr[31:25], instr[11:7]};
assign  immB = {instr[12], instr[30:25], instr[11:8], instr[11]};
assign  immU = instr[31:12];
assign  immJ = {instr[20], instr[30:21], instr[11], instr[19:12]}; 

// Definição log para debug
parameter DEBUG = 0;

// Definições estados da maquina de estados
parameter IDLE = 0;
parameter FETCH = 1;
parameter DECODE = 2;
parameter MEMADR = 3;
parameter MEMREAD = 4;
parameter MEMWB = 5;

reg [31:0] registers[0:31];

ALUDecoder ad(  
  .ALU_srcA(ALU_srcA),   
  .ALU_srcB(ALU_srcB),       
  .ALU_ctr(ALU_ctr),
  .ALU_op(ALU_op)
);

// Primeiro always apenas atualiza o state
always @(posedge clk) begin

  if (!resetn) begin
    if(state != IDLE) if(DEBUG) $display("RESET");
    state = IDLE;
  end
  else  begin
    state = state_next;
  end

end

// Maquina de estado
always @(*) begin  

  case (state)

    IDLE: begin
      if(DEBUG) $display("IDLE");
        state_next = FETCH;
    end

    FETCH: begin 
      if(DEBUG) $display("FETCH");
      state_next = DECODE;
    end

    DECODE: begin 
      if(DEBUG) $display("DECODE");
      state_next = MEMADR;
    end

    MEMADR: begin 
      if(DEBUG) $display("MEMADR");
      state_next = MEMREAD;
    end

    MEMREAD: begin 
      if(DEBUG) $display("MEMREAD");
      state_next = MEMWB;
    end
    MEMWB: begin 
      if(DEBUG) $display("MEMWB");
    end
    
    default: begin
      state_next = 0;
    end

  endcase

end

endmodule