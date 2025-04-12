module RegisterFile (    
  input [4:0] rs1,         
  input [4:0] rs2,         
  input [4:0] w,          
  input [31:0] data_in,    
  input we,          
  output reg [31:0] data_out1, 
  output reg [31:0] data_out2  
);

reg [31:0] regfile [0:31];

integer i;
initial begin
  for (i = 0; i < 32; i = i + 1)
    regfile[i] = 32'h00000000;
end

always @(*) begin
  if (we && w)  begin
    regfile[w] = data_in;
    $display("GRAVOU :", data_in, " x", w);
  end
  data_out1 = regfile[rs1]; 
  data_out2 = regfile[rs2];
    
end

endmodule