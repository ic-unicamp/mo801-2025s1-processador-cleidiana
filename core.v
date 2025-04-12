module core( // modulo de um core
  input clk, // clock
  input resetn, // reset que ativa em zero
  output reg [31:0] address, // endereço de saída
  output reg [31:0] data_out, // dado de saída
  input [31:0] data_in, // dado de entrada
  output reg we // write enable
);

wire [31:0] ALU_resp;
reg [31:0] ALU_srcA;   
reg [31:0] ALU_srcB;    
wire [3:0] ALU_ctr_ad; 

wire [3:0] ALUOut; 
wire [6:0] op; 
wire [2:0] funct3; 
wire [6:0] funct7;
wire [4:0] rd;
wire [4:0] rs1;
wire [4:0] rs2;
wire [31:0] immI, immS, immB, immU, immJ;
reg [31:0] Adr;
reg [3:0] state = 0, state_next = 0;
reg [31:0] pc = 0;
reg [31:0] pc_next = 4;
reg [31:0] pc_add;
reg PCWrite;
reg AdrSrc, MemWrite;
reg [31:0] instr;    
reg IRWrite;
reg ResultSrc = 0;
reg ImmSrc = 0;
reg RegWrite = 0;

// Associação das variaveis de acordo com a instrução 
assign  op = instr[6:0];
assign  funct3 = instr[14:12];
assign  rd = instr[11:7];
assign  rs1 = instr[19:15];
assign  rs2 = instr[24:20];
assign  funct7 = instr[31:25];
assign immI = {{20{instr[31]}}, instr[31:20]};
assign immS = {{20{instr[31]}}, instr[31:25], instr[11:7]};
assign immB = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
assign immU = {instr[31:12], 12'b0};
assign immJ = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};

// Definição log para debug
parameter DEBUG = 0;
parameter DEBUG_ST = 0;

// Definições estados da maquina de estados
parameter IDLE = 0;
parameter FETCH = 1;
parameter DECODE = 2;
parameter MEMADR = 3;
parameter MEMREAD = 4;
parameter MEMWB = 5;
parameter MEMWRITE = 6;
parameter EXECUTE = 7;
parameter ALUWB = 8;

//Definições FMT
parameter R_TYPE = 0;
parameter I_TYPE = 1;
parameter S_TYPE = 2;
parameter B_TYPE = 3;
parameter J_TYPE = 4;
parameter U_TYPE = 5;

reg [31:0] regis[0:31];
wire zero;
wire [31:0] data_out1;
wire [31:0] data_out2;
reg [4:0] reg_w;
 
reg [3:0] fmt;

alu_dec dec(  
  .funct3(funct3),   
  .funct7(funct7),       
  .fmt(fmt),
  .ALU_ctr(ALU_ctr_ad)
);

alu ad(  
  .ALU_srcA(ALU_srcA),   
  .ALU_srcB(ALU_srcB),       
  .ALU_ctr(ALU_ctr_ad),
  .ALU_resp(ALU_resp),
  .zero(zero)
);

RegisterFile regisFile(     
  .rs1(rs1),         
  .rs2(rs2),         
  .w(reg_w),          
  .data_in(data_out),    
  .we(RegWrite),          
  .data_out1(data_out1), 
  .data_out2(data_out2) 
);

// Verifica se precisa atualizar o PC
always @(posedge clk) begin

  if (!resetn)begin
    if(state != IDLE) if(DEBUG_ST) $display("RESET");
    state = IDLE;
    pc = 0;
  end

  else begin
    state = state_next;
     
    if (PCWrite) begin
      pc = pc_next;
      if(DEBUG) $display("PROXIMO PC: ", pc);
    end
    if (IRWrite) begin
      instr = data_in;
      if(DEBUG) $display("INST: ", instr);
    end
    
  end

end

