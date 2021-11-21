module sync_w2r #(
	parameter ADDRSIZE = 4
)(
	output reg	[ADDRSIZE:0]	rwptr2,
	input wire	[ADDRSIZE:0]	wptr,
	input wire					rclk, rrst
);

reg [ADDRSIZE:0] rwptr1;

always @(posedge rclk or posedge rrst) begin
	if (rrst) begin
		{rwptr2, rwptr1} <= 0;
	end else begin
		{rwptr2, rwptr1} <= {rwptr1, wptr};
	end
end

endmodule