module RegisterFile (
  input clk,               
  input resetn,            
  input [4:0] rs1,         
  input [4:0] rs2,         
  input [4:0] w,          
  input [31:0] data_in,    
  input we,          
  output reg [31:0] data_out1, 
  output reg [31:0] data_out2  
);

reg [31:0] regfile [0:31];

always @(posedge clk) begin
  begin
  if(we)
      registradores[w] = data_in;
    data_out1 = w[rs1]; 
    data_out2 = w[rs2];
  end 
end