// Maquina de estado
always @(*) begin  

  // Valores default 
  PCWrite = 0;
  IRWrite = 0; 
  AdrSrc = 0;  
  ALU_srcA = 0;
  ALU_srcB = 0;
  MemWrite = 0;
  ResultSrc = 0;
  ImmSrc = 0;
  RegWrite = 0;
  state_next = state; 
  reg_w = 0;

  case (state)

    IDLE: begin
      if(DEBUG_ST) $display("IDLE");
        state_next = FETCH;
    end

    FETCH: begin 
      if(DEBUG_ST) $display("FETCH");
      IRWrite = 1; 
      PCWrite = 1;
      pc_next = pc + 4;
      state_next = DECODE;
    end

    DECODE: begin 
      if(DEBUG_ST) $display("DECODE");
      case (op)
        7'b0110011: begin //R-type 
          if(DEBUG) $display("R-type");
          ALU_srcA = data_out1;
          ALU_srcB = data_out2;
          state_next = EXECUTE;
          data_out = ALU_resp;
          fmt = R_TYPE;
        end
        7'b0010011: begin //I-type 
          if(DEBUG) $display("I-type");
          ALU_srcA = data_out1; 
          ALU_srcB = immI;      
          state_next = EXECUTE;
          data_out = ALU_resp;
          fmt = I_TYPE;
        end
        7'b0000011: begin //I-type 
          if(DEBUG) $display("I-type");
          state_next = EXECUTE;
          data_out = ALU_resp;
          fmt = I_TYPE;
        end
        7'b1110011 : begin //I-type 
          if(DEBUG) $display("I-type");
          ALU_srcA = data_out1;
          ALU_srcB = data_out2;
          data_out = ALU_resp;
          state_next = EXECUTE;
          fmt = I_TYPE;
        end
        7'b0100011 : begin //S-type 
          if(DEBUG) $display("S-type");
          ALU_srcA = data_out1;
          ALU_srcB = immS;
          data_out = data_out2;
          state_next = MEMADR;
          AdrSrc = 1;
          MemWrite = 1;
          fmt = S_TYPE;
        end
        7'b1100011 : begin //B-type 
          if(DEBUG) $display("B-type");
          ALU_srcA = data_out1;
          ALU_srcB = data_out2;
          state_next = EXECUTE;
          fmt = B_TYPE;
        end
        7'b1101111 : begin //J-type 
          if(DEBUG) $display("J-type");
          state_next = FETCH;
          PCWrite = 1;
          pc_next = immJ;
          fmt = J_TYPE;
        end
        7'b0110111 : begin //U-type 
          if(DEBUG) $display("U-type");
          ALU_srcA = data_out1;
          ALU_srcB = data_out2;
          state_next = EXECUTE;
          fmt = U_TYPE;
        end
      default: begin
        if(DEBUG) $display("DEFAULT");
        state_next = FETCH;
      end
    endcase
    
    end

    MEMADR: begin 
      if(DEBUG_ST) $display("MEMADR");
      if (op == 7'b0000011)
          state_next = MEMREAD;
      else
          state_next = MEMWRITE;
    end

    MEMREAD: begin 
      if(DEBUG_ST) $display("MEMREAD");
      AdrSrc = 1;
      state_next = MEMWB;
    end
    MEMWB: begin 
      if(DEBUG_ST) $display("MEMWB");
      state_next = FETCH;
    end
    MEMWRITE: begin 
      if(DEBUG_ST) $display("MEMWRITE");
      state_next = FETCH;
    end
    EXECUTE: begin 
      if(DEBUG_ST) $display("EXECUTE");
      state_next = ALUWB;
    end
    ALUWB: begin
      if(DEBUG_ST) $display("ALUWB");
      reg_w = rd;
      RegWrite = 1;
      state_next = FETCH;
    end
    default: begin
      if(DEBUG_ST) $display("DEFAULT VAI FETCH");
      state_next = FETCH;
    end

  endcase

  address = (AdrSrc) ? ALU_resp : pc_next;
  we = MemWrite;
  
end

endmodule