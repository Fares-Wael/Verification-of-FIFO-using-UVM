module FIFO_sva (FIFO_if.DUT fifo_if);

logic [fifo_if.FIFO_WIDTH - 1:0] data_in;
logic clk, rst_n, wr_en, rd_en;
logic [fifo_if.FIFO_WIDTH - 1:0] data_out;
logic wr_ack, overflow;
logic full, empty, almostfull, almostempty, underflow;

parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
localparam max_fifo_addr = $clog2(FIFO_DEPTH);

assign clk = fifo_if.clk;
assign data_in = fifo_if.data_in;
assign rst_n = fifo_if.rst_n;
assign wr_en = fifo_if.wr_en;
assign rd_en = fifo_if.rd_en;
assign data_out = fifo_if.data_out;
assign wr_ack = fifo_if.wr_ack;
assign overflow = fifo_if.overflow;
assign full = fifo_if.full;
assign empty = fifo_if.empty;
assign almostfull = fifo_if.almostfull;
assign almostempty = fifo_if.almostempty;
assign underflow = fifo_if.underflow;

//output signals properties
property prop1;
	@(posedge clk) (! rst_n) |=> ((dut.wr_ptr === 0) && (dut.rd_ptr === 0) && (dut.count === 0));
endproperty

property prop2;
	@(posedge clk) disable iff (! rst_n) (wr_en && ! full) |=> (wr_ack);
endproperty

property prop3;
	@(posedge clk) disable iff (! rst_n) (wr_en && full) |=> (wr_ack === 0);
endproperty

property prop4;
	@(posedge clk) disable iff (! rst_n) (wr_en && full) |=> (overflow);
endproperty

property prop5;
	@(posedge clk) disable iff (! rst_n) (rd_en && empty) |=> (underflow);
endproperty

property prop6;
	@(posedge clk) disable iff (! rst_n) (dut.count == 0) |-> (empty);
endproperty

property prop7;
	@(posedge clk) disable iff (! rst_n) (dut.count == FIFO_DEPTH) |-> (full);
endproperty

property prop8;
	@(posedge clk) disable iff (! rst_n) (dut.count == FIFO_DEPTH - 1) |-> (almostfull)
endproperty

property prop9;
	@(posedge clk) disable iff (! rst_n) (dut.count == 1) |-> (almostempty);
endproperty

//internal counters properties
property prop10;
	@(posedge clk) disable iff (! rst_n) 
	(wr_en && ! rd_en && ! full) |=> ($stable(dut.rd_ptr) && ((dut.wr_ptr == $past(dut.wr_ptr) + 1'b1) || ($past(dut.wr_ptr) ==7 && dut.wr_ptr == 0)) && (dut.count == $past(dut.count) + 1'b1));
endproperty

property prop11;
	@(posedge clk) disable iff (! rst_n)
	(! wr_en && rd_en && ! empty) |=> ($stable(dut.wr_ptr) && ((dut.rd_ptr == $past(dut.rd_ptr) + 1'b1) || ($past(dut.rd_ptr) ==7 && dut.rd_ptr == 0)) && (dut.count == $past(dut.count) - 1'b1));
endproperty

property prop12;
	@(posedge clk) disable iff (! rst_n)
	(wr_en && rd_en && full) |=> ($stable(dut.wr_ptr) && ((dut.rd_ptr == $past(dut.rd_ptr) + 1'b1) || ($past(dut.rd_ptr) ==7 && dut.rd_ptr == 0)) && (dut.count == $past(dut.count) - 1'b1));
endproperty

property prop13;
	@(posedge clk) disable iff (! rst_n)
	(wr_en && rd_en && empty) |=> ($stable(dut.rd_ptr) && ((dut.wr_ptr == $past(dut.wr_ptr) + 1'b1) || ($past(dut.wr_ptr) ==7 && dut.wr_ptr == 0)) && (dut.count == $past(dut.count) + 1'b1));
endproperty

property prop14;
	@(posedge clk) disable iff (! rst_n)
	(! wr_en && ! rd_en && ! full && ! empty) |=> ($stable(dut.wr_ptr) && $stable(dut.rd_ptr) && $stable(dut.count));
endproperty
	  
prop1_assert : assert property (prop1);
prop2_assert : assert property (prop2);
prop3_assert : assert property (prop3);
prop4_assert : assert property (prop4);
prop5_assert : assert property (prop5);
prop6_assert : assert property (prop6);
prop7_assert : assert property (prop7);
prop8_assert : assert property (prop8);
prop9_assert : assert property (prop9);
prop10_assert : assert property (prop10);
prop11_assert : assert property (prop11);
prop12_assert : assert property (prop12);
prop13_assert : assert property (prop13);
prop14_assert : assert property (prop14);

prop1_cover : cover property (prop1);
prop2_cover : cover property (prop2);
prop3_cover : cover property (prop3);
prop4_cover : cover property (prop4);
prop5_cover : cover property (prop5);
prop6_cover : cover property (prop6);
prop7_cover : cover property (prop7);
prop8_cover : cover property (prop8);
prop9_cover : cover property (prop9);
prop10_cover : cover property (prop10);
prop11_cover : cover property (prop11);
prop12_cover : cover property (prop12);
prop13_cover : cover property (prop13);
prop14_cover : cover property (prop14);
endmodule