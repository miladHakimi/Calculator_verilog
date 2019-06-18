module operator_converter (
	input [7:0] in,
	output [7:0] out
);

localparam ADD = 0,
			SUB = 1,
			MULT = 2,
			DIV = 3;

assign out = (in == 8'd20) ? ADD : (in == 8'd21) ? SUB : (in == 8'd22) ? MULT : DIV;

endmodule