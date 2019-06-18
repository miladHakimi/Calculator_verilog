module converter_ascii_number (
	input [7:0] ascii_in,
	output[7:0] number_out);
	
	assign number_out = ascii_in;
	
endmodule