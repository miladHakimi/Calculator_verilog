module convert_to_number
(
	input [7:0] num0,
	input [7:0] num1,
	input [7:0] num2,
	input [1:0] mode,
	output reg [7:0] out
);

always @(*) begin
	if (mode == 2'd0) begin
		out = num0;
	end
	else if (mode == 2'd1) begin
		out = num0*10 + num1;
	end
	else if (mode == 2'd2) begin
		out = num0*100 + num1*10 + num2;
	end
end

endmodule