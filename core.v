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
reg [31:0] pc_next = 0;
reg [31:0] pc_add;
reg PCWrite;
reg AdrSrc, LinkReg, Branch, weMem;
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
parameter EXECUTE_B = 9;
parameter EXECUTE_J = 10;
parameter EXECUTE_U = 11;
parameter EXECUTE_UP = 12;
parameter EXECUTE_JL = 13;

//Definições FMT
parameter R_TYPE = 0;
parameter I_TYPE = 1;
parameter IL_TYPE = 2;
parameter IE_TYPE = 3;
parameter S_TYPE = 4;
parameter B_TYPE = 5;
parameter J_TYPE = 6;
parameter JI_TYPE = 7;
parameter U_TYPE = 8;
parameter UP_TYPE = 9;

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
  .clk(clk),
  .ALU_srcA(ALU_srcA),   
  .ALU_srcB(ALU_srcB),       
  .ALU_ctr(ALU_ctr_ad),
  .ALU_resp(ALU_resp),
  .zero(zero)
);

RegisterFile regisFile(   
  .clk(clk),
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
      if(DEBUG) $display("PROXIMO PC: 0x%h", pc);
    end
    if (IRWrite) begin
      instr = data_in;
      if(DEBUG) $display("INST: 0x%h", instr);
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
  ResultSrc = 0;
  ImmSrc = 0;
  RegWrite = 0;
  state_next = state; 
  reg_w = 0;
  LinkReg = 0;
  pc_next = pc;
  Branch = 0;
  weMem = 0;

  case (state)

    IDLE: begin
      if(DEBUG_ST) $display("IDLE");
        state_next = FETCH;
    end

    FETCH: begin 
      //$display("FETCH 0x%h", pc_next);
      IRWrite = 1; 
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
          fmt = R_TYPE;
        end
        7'b0010011: begin //I-type 
          if(DEBUG) $display("I-type");
          ALU_srcA = data_out1; 
          ALU_srcB = immI;      
          state_next = EXECUTE;
          fmt = I_TYPE;
        end
        7'b0000011: begin //I-type LOAD
          if(DEBUG) $display("I-type LOAD");
          ALU_srcA = data_out1;
          ALU_srcB = immI;
          state_next = MEMADR;
          fmt = IL_TYPE;
        end
        7'b1110011 : begin //I-type Env
          if(DEBUG) $display("I-type Env");
          state_next = IDLE;
          fmt = IE_TYPE;
        end
        7'b0100011 : begin //S-type 
          if(DEBUG_ST) $display("S-type");
          ALU_srcA = data_out1;
          ALU_srcB = immS;
          state_next = MEMADR;
          fmt = S_TYPE;
        end
        7'b1100011 : begin //B-type 
          $display("B-type");
          ALU_srcA = pc_next;
          ALU_srcB = immB;
          state_next = EXECUTE_B;
          fmt = B_TYPE;
        end
        7'b1101111 : begin //J-type 
          ALU_srcA = pc; 
          ALU_srcB = 4; 
          state_next = EXECUTE_JL;
          fmt = J_TYPE;
        end
        7'b1100111 : begin //JI-type 
          if(DEBUG_ST) $display("JI-type");
          ALU_srcA = pc; 
          ALU_srcB = 4;   
          state_next = EXECUTE_JL;
          fmt = JI_TYPE;
        end
        7'b0110111 : begin //U-type 
          if(DEBUG) $display("U-type");
          ALU_srcA = immU;
          ALU_srcB = 12;
          state_next = EXECUTE_U;
          fmt = U_TYPE;
        end
        7'b0010111 : begin //U-type 
          if(DEBUG) $display("UP-type");
          ALU_srcA = immU;
          ALU_srcB = 12;
          state_next = EXECUTE_UP;
          fmt = U_TYPE;
        end
        7'b0001111 : begin //I-type 
          $display("FENCE");
          PCWrite = 1;
          state_next = FETCH;
        end
       
        default: begin
        if(DEBUG) $display("DEFAULT");
        PCWrite = 1;
        state_next = FETCH;
      end
    endcase
    
    end

    MEMADR: begin 
      if(DEBUG_ST) $display("MEMADR");
      AdrSrc = 1;
      if (op == 7'b0000011) begin //LOAD
        RegWrite = 1;  
        reg_w = rd;
        case (funct3)
          0: begin 
            case (address[1:0])
              2'b00: data_out = {{24{data_in[7]}},   data_in[7:0]};
              2'b01: data_out = {{24{data_in[15]}},  data_in[15:8]};
              2'b10: data_out = {{24{data_in[23]}},  data_in[23:16]};
              2'b11: data_out = {{24{data_in[31]}},  data_in[31:24]};
            endcase
          end
          1: begin 
            case (address[1])
              1'b0: data_out = {{16{data_in[15]}}, data_in[15:0]};
              1'b1: data_out = {{16{data_in[31]}}, data_in[31:16]};
            endcase
          end
          2: begin
            data_out = data_in;
          end
          4: begin 
            case (address[1:0])
              2'b00: data_out = {24'b0, data_in[7:0]};
              2'b01: data_out = {24'b0, data_in[15:8]};
              2'b10: data_out = {24'b0, data_in[23:16]};
              2'b11: data_out = {24'b0, data_in[31:24]};
            endcase
          end
          5: begin 
            case (address[1])
              1'b0: data_out = {16'b0, data_in[15:0]};
              1'b1: data_out = {16'b0, data_in[31:16]};
            endcase
          end
          default: begin
            data_out = 32'b0;
          end
        endcase
        state_next = MEMREAD;
      end else begin //STORE
        
        weMem = 1;
        case (funct3)
            0: begin
            case (address[1:0])
              2'b00: data_out = {data_in[31:8], data_out2[7:0]};
              2'b01: data_out = {data_in[31:16], data_out2[7:0], data_in[7:0]};
              2'b10: data_out = {data_in[31:24], data_out2[7:0], data_in[15:0]};
              2'b11: data_out = {data_out2[7:0], data_in[23:0]};
            endcase
            end
            1: begin
              case (address[1])
                1'b0: data_out = {data_in[31:16], data_out2[15:0]};
                1'b1: data_out = {data_out2[15:0], data_in[15:0]};
              endcase
            end
            2: begin
              data_out = data_out2;
            end
            
            default: data_out = data_out2;
        endcase
        state_next = MEMWRITE;
      end else begin
        PCWrite = 1;
        state_next = FETCH;
      end
          
    end

    MEMREAD: begin 
      if(DEBUG_ST) $display("MEMREAD");
      
      AdrSrc = 1;
      state_next = MEMWB;
    end
    
    MEMWB: begin 
      if(DEBUG_ST) $display("MEMWB");
      
      PCWrite = 1;
      state_next = FETCH;
    end
    
    MEMWRITE: begin 
      if(DEBUG_ST) $display("MEMWRITE");
      PCWrite = 1;
      state_next = FETCH;
    end
    
    EXECUTE: begin 
      if(DEBUG_ST) $display("EXECUTE");
      data_out = ALU_resp;
      state_next = ALUWB;
    end
   
    EXECUTE_J: begin 
      if(DEBUG) $display("EXECUTE J");
      LinkReg = 1;
      PCWrite = 1;
      state_next = FETCH;
    end
    
    EXECUTE_JL: begin 
      if(DEBUG) $display("EXECUTE JL");
      reg_w = rd;
      RegWrite = 1;
      if (op == 7'b1101111) begin
        ALU_srcA = pc; 
        ALU_srcB = immJ;  
      end else begin
        ALU_srcA = data_out1; 
        ALU_srcB = immI;  
      end
      data_out = ALU_resp;
      state_next = EXECUTE_J;
    end
    EXECUTE_B: begin 

      if(DEBUG_ST)  $display("EXECUTE_B 0x%h", pc);
      if (funct3 == 0) begin
        if(data_out1 == data_out2) begin
          Branch = 1;
        end
      end 
      else if (funct3 == 1) begin
        if(data_out1 != data_out2)begin
          Branch = 1;
        end
      end 
      else if (funct3 == 4) begin
        if($signed(data_out1) < $signed(data_out2))begin
          Branch = 1;
        end
      end 
      else if (funct3 == 5) begin
        if(($signed(data_out1) >= $signed(data_out2)))begin
          Branch = 1;
        end
      end 
      else if (funct3 == 6) begin
        if(data_out1 < data_out2)begin
          Branch = 1;
        end
      end 
      else if (funct3 == 7) begin
        if(data_out1 >= data_out2)begin
          Branch = 1;
        end
      end 
      PCWrite = 1;
      state_next = FETCH;
    end
    EXECUTE_U: begin
      data_out = ALU_resp;
      state_next = ALUWB;
    end
    EXECUTE_UP: begin
      ALU_srcA = ALU_resp;
      ALU_srcB = pc_next;
      state_next = EXECUTE_U;
      fmt = UP_TYPE;
    end
    ALUWB: begin
      if(DEBUG_ST) $display("ALUWB");
      reg_w = rd;
      RegWrite = 1;
      PCWrite = 1;
      state_next = FETCH;
    end
    default: begin
      if(DEBUG_ST) $display("DEFAULT VAI FETCH");
      PCWrite = 1;
      state_next = FETCH;
    end
  endcase

  we = weMem;

  address = (AdrSrc) ? ALU_resp : pc_next;

  pc_next = pc_next + 4;
  
  if (Branch || LinkReg) begin
      pc_next = ALU_resp;
  end 
  
  

end

endmodule