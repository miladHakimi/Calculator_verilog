module ROM(
	input rst,
	input [6:0] index,
	output [7:0] out);

	reg [7:0] rom [99:0];
	// initial begin
	// 	rom[0] = 8'd49;//1
	// 	rom[1] = 8'd43;//+
	// 	rom[2] = 8'd50;//2
	// end
	always @(posedge rst) begin
		if (rst) begin
			// reset
			rom[0] = 8'd2;//1
			rom[1] = 8'd0;//0			rom[1] = 8'd22;//0
			rom[2] = 8'd23;//0
			rom[3] = 8'd2;//*
			rom[4] = 8'd20;//1
			rom[5] = 8'd2;//0
			/*rom[6] = 8'd9;*/
			//rom[3] = 8'd43;//+
			//rom[4] = 8'd52;//4
			rom[6] = 8'd10;//#
		end
	end
	assign out = rom[index];
endmodule