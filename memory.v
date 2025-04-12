module memory(
  input clk,
  input [31:0] address,
  input [31:0] data_in,
  output [31:0] data_out,
  input we
);

reg [31:0] mem[0:1024]; // 16KB de memória
integer i;

assign data_out = mem[address[13:2]];

always @(posedge clk) begin
  if (we) begin
    mem[address[13:0]] = data_in;
    $display ("GRAVOU MEM: 0x%h", data_in, " ADDR: ", address[13:0]);
  end
end


initial begin
  for (i = 0; i < 1024; i = i + 1) begin
    mem[i] = 32'h00000000;
  end
  $readmemh("memory.mem", mem, 1, 5 );
end

endmodule
