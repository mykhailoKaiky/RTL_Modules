module fifomem #(
	parameter DATASIZE = 8, // Memory data word width
	parameter ADDRSIZE = 4 // Number of memory address bits
)(
	output wire [DATASIZE-1:0] rdata,
	input wire	[DATASIZE-1:0] wdata,
	input wire	[ADDRSIZE-1:0] waddr, raddr,
	input wire	wclken, wclk
);
 
reg [DATASIZE-1:0] MEM [0:(1<<ADDRSIZE)-1];
always @(posedge wclk) begin
	if (wclken) MEM[waddr] <= wdata;
end
assign rdata = MEM[raddr];

endmodule
