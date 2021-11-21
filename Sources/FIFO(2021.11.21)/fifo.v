module fifo #(
	parameter DSIZE = 8,
	parameter ASIZE = 4
)(
	output wire	[DSIZE-1:0]	rdata,
	output wire				wfull,
	output wire				rempty,
	input  wire	[DSIZE-1:0] wdata,
	input  wire				winc, wclk, wrst,
	input  wire				rinc, rclk, rrst
);

wire [ASIZE-1:0] waddr, raddr;
wire [ASIZE:0] wptr, rptr, wrptr2, rwptr2;

sync_r2w #(ASIZE) Sync_Read_Shift_Registers(
	.wrptr2(wrptr2),
	.rptr(rptr),
	.wclk(wclk),
	.wrst(wrst)
);

sync_w2r #(ASIZE) Sync_Write_Shift_Registers(
	.rwptr2(rwptr2),
	.wptr(wptr),
	.rclk(rclk),
	.rrst(rrst)
);

fifomem #(DSIZE, ASIZE) FIFO_Memory(
	.rdata(rdata),
	.wdata(wdata),
	.waddr(waddr),
	.raddr(raddr),
	.wclken(winc),
	.wclk(wclk)
);

rptr_empty #(ASIZE) read_pointer_empty(
	.rempty(rempty),
	.raddr(raddr),
	.rptr(rptr),
	.rwptr2(rwptr2),
	.rinc(rinc),
	.rclk(rclk),
	.rrst(rrst)
);

wptr_full #(ASIZE) write_pointer_full(
	.wfull(wfull),
	.waddr(waddr),
	.wptr(wptr),
	.wrptr2(wrptr2),
	.winc(winc),
	.wclk(wclk),
	.wrst(wrst)
);

endmodule