module stack #(parameter size = 100)(
	input rst,
	input clk,
	input [7:0] data_in,
	input push_en,
	input pop_en,
	output [7:0] data_out,
	output is_empty	
);
	reg [7: 0] mem[size-1:0];
	reg[7:0] sp;

	// always @(rst) begin : proc_rst
	// 	if (rst)
	// 		sp = 0;
	// end
	always @(posedge clk) begin : proc_push
		if (rst)
			sp <= 0;
		else
			if (push_en) begin
				mem[sp] = data_in;
				sp <= sp + 1;
			end
			if (pop_en) begin
					sp <= sp - 1'd1;
			end
	end
	assign is_empty = (sp == 0);
	assign data_out = mem[sp-1];
endmodule