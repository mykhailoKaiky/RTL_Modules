module rptr_empty #(
	parameter ADDRSIZE = 4
)(
	input  wire					rinc, rclk, rrst,
	input  wire	[ADDRSIZE:0]	rwptr2,
	output wire	[ADDRSIZE-1:0]	raddr,
	output reg	[ADDRSIZE:0]	rptr,
	output reg					rempty
);

reg [ADDRSIZE:0] rbin, rgnext, rbnext;

// Grey code pointer
always @(posedge rclk or posedge rrst) begin
    if (rrst) begin
        rptr <= 0;
        rbin <= 0;
    end
    else begin
        rptr <= rgnext;
        rbin <= rbnext;
    end
end

always @(*) begin
    rbnext = (!rempty)? (rbin + rinc) : rbin;
    rgnext = (rbnext>>1)^rbnext; // binary to gray
end

// Memory read-address pointer
assign raddr = rbin[ADDRSIZE-1:0];

// FIFO empty on reset or when the next rptr == synchronized wptr
always @(posedge rclk or posedge rrst) begin
	if (rrst) begin
		rempty <= 1'b1;
	end else begin
		rempty <= (rgnext == rwptr2);
	end
end

endmodule