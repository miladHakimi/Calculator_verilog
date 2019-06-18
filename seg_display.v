module seg_display (
	input rst,
	input clk,
	input start,
	input [7:0] in_data,

	output reg [6:0] data_out,
	output reg [4:0] seg_sel
);
	reg [15:0] counter;
	wire [6:0] low, high;
	reg started;
	always @(posedge(clk)) begin : proc_counter

		if(rst) begin
			counter <= 15'b0;
			seg_sel <= 5'b00001;
		end
		
		begin
			//if (started) begin
				counter <= counter + 1'b1;
				/*if(counter==16'd2000) begin
					seg_sel <= 5'b00010;
				end
				if(counter==16'd2000) begin 
					seg_sel <= 5'b00001;
					counter <= 16'b0;
				end*/
			//	if (seg_sel == 5'b00001)
					data_out = low;
			//	else if (seg_sel == 5'b00010)
				//	data_out = high;
			//end
		end
	end

	Bin_to_7Seg bin1(in_data[3:0], low);
	Bin_to_7Seg bin2(in_data[7:4], high);


endmodule