module calc_tb();
	reg clk=0;
	reg rst;
	reg start;
	wire [6:0] seg_out;
	wire  [4:0] seg_sel;
	wire LED1;
	wire LED2;
	wire LED3;
	calculator calc(clk, rst, start, done, seg_out, seg_sel, LED1, LED2, LED3);


	initial repeat(100) #100 clk = ~clk;

	initial begin
		rst = 0;
		clk = 0;
		start = 0;
		@(posedge clk);
		@(posedge clk);
		rst = 1;
		@(posedge clk);
		rst = 0;
		@(posedge clk);
		start = 1;
		@(posedge clk);
		start = 0;
		@(posedge done); 
		repeat(10) @(posedge clk);
		$stop;
	end
endmodule